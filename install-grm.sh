#!/bin/bash

# ============================================
# INSTALADOR GRM MULTIJOGOS
# By: (33) 991619949
# ============================================

# Cores
VERM='\033[0;31m'
VERD='\033[0;32m'
AMAR='\033[1;33m'
AZUL='\033[0;34m'
CIAN='\033[0;36m'
RESET='\033[0m'

# Configuração do GitHub
GITHUB_USER="grm1992"
GITHUB_REPO="Instalador_GRM_MULTIJOGOS"

clear
echo -e "${CIAN}================================${RESET}"
echo -e "${VERD}   INSTALADOR GRM MULTIJOGOS${RESET}"
echo -e "${CIAN}================================${RESET}"
echo -e "${AZUL}Telefone: (33) 991619949${RESET}"
echo -e "${CIAN}================================${RESET}"
echo ""

# Verificar root
if [ "$EUID" -ne 0 ]; then 
    echo -e "${VERM}[ERRO] Precisa ser root!${RESET}"
    echo -e "${AMAR}Digite: sudo bash instalador_grm.sh${RESET}"
    exit 1
fi

# Parar EmulationStation
echo -e "${AMAR}[1/6] Parando EmulationStation...${RESET}"
/etc/init.d/S31emulationstation stop
sleep 2

# Baixar grm-commercial.tar.gz
echo -e "${AMAR}[2/6] Baixando grm-commercial.tar.gz...${RESET}"
cd /tmp
wget -q --show-progress "https://raw.githubusercontent.com/${GITHUB_USER}/${GITHUB_REPO}/main/grm-commercial.tar.gz"

if [ $? -eq 0 ]; then
    echo -e "${AMAR}Extraindo...${RESET}"
    tar -xzf grm-commercial.tar.gz -C /userdata/system/
    rm grm-commercial.tar.gz
    echo -e "${VERD}[OK] grm-commercial instalado!${RESET}"
    
    # Dar permissão ao watchdog.sh
    if [ -f "/userdata/system/grm-commercial/watchdog.sh" ]; then
        chmod +x "/userdata/system/grm-commercial/watchdog.sh"
        echo -e "${VERD}[OK] Permissões concedidas ao watchdog.sh${RESET}"
    else
        echo -e "${AMAR}[AVISO] watchdog.sh não encontrado em /userdata/system/grm-commercial/${RESET}"
    fi
else
    echo -e "${VERM}[ERRO] Falha no download do grm-commercial.tar.gz${RESET}"
    exit 1
fi

# Baixar emulationstation
echo -e "${AMAR}[3/6] Baixando emulationstation...${RESET}"
wget -q --show-progress "https://raw.githubusercontent.com/${GITHUB_USER}/${GITHUB_REPO}/main/emulationstation" -O /usr/bin/emulationstation

if [ $? -eq 0 ]; then
    chmod +x /usr/bin/emulationstation
    echo -e "${VERD}[OK] emulationstation instalado!${RESET}"
else
    echo -e "${VERM}[ERRO] Falha no download do emulationstation${RESET}"
    exit 1
fi

# Baixar e copiar S31emulationstation para /etc/init.d/
echo -e "${AMAR}[4/6] Baixando S31emulationstation...${RESET}"
cd /tmp

# Verificar se arquivo já existe no destino e fazer backup
DESTINO_INIT="/etc/init.d/S31emulationstation"
if [ -f "$DESTINO_INIT" ]; then
    echo -e "${AMAR}Arquivo existente encontrado. Fazendo backup...${RESET}"
    cp "$DESTINO_INIT" "${DESTINO_INIT}.backup.$(date +%Y%m%d_%H%M%S)"
    echo -e "${VERD}[OK] Backup criado${RESET}"
fi

# Baixar o novo arquivo S31emulationstation
wget -q --show-progress "https://raw.githubusercontent.com/${GITHUB_USER}/${GITHUB_REPO}/main/S31emulationstation"

if [ $? -eq 0 ]; then
    # Copiar/substituir arquivo
    cp -f S31emulationstation "$DESTINO_INIT"
    
    if [ -f "$DESTINO_INIT" ]; then
        chmod 755 "$DESTINO_INIT"
        echo -e "${VERD}[OK] S31emulationstation instalado/substituído com sucesso!${RESET}"
        echo -e "${VERD}[OK] Permissões ajustadas (755)${RESET}"
    else
        echo -e "${VERM}[ERRO] Falha ao copiar S31emulationstation${RESET}"
        exit 1
    fi
    
    rm -f S31emulationstation
else
    echo -e "${VERM}[ERRO] Falha no download do S31emulationstation${RESET}"
    exit 1
fi

# Iniciar EmulationStation
echo -e "${AMAR}[5/6] Iniciando EmulationStation...${RESET}"
batocera-save-overlay
/etc/init.d/S31emulationstation restart

echo -e "${AMAR}[6/6] Verificando permissões finais...${RESET}"
# Verificação adicional do watchdog.sh
if [ -f "/userdata/system/grm-commercial/watchdog.sh" ]; then
    chmod +x "/userdata/system/grm-commercial/watchdog.sh"
    echo -e "${VERD}[OK] Permissões verificadas${RESET}"
else
    echo -e "${AMAR}[AVISO] watchdog.sh não encontrado. Verifique a instalação do grm-commercial${RESET}"
fi
# Iniciar EmulationStation
echo -e "${AMAR}[5/5] Iniciando EmulationStation...${RESET}"
batocera-save-overlay
/etc/init.d/S31emulationstation start

echo ""
echo -e "${VERD}================================${RESET}"
echo -e "${VERD}  INSTALAÇÃO FINALIZADA${RESET}"
echo -e "${VERD}================================${RESET}"
echo -e "${CIAN}GRM MULTIJOGOS - (33) 991619949${RESET}"
echo -e "${VERD}================================${RESET}"
