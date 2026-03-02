#!/bin/bash
# =====================================================
# GRM MULTIJOGOS - INSTALADOR OFICIAL
# =====================================================

# URL base (GitHub raw)
BASE_URL="https://raw.githubusercontent.com/guilhermeramosmartins-cloud/grm-instalador/main"

clear
echo "========================================"
echo "  GRM MULTIJOGOS - INSTALADOR v1.0"
echo "========================================"
echo ""

# =====================================================
# PEDIR CÓDIGO DE ACESSO
# =====================================================
echo "🔑 DIGITE SEU CÓDIGO DE ACESSO (1 uso):"
read -s CODE
echo ""

# Como não temos validate.php no GitHub, vamos fazer validação local
# CÓDIGOS VÁLIDOS (você edita manualmente)
VALID_CODES=(
    "GRM-8F3A2B1C9D4E5F6A"
    "GRM-1A2B3C4D5E6F7A8B"
    "GRM-C9F8E7D6C5B4A392"
    "GRM-TESTE-123"
)

VALID=0
for valid in "${VALID_CODES[@]}"; do
    if [ "$CODE" == "$valid" ]; then
        VALID=1
        break
    fi
done

if [ $VALID -eq 0 ]; then
    echo "❌ CÓDIGO INVÁLIDO!"
    exit 1
fi
echo "✅ Código válido!"
echo ""

# =====================================================
# PARANDOO EMULATIONSTATION
# =====================================================
echo "▶ Parando EmulationStation..."
/etc/init.d/S31emulationstation stop
sleep 3
echo "✅ OK"
echo ""

# =====================================================
# FAZENDO DOWNLOAD DO SISTEMA
# =====================================================
echo "▶ Baixando pasta grm-commercial..."
wget -qO /tmp/grm-commercial.tar.gz "$BASE_URL/grm-commercial.tar.gz"
if [ $? -ne 0 ]; then
    echo "❌ Falha no download!"
    exit 1
fi
echo "✅ Download concluído"

echo "▶ Extraindo para /userdata/system..."
tar -xzf /tmp/grm-commercial.tar.gz -C /userdata/system/
echo "✅ Pasta copiada"
echo ""

# =====================================================
# BAIXANDO E INSTALANDO DEPENDENCIAS
# =====================================================
echo "▶ Baixando batocera.conf..."
wget -qO /userdata/system/batocera.conf "$BASE_URL/batocera.conf"
if [ $? -eq 0 ]; then
    echo "✅ batocera.conf instalado"
else
    echo "⚠️  Aviso: batocera.conf não encontrado"
fi
echo ""

# =====================================================
# TRANSFERINDO ARQUIVOS
# =====================================================
echo "▶ Baixando novo binário..."
wget -qO /tmp/emulationstation "$BASE_URL/emulationstation"
if [ $? -ne 0 ]; then
    echo "❌ Falha no download do binário!"
    exit 1
fi
echo "✅ Download concluído"

echo "▶ Copiando para /usr/bin/..."
cp /tmp/emulationstation /usr/bin/emulationstation
chmod 755 /usr/bin/emulationstation
echo "✅ Binário instalado"
echo ""

# =====================================================
# ATIVANDO MULTIJOGOS
# =====================================================
echo "▶ Ativando licença..."
/usr/bin/emulationstation --chopper
if [ $? -eq 0 ]; then
    echo "✅ Licença ativada"
else
    echo "❌ Falha na ativação!"
    exit 1
fi
echo ""

# =====================================================
# SALVANDO...
# =====================================================
echo "▶ Salvando overlay..."
batocera-save-overlay 150
if [ $? -eq 0 ]; then
    echo "✅ Overlay salvo"
else
    echo "❌ Falha ao salvar overlay!"
    exit 1
fi
echo ""

# =====================================================
# LIMPEZA DE CASH
# =====================================================
rm -f /tmp/grm-commercial.tar.gz /tmp/emulationstation

# =====================================================
# REINICIANDO SISTEMA...
# =====================================================
echo "========================================"
echo "  INSTALAÇÃO CONCLUÍDA COM SUCESSO!"
echo "  REINICIANDO EM 5 SEGUNDOS..."
echo "========================================"

sleep 5
reboot