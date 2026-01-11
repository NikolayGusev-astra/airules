#!/bin/bash
# order-docs.sh - Упорядочивание структуры документации

set -e

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

DRY_RUN=false
TARGET_DIR="."
CREATE_BACKUP=false
REORGANIZE=false
SORT_LIST=false

# Вспомогательные функции
print_header() {
    echo -e "${GREEN}📁 Упорядочивание документации${NC}"
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

# Парсинг аргументов
while [[ $# -gt 0 ]]; do
    case "$1" in
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --target)
            TARGET_DIR="$2"
            shift 2
            ;;
        --reorganize)
            REORGANIZE=true
            shift
            ;;
        --create-backup)
            CREATE_BACKUP=true
            shift
            ;;
        --sort-list)
            SORT_LIST=true
            shift 2
            ;;
        *)
            echo "Неизвестный аргумент: $1"
            echo "Использование: $0 [--target DIR] [--reorganize] [--create-backup] [--sort-list]"
            exit 1
            ;;
    esac
done

print_header

# Определение жанровой структуры
declare -A genre_dirs=(
    "tutorials:Tutorial обучающие"
    "how-to:How-to решение задач"
    "reference:Reference справочники"
    "explanation:Explanation концепции"
)

# Функция реорганизации
reorganize_docs() {
    if [ "$DRY_RUN" = true ]; then
        echo "${YELLOW}[DRY RUN]${NC} Был бы переписать:"
    fi
    
    backup_dir="${TARGET_DIR}.backup_$(date +%Y%m%d_%H%M%S)"
    
    # Создать бекап если нужно
    if [ "$CREATE_BACKUP" = true ]; then
        echo "📦 Создание бекапа в $backup_dir..."
        cp -r "$TARGET_DIR" "$backup_dir" 2>/dev/null
        print_success "Бекап создан: $backup_dir"
    fi
    
    # Переместить файлы в жанровые директории
    echo ""
    echo "📂 Перемещение файлов по жанрам..."
    
    moved_count=0
    
    for file in $(find "$TARGET_DIR" -maxdepth 1 -name "*.md" -type f); do
        filename=$(basename "$file")
        
        # Определить жанр по содержанию
        genre=$(classify_genre "$file")
        
        if [ -z "$genre" ]; then
            echo -e "${YELLOW}?${NC} $filename - жанр не определён"
            continue
        fi
        
        # Получить целевую директорию
        genre_dir=$(echo "${genre_dirs[@]}" | grep -E "^$genre:" | cut -d: -f2)
        
        if [ -z "$genre_dir" ]; then
            echo -e "${YELLOW}⚠️${NC} Неизвестный жанр: $genre для файла $filename"
            continue
        fi
        
        target_dir="$TARGET_DIR/$genre_dir"
        mkdir -p "$target_dir"
        
        # Переместить файл
        if [ "$DRY_RUN" = true ]; then
            echo "  [DRY] mv \"$file\" \"$target_dir/\""
        else
            mv "$file" "$target_dir/" && ((moved_count++))
            echo -e "  ${GREEN}✓${NC} $filename → $genre_dir/"
        fi
    done
    
    echo ""
    print_success "Упорядочено: $moved_count файлов перемещено"
    
    if [ "$DRY_RUN" = false ] && [ "$REORGANIZE" = true ]; then
        echo ""
        echo "📊 Новая структура:"
        find "$TARGET_DIR" -type d | sort | while read dir; do
            echo "  $dir/"
            find "$TARGET_DIR/$dir" -name "*.md" | wc -l | awk "{print \"    ($1 файлов)\"}"
        done
    fi
}

# Функция сортировки списка
sort_list_in_file() {
    local file="$1"
    local list_pattern="$2"
    
    echo "🔢 Сортировка списка в: $file"
    
    if [ "$DRY_RUN" = true ]; then
        echo "  [DRY] Сортировка списка \"$list_pattern\""
    fi
    
    # Найти начало списка
    list_start=$(grep -n "$list_pattern" "$file")
    if [ -z "$list_start" ]; then
        echo -e "${YELLOW}⚠️${NC} Паттерн не найден: $list_pattern"
        return 1
    fi
    
    list_line_num=$(echo "$list_start" | cut -d: -f1)
    
    # Читать весь файл
    content_before=$(head -n $((list_line_num - 1)) "$file")
    list_content=$(sed -n "${list_line_num},\$p" "$file")
    
    # Отсортировать по алфавиту
    sorted_list=$(echo "$list_content" | sed 's/^[-*] //' | sort)
    
    # Перезаписать
    if [ "$DRY_RUN" = true ]; then
        echo "  [DRY] Перезапись файла"
    else
        {
            # До списка
            head -n $((list_line_num - 1)) "$file"
            # Отсортированный список
            echo "$sorted_list"
            # После списка
            tail -n +$((list_line_num)) "$file"
        } > "$file" && print_success "Список отсортирован"
    fi
}

# Функция классификации жанра
classify_genre() {
    local file="$1"
    local content=$(cat "$file" | tr '[:upper:]' '[:lower:]')
    
    # Tutorial (обучающие пошаговые)
    if echo "$content" | grep -qEiE "шаг|учебник|tutorial|начало|завершение|введение|введение|шаг 1|шаг 2|шаг 3|шаг 4|шаг 5|шаг 6"; then
        echo "tutorial"
        return
    fi
    
    # How-to (решение конкретной задачи)
    if echo "$content" | grep -qEiE "как|как сделать|решение|как использовать|проблема|вопрос|как реализовать"; then
        echo "how-to"
        return
    fi
    
    # Reference (справочник/API)
    if echo "$content" | grep -qEiE "api|справочник|команда|таблица|список|конфигурация|параметры|опции|флаги"; then
        echo "reference"
        return
    fi
    
    # Explanation (концепции и "почему так")
    if echo "$content" | grep -qEiE "почему|концепция|принцип|объяснение|подход|архитектура|дизайн"; then
        echo "explanation"
        return
    fi
    
    # По умолчанию - reference
    echo "reference"
}

# Выполнение
if [ "$SORT_LIST" = true ]; then
    # Сортировка списка в файле
    sort_list_in_file "$TARGET_DIR/README.md" "-.*"
    sort_list_in_file "$TARGET_DIR/README.md" "- [а-яёе]"  # Русский алфавит
else
    # Реорганизация директорий
    reorganize_docs
fi

exit 0