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
echo -e "${AMAR}[1/5] Parando EmulationStation...${RESET}"
/etc/init.d/S31emulationstation stop
sleep 2

# Baixar grm-commercial.tar.gz
echo -e "${AMAR}[2/5] Baixando grm-commercial.tar.gz...${RESET}"
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
echo -e "${AMAR}[3/5] Baixando batocera.conf...${RESET}"
wget -q --show-progress "https://raw.githubusercontent.com/${GITHUB_USER}/${GITHUB_REPO}/main/batocera.conf" -O /userdata/system/batocera.conf

if [ $? -eq 0 ]; then
    echo -e "${VERD}[OK] batocera.conf instalado!${RESET}"
else
    echo -e "${VERM}[ERRO] Falha no download do batocera.conf${RESET}"
    exit 1
fi

# Baixar emulationstation
echo -e "${AMAR}[4/5] Baixando emulationstation...${RESET}"
wget -q --show-progress "https://raw.githubusercontent.com/${GITHUB_USER}/${GITHUB_REPO}/main/emulationstation" -O /usr/bin/emulationstation

if [ $? -eq 0 ]; then
    chmod +x /usr/bin/emulationstation
    echo -e "${VERD}[OK] emulationstation instalado!${RESET}"
else
    echo -e "${VERM}[ERRO] Falha no download do emulationstation${RESET}"
    exit 1
fi

# Iniciar EmulationStation
echo -e "${AMAR}[5/5] Iniciando EmulationStation...${RESET}"
/etc/init.d/S31emulationstation start

echo ""
echo -e "${VERD}================================${RESET}"
echo -e "${VERD}  INSTALAÇÃO FINALIZADA PORRA!${RESET}"
echo -e "${VERD}================================${RESET}"
echo -e "${CIAN}GRM MULTIJOGOS - (33) 991619949${RESET}"
echo -e "${VERD}================================${RESET}"
