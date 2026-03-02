#!/bin/bash
# =====================================================
# GERADOR DE CÓDIGOS GRM MULTIJOGOS
# =====================================================

# Cores
VERDE='\033[0;32m'
AZUL='\033[0;34m'
AMARELO='\033[1;33m'
VERMELHO='\033[0;31m'
NC='\033[0m'

# Configurações
ARQUIVO_KEYS="/var/www/html/grm/codes.txt"
QUANTIDADE=50  # Quantos códigos gerar por padrão

# =====================================================
# FUNÇÕES
# =====================================================

cabecalho() {
    clear
    echo -e "${AZUL}"
    echo "╔════════════════════════════════════════╗"
    echo "║                                        ║"
    echo "║   GRM MULTIJOGOS - GERADOR DE KEYS    ║"
    echo "║                                        ║"
    echo "║   (33) 99161-9949                      ║"
    echo "║                                        ║"
    echo "╚════════════════════════════════════════╝"
    echo -e "${NC}"
    echo ""
}

gerar_codigo() {
    # Gera um código aleatório de 16 caracteres (letras e números)
    echo "GRM-$(cat /dev/urandom | tr -dc 'A-Z0-9' | fold -w 16 | head -n 1)"
}

gerar_lote() {
    local qtd=$1
    local arquivo=$2
    
    echo -e "${AMARELO}▶ Gerando $qtd códigos...${NC}"
    
    for i in $(seq 1 $qtd); do
        codigo=$(gerar_codigo)
        echo "$codigo|0|" >> "$arquivo"
        echo -e "  ${VERDE}✓${NC} $codigo"
    done
    
    echo -e "\n${VERDE}✅ $qtd códigos gerados com sucesso!${NC}"
}

listar_codigos() {
    local arquivo=$1
    
    if [ ! -f "$arquivo" ]; then
        echo -e "${VERMELHO}❌ Arquivo não encontrado!${NC}"
        return
    fi
    
    echo -e "${AZUL}📋 CÓDIGOS DISPONÍVEIS:${NC}\n"
    
    # Cabeçalho
    printf "%-25s %-10s %-20s\n" "CÓDIGO" "USADO" "DATA"
    echo "------------------------------------------------------------"
    
    # Lista códigos
    while IFS= read -r linha; do
        # Pula comentários
        [[ "$linha" =~ ^#.*$ ]] && continue
        
        IFS='|' read -r codigo usado data <<< "$linha"
        
        if [ "$usado" == "1" ]; then
            printf "${VERMELHO}%-25s %-10s %-20s${NC}\n" "$codigo" "SIM" "$data"
        else
            printf "${VERDE}%-25s %-10s %-20s${NC}\n" "$codigo" "NÃO" "-"
        fi
    done < "$arquivo"
}

mostrar_estatisticas() {
    local arquivo=$1
    
    if [ ! -f "$arquivo" ]; then
        echo -e "${VERMELHO}❌ Arquivo não encontrado!${NC}"
        return
    fi
    
    total=0
    usados=0
    disponiveis=0
    
    while IFS= read -r linha; do
        [[ "$linha" =~ ^#.*$ ]] && continue
        total=$((total + 1))
        
        IFS='|' read -r codigo usado data <<< "$linha"
        if [ "$usado" == "1" ]; then
            usados=$((usados + 1))
        else
            disponiveis=$((disponiveis + 1))
        fi
    done < "$arquivo"
    
    echo -e "\n${AZUL}📊 ESTATÍSTICAS:${NC}"
    echo "  Total de códigos: $total"
    echo -e "  ${VERDE}Disponíveis: $disponiveis${NC}"
    echo -e "  ${VERMELHO}Usados: $usados${NC}"
}

apagar_usados() {
    local arquivo=$1
    
    echo -e "${AMARELO}▶ Apagando códigos usados...${NC}"
    
    # Cria arquivo temporário
    temp_file=$(mktemp)
    
    # Copia apenas linhas com usados=0 ou comentários
    while IFS= read -r linha; do
        if [[ "$linha" =~ ^#.*$ ]]; then
            echo "$linha" >> "$temp_file"
            continue
        fi
        
        IFS='|' read -r codigo usado data <<< "$linha"
        if [ "$usado" == "0" ]; then
            echo "$linha" >> "$temp_file"
        fi
    done < "$arquivo"
    
    mv "$temp_file" "$arquivo"
    echo -e "${VERDE}✅ Códigos usados removidos!${NC}"
}

# =====================================================
# MENU PRINCIPAL
# =====================================================

while true; do
    cabecalho
    
    echo "Escolha uma opção:"
    echo ""
    echo "1) Gerar novos códigos"
    echo "2) Listar todos os códigos"
    echo "3) Ver estatísticas"
    echo "4) Apagar códigos usados"
    echo "5) Sair"
    echo ""
    read -p "Opção: " opcao
    
    case $opcao in
        1)
            echo ""
            read -p "Quantos códigos gerar? [50]: " qtd
            qtd=${qtd:-50}
            
            # Verifica se é número
            if ! [[ "$qtd" =~ ^[0-9]+$ ]]; then
                echo -e "${VERMELHO}❌ Digite um número válido!${NC}"
                sleep 2
                continue
            fi
            
            gerar_lote $qtd "$ARQUIVO_KEYS"
            echo ""
            read -p "Pressione ENTER para continuar..."
            ;;
        2)
            echo ""
            listar_codigos "$ARQUIVO_KEYS"
            echo ""
            read -p "Pressione ENTER para continuar..."
            ;;
        3)
            echo ""
            mostrar_estatisticas "$ARQUIVO_KEYS"
            echo ""
            read -p "Pressione ENTER para continuar..."
            ;;
        4)
            echo ""
            apagar_usados "$ARQUIVO_KEYS"
            echo ""
            read -p "Pressione ENTER para continuar..."
            ;;
        5)
            echo -e "\n${VERDE}✅ Até mais!${NC}\n"
            exit 0
            ;;
        *)
            echo -e "\n${VERMELHO}❌ Opção inválida!${NC}"
            sleep 2
            ;;
    esac
done