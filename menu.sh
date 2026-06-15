#!/bin/bash
# Цвет фона
REDB="$(printf '\033[48;5;124m')"
GREENB="$(printf '\033[48;5;118m')"
YELLOWB="$(printf '\033[48;5;226m')"
SIRENB="$(printf '\033[48;5;135m')"
PURPLEB="$(printf '\033[48;5;')"
CYANB="$(printf '\033[48;5;')"
WHITEB="$(printf '\033[48;5;')"

# Цвет текста
RED="$(printf '\033[38;5;196m')"
GREEN="$(printf '\033[0;32m')"
YELLOW="$(printf '\033[0;33m')"
SIREN="$(printf '\033[0;34m')"
PURPLE="$(printf '\033[38;5;128m')"
CYAN="$(printf '\033[0;36m')"
WHITE="$(printf '\033[0;37m')"
BLACK="$(printf '\033[38;5;232m')"
RESET="$(printf '\033[0m')"
TIRE="$(printf '\033[4m')"


center_text() {

        # 1. Записываем входные данные
        local text="$1"
        # local color_code="${2:-}" # Если цвет не передан, будет пустая строка
        local color_code="${GREEN}"

        # 2. Определяем ширину терминала
        # tput cols — более надежный способ получить текущую ширину
        local terminal_width=$(tput cols 2>/dev/null || echo ${COLUMNS:-80})

        # 3. Считаем чистую длину текста (без учета цветовых). Это важно, если ты захочешь передать уже раскрашенную строку
        local clean_text=$(echo -e "$text" | sed 's/\x1b\[[0-9;]*m//g')
        local text_length=${#clean_text}

        # 4. Вычисляем отступ
        local padding=$(((terminal_width - text_length) / 2 ))

        # Проверка: если текст длиннее терминала, ставим отступ 0
        if (( padding < 0 )); then padding=0; fi

        # 5.
        # Вывод
        if [[ -n "$color_code" ]]; then
                # Печатаем пробелы, затем цвет, затем текст и сброс цвета
                printf '%*s' "$padding" ''
                echo -e "${color_code}${text}${RESET}"
        else
                printf '%*s%s\n' "$padding" '' "$text"
        fi
        echo ""  # Переход на новую строку в конце

}
# --- Интерактивное меню ---
show_menu() {
        while true; do
                clear
                echo -e "${CYAN}"
                center_text "===================================="
                center_text " ГЛАВНОЕ МЕНЮ "
                center_text "===================================="
                echo -e "${RESET}"

                echo -e "     ${CYANB}${YELLOW}[${RED}1${YELLOW}]${RESET} ${GREENB}${BLACK}Доп натройки${RESET}"
                echo -e "     ${YELLOW}[0]${RESET} ${RED}Выход${RESET}"
                echo ""

                read -p "$(echo -e ${SIREN}"  Выберите пункт меню (0-1): "${RESET})" choice

                case $choice in
                        1) show_menu_one ;;
                        0) clear; center_text "Выход..."; exit 0 ;;
                        *) echo -e "${RED}Неверный ввод, попробуйте снова.${RESET}"; sleep 1 ;;
                esac
        done
}

show_menu_one() {
        while true; do
                clear
                echo -e "${CYAN}"
                center_text "===================================="
                center_text " НАСТРОЙКА TERMUX "
                center_text "===================================="
                echo -e "${RESET}"

                echo -e "     ${YELLOW}[1]${RESET} ${GREENB}${BLACK}Вернуться обратно${RESET}"
                # echo -e "     ${YELLOW}[0]${RESET} ${RED}Выход${RESET}"
                echo ""

                read -p "$(echo -e ${SIREN}"  Выберите пункт меню (0-1): "${RESET})" choice

                case $choice in
                        1) show_menu ;;
                        # 0) clear; center_text "Выход..."; exit 0 ;;
                        *) echo -e "${RED}Неверный ввод, попробуйте снова.${RESET}"; sleep 1 ;;
                esac
        done
}
 show_menu
