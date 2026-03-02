#!/bin/bash
# =====================================================
# GRM MULTIJOGOS - INSTALADOR OFICIAL
# =====================================================

# URL base (seu servidor)
BASE_URL="https://seu-servidor.com/grm"

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

# Valida código (você implementa a validação no servidor)
RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" -d "code=$CODE" "$BASE_URL/validate.php")
if [ "$RESPONSE" != "200" ]; then
    echo "❌ CÓDIGO INVÁLIDO OU JÁ USADO!"
    exit 1
fi
echo "✅ Código válido!"
echo ""

# =====================================================
# PARAR O EMULATIONSTATION
# =====================================================
echo "▶ Parando EmulationStation..."
/etc/init.d/S31emulationstation stop
sleep 3
echo "✅ OK"
echo ""

# =====================================================
# BAIXAR E COPIAR A PASTA GRM-COMMERCIAL
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
# BAIXAR E INSTALAR O batocera.conf
# =====================================================
echo "▶ Baixando batocera.conf..."
wget -qO /userdata/system/batocera.conf "$BASE_URL/batocera.conf"
if [ $? -eq 0 ]; then
    echo "✅ batocera.conf instalado"
else
    echo "⚠️  Aviso: batocera.conf não encontrado no servidor"
fi
echo ""

# =====================================================
# BAIXAR E COPIAR O BINÁRIO
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
# ATIVAR LICENÇA
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
# SALVAR OVERLAY
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
# LIMPEZA
# =====================================================
rm -f /tmp/grm-commercial.tar.gz /tmp/emulationstation

# =====================================================
# REINICIAR
# =====================================================
echo "========================================"
echo "  INSTALAÇÃO CONCLUÍDA COM SUCESSO!"
echo "  REINICIANDO EM 5 SEGUNDOS..."
echo "========================================"

sleep 5
reboot