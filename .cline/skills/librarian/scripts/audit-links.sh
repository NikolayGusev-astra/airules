#!/bin/bash
# audit-links.sh - Аудит ссылок в документации

set -e

# Установить кодировку UTF-8
export LANG=C.UTF-8
export LC_ALL=C.UTF-8

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Переменные
TARGET_DIR="."
CHECK_INTERNAL=true
CHECK_EXTERNAL=false
CHECK_DUPLICATES=false
QUICK=false
REPORT_FILE=""

# Вспомогательные функции
print_header() {
    echo -e "${GREEN}🔗 Аудит ссылок в документации${NC}"
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

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_section() {
    echo ""
    echo -e "${GREEN}$1${NC}"
    echo "────────────────────────────────────────"
}

# Парсинг аргументов
while [[ $# -gt 0 ]]; do
    case "$1" in
        --target)
            TARGET_DIR="$2"
            shift 2
            ;;
        --check-internal)
            CHECK_INTERNAL=true
            shift
            ;;
        --check-external)
            CHECK_EXTERNAL=true
            shift
            ;;
        --check-duplicates)
            CHECK_DUPLICATES=true
            shift
            ;;
        --quick)
            QUICK=true
            CHECK_INTERNAL=true
            CHECK_EXTERNAL=false
            CHECK_DUPLICATES=false
            shift
            ;;
        --report)
            REPORT_FILE="$2"
            shift 2
            ;;
        *)
            echo "Неизвестный аргумент: $1"
            exit 1
            ;;
    esac
done

print_header

# Перенаправить вывод в файл если указан
if [ -n "$REPORT_FILE" ]; then
    exec > "$REPORT_FILE" 2>&1
fi

# ========================================
# 1. Аудит внутренних ссылок
# ========================================

if [ "$CHECK_INTERNAL" = true ]; then
    print_section "📄 Внутренние ссылки"
    
    broken_links=0
    total_internal=0
    
    # Создать отчёт
    declare -A link_targets
    declare -A link_sources
    
    for file in $(find "$TARGET_DIR" -name "*.md" -type f); do
        # Найти все внутренние ссылки [текст](путь)
        links=$(grep -oP '\[([^\]]+\]\(([^)]+\))' "$file" || true)
        
        if [ -n "$links" ]; then
            while IFS= read -r link; do
                # Извлечь путь ссылки
                link_path=$(echo "$link" | sed -n 's/.*\[\([^]]*\)\](\([^)]*\))/\2/p')
                
                # Пропустить внешние ссылки
                if [[ "$link_path" == http* ]] || [[ "$link_path" == https* ]] || [[ "$link_path" == mailto* ]]; then
                    continue
                fi
                
                ((total_internal++))
                
                # Пропустить пустые ссылки
                if [ -z "$link_path" ]; then
                    ((broken_links++))
                    echo -e "  ${RED}✗${NC} $(basename "$file") -> [пустая ссылка]"
                    continue
                fi
                
                # Преобразовать относительный путь
                file_dir=$(dirname "$file")
                if [[ "$link_path" == /* ]]; then
                    # Абсолютный путь от корня
                    resolved_path="${TARGET_DIR}${link_path}"
                else
                    # Относительный путь
                    resolved_path="${file_dir}/${link_path}"
                fi
                
                # Убрать якоря (#section)
                resolved_path="${resolved_path%%\#*}"
                
                # Проверить существует ли файл
                if [ -f "$resolved_path" ]; then
                    # Записать связь для анализа
                    link_sources["$link_path"]="${link_sources[$link_path]} $(basename "$file")"
                    link_targets[$(basename "$file")]="$(link_targets[$(basename "$file")} $link_path"
                else
                    ((broken_links++))
                    echo -e "  ${RED}✗${NC} $(basename "$file") -> $link_path (не найдено: $resolved_path)"
                fi
            done < <(echo "$links")
        fi
    done
    
    echo ""
    if [ $broken_links -gt 0 ]; then
        print_error "Битые внутренние ссылки: $broken_links"
    else
        print_success "Все внутренние ссылки корректны"
    fi
    
    echo -e "${BLUE}ℹ️${NC}  Всего внутренних ссылок: $total_internal"
fi

# ========================================
# 2. Аудит внешних ссылок
# ========================================

if [ "$CHECK_EXTERNAL" = true ]; then
    print_section "🌐 Внешние ссылки"
    
    broken_external=0
    total_external=0
    
    for file in $(find "$TARGET_DIR" -name "*.md" -type f); do
        # Найти все внешние ссылки [текст](url)
        links=$(grep -oP '\[([^\]]+\]\((https?://[^)]+)\))' "$file" || true)
        
        if [ -n "$links" ]; then
            while IFS= read -r link; do
                link_url=$(echo "$link" | sed -n 's/.*\[\([^]]*\)\](\([^)]*\))/\2/p')
                
                ((total_external++))
                
                # Проверить ссылку (curl HEAD запрос)
                if [ "$QUICK" = false ]; then
                    response_code=$(curl -s -o /dev/null -w "%{http_code}" --max-time 5 "$link_url" 2>/dev/null || echo "000")
                    
                    if [ "$response_code" != "200" ] && [ "$response_code" != "301" ] && [ "$response_code" != "302" ]; then
                        ((broken_external++))
                        echo -e "  ${RED}✗${NC} $(basename "$file") -> $link_url ($response_code)"
                    fi
                else
                    # Быстрая проверка - только перечислить ссылки
                    echo -e "  ${BLUE}→${NC} $(basename "$file") -> $link_url"
                fi
            done < <(echo "$links")
        fi
    done
    
    echo ""
    if [ $broken_external -gt 0 ]; then
        print_error "Битые внешние ссылки: $broken_external"
    else
        print_success "Все внешние ссылки проверены"
    fi
    
    echo -e "${BLUE}ℹ️${NC}  Всего внешних ссылок: $total_external"
fi

# ========================================
# 3. Проверка дублирования контента
# ========================================

if [ "$CHECK_DUPLICATES" = true ]; then
    print_section "📋 Дублирование контента"
    
    declare -A content_hashes
    declare -A file_by_hash
    duplicates_found=0
    
    for file in $(find "$TARGET_DIR" -name "*.md" -type f | sort); do
        # Считать контент и создать хеш
        content=$(cat "$file" | tr -d '[:space:]' | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]//g')
        hash=$(echo -n "$content" | md5sum | awk '{print $1}')
        
        # Если хеш уже есть - найдено дублирование
        if [ -n "${content_hashes[$hash]}" ]; then
            ((duplicates_found++))
            original_file="${file_by_hash[$hash]}"
            
            echo -e "  ${YELLOW}⚠️${NC} Дублирование:"
            echo -e "    Оригинал: $original_file"
            echo -e "    Дубликат:  $file"
            echo -e "    ${BLUE}ℹ️${NC}  Хеш: $hash"
        else
            content_hashes[$hash]="$file"
            file_by_hash[$hash]="$file"
        fi
    done
    
    echo ""
    if [ $duplicates_found -gt 0 ]; then
        print_warning "Обнаружено дублирование: $duplicates_found файлов"
        echo "  💡 Используйте: ./scripts/fix-style.sh --remove-jargon"
    else
        print_success "Дублирование не обнаружено"
    fi
fi

# ========================================
# 4. Анализ связей документов
# ========================================

if [ "$CHECK_INTERNAL" = true ]; then
    print_section "🔊 Анализ связей документов"
    
    # Орфаные документы (без входящих ссылок)
    orphaned_count=0
    popular_count=0
    
    declare -A incoming_links
    declare -A outgoing_links
    
    for file in $(find "$TARGET_DIR" -name "*.md" -type f); do
        filename=$(basename "$file")
        
        # Подсчитать исходящие ссылки
        if [ -n "${link_targets[$filename]}" ]; then
            count=$(echo "${link_targets[$filename]}" | wc -w)
            outgoing_links[$filename]=$count
            
            if [ $count -gt 5 ]; then
                ((popular_count++))
                echo -e "  ${GREEN}🔗${NC} $filename (исходящие: $count)"
            fi
        fi
        
        # Подсчитать входящие ссылки
        if [ -n "${link_sources[$filename]}" ]; then
            count=$(echo "${link_sources[$filename]}" | wc -w)
            incoming_links[$filename]=$count
        fi
    done
    
    # Найти орфаные документы
    echo ""
    echo -e "${BLUE}ℹ️${NC} Орфаные документы (без входящих ссылок):"
    for file in $(find "$TARGET_DIR" -name "*.md" -type f); do
        filename=$(basename "$file")
        if [ -z "${incoming_links[$filename]}" ]; then
            ((orphaned_count++))
            echo -e "  ${YELLOW}?${NC} $filename"
        fi
    done
    
    echo ""
    print_success "Анализ связей завершён"
    echo -e "${BLUE}ℹ️${NC}  Орфаные документы: $orphaned_count"
    echo -e "${BLUE}ℹ️${NC}  Популярные документы (>5 ссылок): $popular_count"
fi

# ========================================
# Итоговый отчёт
# ========================================

print_section "📊 Итоговая статистика"

total_docs=$(find "$TARGET_DIR" -name "*.md" -type f | wc -l)
echo "Всего документов: $total_docs"
echo "Целевая директория: $TARGET_DIR"

if [ "$CHECK_INTERNAL" = true ]; then
    echo "Битые внутренние ссылки: $broken_links"
    echo "Всего внутренних ссылок: $total_internal"
fi

if [ "$CHECK_EXTERNAL" = true ]; then
    echo "Битые внешние ссылки: $broken_external"
    echo "Всего внешних ссылок: $total_external"
fi

if [ "$CHECK_DUPLICATES" = true ]; then
    echo "Дублирование: $duplicates_found"
fi

# Код выхода
if [ $broken_links -gt 0 ] || [ $broken_external -gt 0 ] || [ $duplicates_found -gt 0 ]; then
    echo ""
    print_error "Аудит выявил проблемы!"
    if [ -n "$REPORT_FILE" ]; then
        echo -e "${BLUE}ℹ️${NC}  Отчёт сохранён в: $REPORT_FILE"
    fi
    exit 1
else
    echo ""
    print_success "Аудит завершён без проблем!"
    if [ -n "$REPORT_FILE" ]; then
        echo -e "${BLUE}ℹ️${NC}  Отчёт сохранён в: $REPORT_FILE"
    fi
    exit 0
fi