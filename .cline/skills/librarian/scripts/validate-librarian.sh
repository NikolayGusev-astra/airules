#!/bin/bash
# validate-librarian.sh - Валидация документации по Diátaxis и Docs-as-Code

set -e

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Переменные
CHECK_GENRE=false
CHECK_STRUCTURE=false
CHECK_STYLE=false
CHECK_LINKS=false
FULL_REPORT=false
OUTPUT_FILE=""
TARGET_DIR="."
REPORT_FILE=""

# Вспомогательные функции
print_header() {
    echo -e "${GREEN}🔍 Librarian: Валидация документации${NC}"
    echo "================================================"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_section() {
    echo ""
    echo -e "${YELLOW}$1${NC}"
    echo "------------------------------------------------"
}

# Парсинг аргументов
while [[ $# -gt 0 ]]; do
    case "$1" in
        --check-genre)
            CHECK_GENRE=true
            shift
            ;;
        --check-structure)
            CHECK_STRUCTURE=true
            shift
            ;;
        --check-style)
            CHECK_STYLE=true
            shift
            ;;
        --check-links)
            CHECK_LINKS=true
            shift
            ;;
        --full-report)
            FULL_REPORT=true
            shift
            ;;
        --quick)
            # Быстрая проверка (все проверки вкл.)
            CHECK_GENRE=true
            CHECK_STRUCTURE=true
            CHECK_STYLE=true
            CHECK_LINKS=true
            shift
            ;;
        --output)
            OUTPUT_FILE="$2"
            shift 2
            ;;
        --target)
            TARGET_DIR="$2"
            shift 2
            ;;
        *)
            echo "Неизвестный аргумент: $1"
            exit 1
            ;;
    esac
done

print_header

if [ -z "$OUTPUT_FILE" ]; then
    if [ "$FULL_REPORT" = true ]; then
        OUTPUT_FILE="docs/LIBRARIAN_AUDIT_REPORT.md"
    else
        OUTPUT_FILE="/tmp/librarian_validation.txt"
    fi
fi

# Перенаправить вывод в файл
exec > "$OUTPUT_FILE" 2>&1

# ========================================
# 1. Проверка обязательных секций (Structure)
# ========================================

if [ "$CHECK_STRUCTURE" = true ] || [ "$FULL_REPORT" = true ]; then
    print_section "📄 Проверка структуры документов"
    
    doc_count=0
    structure_ok=0
    structure_issues=0
    
    for file in $(find "$TARGET_DIR" -name "*.md" -type f); do
        ((doc_count++))
        
        # Проверка обязательных секций
        has_goal=$(grep -q "^## Цель" "$file" && echo "yes" || echo "no")
        has_scope=$(grep -q "^## Область охвата" "$file" && echo "yes" || echo "no")
        has_tldr=$(grep -q "^## TL;DR" "$file" && echo "yes" || echo "no")
        
        if [ "$has_goal" = "yes" ] && [ "$has_scope" = "yes" ] && [ "$has_tldr" = "yes" ]; then
            ((structure_ok++))
        else
            ((structure_issues++))
            echo -e "  ${RED}✗${NC} $(basename "$file") - нет обязательных секций (Цель, Scope, TL;DR)"
        fi
    done
    
    echo ""
    print_success "Проверено: $doc_count документов"
    echo "  С правильной структурой: $structure_ok ($((structure_ok * 100 / doc_count))%)"
    if [ $structure_issues -gt 0 ]; then
        print_error "Проблемы со структурой: $structure_issues"
    fi
fi

# ========================================
# 2. Проверка жанра документа (Genre)
# ========================================

if [ "$CHECK_GENRE" = true ] || [ "$FULL_REPORT" = true ]; then
    print_section "📚 Проверка жанра документов"
    
    tutorial_count=0
    howto_count=0
    reference_count=0
    explanation_count=0
    unclassified=0
    
    for file in $(find "$TARGET_DIR" -name "*.md" -type f); do
        # Определение жанра по ключевым словам
        content=$(cat "$file" | tr '[:upper:]' '[:lower:]')
        
        # Tutorial (обучающие пошаговые)
        tutorial_keywords="шаг|учебник|tutorial|начало|завершение|введение|введение|шаг 1|шаг 2|шаг 3|шаг 4|шаг 5|шаг 6"
        is_tutorial=$(echo "$content" | grep -qE "$tutorial_keywords" && echo "yes" || echo "no")
        
        # How-to (решение конкретной задачи)
        howto_keywords="как|как сделать|решение|как использовать|проблема|вопрос|как реализовать"
        is_howto=$(echo "$content" | grep -qE "$howto_keywords" && echo "yes" || echo "no")
        
        # Reference (справочник/API)
        reference_keywords="api|справочник|команда|таблица|список|конфигурация|параметры|опции|флаги"
        is_reference=$(echo "$content" | grep -qE "$reference_keywords" && echo "yes" || echo "no")
        
        # Explanation (концепции и "почему так")
        explanation_keywords="почему|концепция|принцип|объяснение|подход|архитектура|дизайн"
        is_explanation=$(echo "$content" | grep -qE "$explanation_keywords" && echo "yes" || echo "no")
        
        if [ "$is_tutorial" = "yes" ]; then
            ((tutorial_count++))
            echo -e "  ${GREEN}✓${NC} $(basename "$file") - Tutorial"
        elif [ "$is_howto" = "yes" ]; then
            ((howto_count++))
            echo -e "  ${GREEN}✓${NC} $(basename "$file") - How-to"
        elif [ "$is_reference" = "yes" ]; then
            ((reference_count++))
            echo -e "  ${GREEN}✓${NC} $(basename "$file") - Reference"
        elif [ "$is_explanation" = "yes" ]; then
            ((explanation_count++))
            echo -e "  ${GREEN}✓${NC} $(basename "$file") - Explanation"
        else
            ((unclassified++))
            echo -e "  ${YELLOW}?${NC} $(basename "$file") - Не классифицирован"
        fi
    done
    
    echo ""
    echo "📊 Распределение по жанрам:"
    echo "  Tutorial: $tutorial_count"
    echo "  How-to: $howto_count"
    echo "  Reference: $reference_count"
    echo "  Explanation: $explanation_count"
    echo "  Не классифицировано: $unclassified"
fi

# ========================================
# 3. Проверка качества стиля (Style)
# ========================================

if [ "$CHECK_STYLE" = true ] || [ "$FULL_REPORT" = true ]; then
    print_section "📝 Проверка качества стиля"
    
    active_voice_issues=0
    long_sentence_issues=0
    jargon_issues=0
    
    for file in $(find "$TARGET_DIR" -name "*.md" -type f); do
        # Проверка активного залога
        passive_voice=$(grep -c "необходимо|следует|требуется|необходимо реализовать" "$file" || echo "0")
        if [ "$passive_voice" -gt 0 ]; then
            ((active_voice_issues++))
            echo -e "  ${RED}✗${NC} $(basename "$file") - пассивный залог найден"
        fi
        
        # Проверка длинных предложений (>25 слов)
        long_sentences=$(grep -oP '[A-Z].*[^.!?]*[.!?]' "$file" | awk 'length > 25')
        if [ -n "$long_sentences" ]; then
            ((long_sentence_issues++))
            echo -e "  ${RED}✗${NC} $(basename "$file") - найдены длинные предложения"
        fi
        
        # Проверка жаргона (слова без объяснения)
        # Типичные жаргонизмы: orchestration, idempotent, orchestration, edge, CDN, etc.
        jargon=$(grep -oE "orchestration|idempotent|edge computing|cdn|middleware" "$file" | grep -c ":")
        if [ -n "$jargon" ]; then
            ((jargon_issues++))
            echo -e "  ${RED}✗${NC} $(basename "$file") - жаргон без объяснения"
        fi
    done
    
    echo ""
    print_success "Проверено стиль"
    if [ $active_voice_issues -gt 0 ]; then
        print_error "Пассивный залог: $active_voice_issues документов"
    fi
    if [ $long_sentence_issues -gt 0 ]; then
        print_error "Длинные предложения: $long_sentence_issues документов"
    fi
    if [ $jargon_issues -gt 0 ]; then
        print_error "Жаргон без объяснения: $jargon_issues документов"
    fi
fi

# ========================================
# 4. Проверка ссылок (Links)
# ========================================

if [ "$CHECK_LINKS" = true ] || [ "$FULL_REPORT" = true ]; then
    print_section "🔗 Проверка ссылок"
    
    broken_links=0
    duplicate_content=0
    total_links=0
    
    for file in $(find "$TARGET_DIR" -name "*.md" -type f); do
        # Найти все внутренние ссылки [текст](путь.md)
        links=$(grep -oP '\[([^\]]+\]\(([^)]+)\)' "$file" || true)
        
        if [ -n "$links" ]; then
            # Проверить каждую ссылку
            while IFS= read -r link; do
                link_text=$(echo "$link" | sed 's/.*\[\([^]]*\)\](\([^)]*\)/\1/')
                link_path=$(echo "$link" | sed 's/.*\[\([^]]*\)\](\([^)]*\)/\2/')
                
                # Проверить существует ли файл
                if [[ "$link_path" == http* ]] || [[ "$link_path" == https* ]]; then
                    # Внешняя ссылка - пропускаем
                    continue
                fi
                
                # Преобразовать относительный путь
                file_path="$TARGET_DIR/$link_path"
                
                if [ ! -f "$file_path" ]; then
                    ((broken_links++))
                    echo -e "  ${RED}✗${NC} $(basename "$file") -> $link_path (битая ссылка)"
                fi
            done < < <(echo "$links")
            
            # Подсчёт общего количества ссылок
            link_count=$(echo "$links" | wc -l)
            ((total_links+=link_count))
        fi
    done
    
    echo ""
    print_success "Проверено ссылки"
    if [ $broken_links -gt 0 ]; then
        print_error "Битые ссылки: $broken_links"
    fi
fi

# ========================================
# 5. Проверка дублирования контента (Duplicates)
# ========================================

if [ "$CHECK_LINKS" = true ] || [ "$FULL_REPORT" = true ]; then
    print_section "📋 Проверка дублирования"
    
    # Создать хеш контента для каждого файла
    declare -A content_hashes
    declare -A file_paths
    
    for file in $(find "$TARGET_DIR" -name "*.md" -type f | sort); do
        # Считать контент (нормализовать: убрать пробелы, нижний регистр)
        content=$(cat "$file" | tr -d '[:space:]' | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]//g')
        hash=$(echo -n "$content" | md5sum | awk '{print $1}')
        
        content_hashes["$hash"]="$file"
        file_paths["$hash"]="$file"
    done
    
    duplicates=0
    for hash in "${!content_hashes[@]}"; do
        # Если хеш встречается более 1 раза
        count=$(echo "${content_hashes[$hash]}" | wc -l)
        if [ $count -gt 1 ]; then
            ((duplicates++))
            file="${file_paths[$hash]}"
            echo -e "  ${YELLOW}⚠️${NC} Обнаружено дублирование: $file"
            echo -e "    ${NC}Хеш: $hash"
            echo -e "    ${NC}Дублируется в: $(echo "${content_hashes[$hash]}" | tr '\n' ',' | sed "s/$hash/  /g")"
        fi
    done
    
    echo ""
    if [ $duplicates -gt 0 ]; then
        print_error "Обнаружено $duplicates случаев дублирования"
    else
        print_success "Дублирования не найдено"
    fi
fi

# ========================================
# Итоговая статистика
# ========================================

print_section "📊 Итоговая статистика"

total_docs=$(find "$TARGET_DIR" -name "*.md" -type f | wc -l)
echo "Всего проверено: $total_docs документов"
echo "Целевая директория: $TARGET_DIR"

if [ "$FULL_REPORT" = true ]; then
    echo ""
    echo "💾 Полный отчёт сохранён в: $OUTPUT_FILE"
    
    # Вернуть код выхода
    if [ $broken_links -gt 0 ] || [ $duplicate_content -gt 0 ] || [ $structure_issues -gt 0 ] || [ $active_voice_issues -gt 0 ] || [ $long_sentence_issues -gt 0 ] || [ $jargon_issues -gt 0 ]; then
        exit 1
    else
        exit 0
    fi
else
    echo ""
    print_success "Валидация завершена успешно!"
fi