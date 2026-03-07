#!/bin/bash

# ============================================
# INSTALADOR GRM MULTIJOGOS
# By: (33) 991619949
# ============================================

# Cores - DEFINE ISSO AQUI PRIMEIRO CARALHO!
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
    echo -e "${VERM}[ERRO] Precisa ser root, porra!${RESET}"
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
else
    echo -e "${VERM}[ERRO] Falha no download do grm-commercial.tar.gz${RESET}"
    exit 1
fi

# Baixar batocera.conf
echo -e "${AMAR}[3/6] Baixando batocera.conf...${RESET}"
wget -q --show-progress "https://raw.githubusercontent.com/${GITHUB_USER}/${GITHUB_REPO}/main/batocera.conf" -O /userdata/system/batocera.conf

if [ $? -eq 0 ]; then
    echo -e "${VERD}[OK] batocera.conf instalado!${RESET}"
else
    echo -e "${VERM}[ERRO] Falha no download do batocera.conf${RESET}"
    exit 1
fi

# Baixar emulationstation
echo -e "${AMAR}[4/6] Baixando emulationstation...${RESET}"
wget -q --show-progress "https://raw.githubusercontent.com/${GITHUB_USER}/${GITHUB_REPO}/main/emulationstation" -O /usr/bin/emulationstation

if [ $? -eq 0 ]; then
    chmod +x /usr/bin/emulationstation
    echo -e "${VERD}[OK] emulationstation instalado!${RESET}"
else
    echo -e "${VERM}[ERRO] Falha no download do emulationstation${RESET}"
    exit 1
fi

# Baixar e copiar Evmapy.py (substituindo se existir)
echo -e "${AMAR}[5/6] Baixando Evmapy.py...${RESET}"
cd /tmp

# Verificar se arquivo já existe no destino e fazer backup (opcional)
DESTINO="/usr/lib/python3.12/site-packages/configgen/Evmapy.py"
if [ -f "$DESTINO" ]; then
    echo -e "${AMAR}Arquivo existente encontrado. Fazendo backup...${RESET}"
    cp "$DESTINO" "${DESTINO}.backup.$(date +%Y%m%d_%H%M%S)"
    echo -e "${VERD}[OK] Backup criado${RESET}"
fi

# Baixar o novo arquivo
wget -q --show-progress "https://raw.githubusercontent.com/${GITHUB_USER}/${GITHUB_REPO}/main/Evmapy.py"

if [ $? -eq 0 ]; then
    # Criar diretório de destino se não existir
    mkdir -p /usr/lib/python3.12/site-packages/configgen/
    
    # Copiar/substituir arquivo (forçando sobrescrita)
    cp -f Evmapy.py "$DESTINO"
    
    # Verificar se a cópia foi bem sucedida
    if [ -f "$DESTINO" ]; then
        echo -e "${VERD}[OK] Evmapy.py instalado/substituído com sucesso!${RESET}"
        
        # Definir permissões adequadas
        chmod 644 "$DESTINO"
        echo -e "${VERD}[OK] Permissões ajustadas${RESET}"
    else
        echo -e "${VERM}[ERRO] Falha ao copiar Evmapy.py${RESET}"
        exit 1
    fi
    
    # Limpar arquivo temporário
    rm -f Evmapy.py
else
    echo -e "${VERM}[ERRO] Falha no download do Evmapy.py${RESET}"
    exit 1
fi

# Iniciar EmulationStation
echo -e "${AMAR}[6/6] Iniciando EmulationStation...${RESET}"
/etc/init.d/S31emulationstation restart

echo ""
echo -e "${VERD}================================${RESET}"
echo -e "${VERD}  INSTALAÇÃO FINALIZADA PORRA!${RESET}"
echo -e "${VERD}================================${RESET}"
echo -e "${CIAN}GRM MULTIJOGOS - (33) 991619949${RESET}"
echo -e "${VERD}================================${RESET}"
