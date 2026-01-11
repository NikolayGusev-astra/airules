#!/bin/bash
# fix-style.sh - Автоматическое исправление стиля документации

set -e

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Переменные
TARGET_FILE=""
AUTO_FIX=false
ALL_DOCS=false
PASSIVE_TO_ACTIVE=true
BREAK_LONG_SENTENCES=true
REMOVE_JARGON=false

# Вспомогательные функции
print_header() {
    echo -e "${GREEN}🔧 Исправление стиля документации${NC}"
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
        --target)
            TARGET_FILE="$2"
            shift 2
            ;;
        --auto)
            AUTO_FIX=true
            shift
            ;;
        --all-docs)
            ALL_DOCS=true
            shift
            ;;
        --no-passive)
            PASSIVE_TO_ACTIVE=false
            shift
            ;;
        --no-sentences)
            BREAK_LONG_SENTENCES=false
            shift
            ;;
        --remove-jargon)
            REMOVE_JARGON=true
            shift
            ;;
        *)
            echo "Неизвестный аргумент: $1"
            echo "Использование: $0 [--target FILE] [--auto] [--all-docs]"
            exit 1
            ;;
    esac
done

print_header

# Определение файлов для обработки
if [ "$ALL_DOCS" = true ]; then
    files=$(find "." -name "*.md" -type f | sort)
elif [ -n "$TARGET_FILE" ]; then
    files="$TARGET_FILE"
else
    echo "Ошибка: Укажите --target FILE или --all-docs"
    exit 1
fi

# Функция исправления пассивного залога
fix_passive_voice() {
    local file="$1"
    local changes=0
    
    # Заменить пассивные конструкции на активные
    # "необходимо" → "нужно", "следует" → "сделай"
    sed -i.bak 's/необходимо нужно/g' "$file" && ((changes++))
    sed -i.bak 's/необходимо реализовать/реализуй/g' "$file" && ((changes++))
    sed -i.bak 's/необходимо выполнить/выполни/g' "$file" && ((changes++))
    sed -i.bak 's/следует сделать/сделай/g' "$file" && ((changes++))
    sed -i.bak 's/следует использовать/используй/g' "$file" && ((changes++))
    sed -i.bak 's/требуется выполнить/выполни/g' "$file" && ((changes++))
    sed -i.bak 's/требуется использовать/используй/g' "$file" && ((changes++))
    sed -i.bak 's/должен быть/должен быть/g' "$file" && ((changes++))
    
    # Удалить временный файл
    rm -f "${file}.bak"
    
    echo $changes
}

# Функция разбития длинных предложений
break_long_sentences() {
    local file="$1"
    local changes=0
    
    # Разбить предложения по разделителям и соединить новые
    # Это упрощённый подход - для более сложного нужен NLP
    awk '{
        n = split($0, sentences, /[.!?]/);
        result = "";
        for (i = 1; i <= n; i++) {
            # Разбить длинные предложения (>25 слов)
            words = split(sentences[i], w, " ");
            if (length(w) > 25) {
                # Добавить точку и разбить
                for (j = 1; j <= length(w); j++) {
                    result = result w[j];
                    if (j % 10 == 0 && j < length(w)) {
                        result = result ". ";
                    } else {
                        result = result " ";
                    }
                }
                if (i < n) result = result sentences[i+1];
            } else {
                if (i < n) result = result sentences[i] ".";
                else result = result sentences[i];
            }
        }
        print result;
    }' "$file" > "${file}.tmp" && mv "${file}.tmp" "$file" && ((changes++))
    
    echo $changes
}

# Функция удаления жаргона
remove_jargon() {
    local file="$1"
    local changes=0
    
    # Заменить жаргонизмы на понятные слова
    # Это пример - в реальном использовании нужен список жаргонизмов проекта
    sed -i.bak 's/orchestration layer/слой оркестрации/g' "$file" && ((changes++))
    sed -i.bak 's/idempotent operation/идемпотентная операция/g' "$file" && ((changes++))
    sed -i.bak 's/edge computing/edge computing/g' "$file" && ((changes++))
    sed -i.bak 's/middleware/мидлвар/g' "$file" && ((changes++))
    sed -i.bak 's/CDN/CDN (Content Delivery Network)/g' "$file" && ((changes++))
    
    # Удалить временный файл
    rm -f "${file}.bak"
    
    echo $changes
}

# Основной цикл обработки
total_files=0
total_changes=0

for file in $files; do
    ((total_files++))
    filename=$(basename "$file")
    
    echo ""
    echo "📄 Обработка: $filename"
    
    file_changes=0
    
    # 1. Исправление пассивного залога
    if [ "$PASSIVE_TO_ACTIVE" = true ]; then
        changes=$(fix_passive_voice "$file")
        if [ $changes -gt 0 ]; then
            echo -e "  ${GREEN}✓${NC} Пассивный залог → активный ($changes изменений)"
            ((file_changes+=changes))
        fi
    fi
    
    # 2. Разбитие длинных предложений
    if [ "$BREAK_LONG_SENTENCES" = true ]; then
        changes=$(break_long_sentences "$file")
        if [ $changes -gt 0 ]; then
            echo -e "  ${GREEN}✓${NC} Длинные предложения → разбиты ($changes изменений)"
            ((file_changes+=changes))
        fi
    fi
    
    # 3. Удаление жаргона
    if [ "$REMOVE_JARGON" = true ]; then
        changes=$(remove_jargon "$file")
        if [ $changes -gt 0 ]; then
            echo -e "  ${GREEN}✓${NC} Жаргон → пояснён ($changes изменений)"
            ((file_changes+=changes))
        fi
    fi
    
    ((total_changes+=file_changes))
    
    if [ $file_changes -gt 0 ]; then
        print_success "$filename исправлен ($file_changes изменений)"
    else
        echo -e "  ${YELLOW}○${NC} $filename - без изменений"
    fi
done

# Итоговая статистика
echo ""
echo "================================================"
echo "📊 Итоговая статистика:"
echo "  Всего обработано: $total_files файлов"
echo "  Всего изменений: $total_changes"

if [ "$AUTO_FIX" = true ]; then
    echo ""
    print_success "Автоисправление завершено!"
    echo ""
    echo "💡 Советы:"
    echo "  1. Проверьте изменения вручную"
    echo "  2. Убедитесь что смысл сохранился"
    echo "  3. Запустите ./scripts/validate-librarian.sh --check-style для проверки"
fi

exit 0