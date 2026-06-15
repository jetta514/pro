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

termux_add() {
  file_test="$HOME/.test/setup_termux"
  if [ -f "$file_test" ]; then
	  clear
    # echo " Начальная настройка Termux уже выполнена "
    center_text " Начальная настройка Termux уже выполнена "
    sleep 2
  else
    cat > $HOME/.termux/termux.properties << 'EOF'
allow-external-apps = true
disable-terminal-session-change-toast = true
soft-keyboard-toggle-behaviour = enable
# fullscreen = true
terminal-cursor-blink-rate = 400
terminal-cursor-style = bar
shortcut.create-session = ctrl + 3
shortcut.next-session = ctrl + 2
shortcut.previous-session = ctrl + 1
terminal-onclick-url-open=true
EOF

    clear
    # echo -e "     Первичная настройка Termux"
    center_text "Первичная настройка Termux"
    sleep 3
    clear
    echo > $HOME/../usr/etc/motd
    termux-change-repo
	  sleep 1
	  termux-setup-storage
	  clear
          center_text " Первичная настройка Termux завершена"
          sleep 2
          clear
 center_text "Обновление Termux"
 sleep 2
clear
	  # pkg update && pkg upgrade -y
	  # pkg upgrade -y
	  pkg  upgrade -y -o Dpkg::Options::="--force-confold"
	  sleep 2
    clear
    # echo -e "     Обновление Termux"
    center_text "Обновление Termux завершено"
    sleep 2
    clear
 center_text "Установка важных утилит"
sleep 2
clear
	# pkg install root-repo x11-repo ncurses-utils git which nano dialog proot proot-distro python npm  wget curl -y
	pkg install root-repo x11-repo ncurses-utils git which nano wget curl -y

    mkdir -p  $HOME/.test
    touch $HOME/.test/setup_termux
	  clear
    center_text "Установка важных утилит завершено"
    sleep 2
    clear
  fi
}

# Функция центровки текста 
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

font_add() {

	clear
	center_text "Установка шрифта"
	sleep 3
	clear

	# Автоматическая установка готового шрифта
	mkdir -p ~/.termux
	wget https://github.com/romkatv/powerlevel10k-media/releases/download/v2.3.3/meslo-lgs-nf.tar.gz
	mkdir -p ~/fonts/
	tar -xzvf meslo-lgs-nf.tar.gz -C ~/fonts/
	cp  ~/fonts/'MesloLGS NF Bold.ttf' ~/.termux/font.ttf
	rm -rf ~/fonts meslo-lgs-nf.tar.gz
	termux-reload-settings
	clear
        center_text "Установка шрифта завешено"
        sleep 3
	clear

}

# Установка Daijin (аналог proot-distro)
daijin_add() {
	clear
	center_text "Установка Daijin"
	sleep 3
	clear
	pkg install jq coreutils file proot tar xz-utils gzip -y
	git clone https://github.com/RuriOSS/daijin.git && cd daijin
	sed -i '/pkg install/s/$/ -y/' ~/daijin/build.sh && ./build.sh
  arch="$(dpkg --print-architecture)"
	sleep 3
	clear
	sleep 3
	dpkg -i daijin-${arch}.deb
	clear
	center_text "Daijin установлен"
	sleep 3

}

# Настройка nano путем редактир. файла .nanorc
nano_add() {
  clear
	center_text "Настройка NANO"
	sleep 3
	clear
	mkdir -p ~/.back
	cat > $HOME/.nanorc << 'EOF'
set linenumbers  # отображение номеров строк слева от текста.
set tabsize 2  # установить размер табуляции в 2 пробела.
# set autoindent  # автоматический перенос отступа: при переходе на новую строку редактор скопирует отступ предыдущей строки.
set tabstospaces  # заменять символы табуляции на пробелы (рекомендуется для единообразия кода).
set fill 80  # задать максимальную длину строки в 80 символов; редактор может автоматически переносить длинные строки.
# set breaklonglines  # принудительный перенос длинных строк.
set positionlog  # сохранять позицию курсора (строка, столбец) при закрытии файла, чтобы при повторном открытии редактор открывал его на той же строке.
set historylog  # вести журнал действий (например, команд или изменений), чтобы можно было вернуться к предыдущим состояниям.
set atblanks  # автоматически вставлять пробелы вокруг операторов или после знаков препинания (зависит от синтаксиса языка).
set boldtext  # включить жирный шрифт для элементов интерфейса (например, заголовков или ключевых слов).
set indicator  # отображать индикаторы состояния (например, режим редактирования, кодировку файла).
set minibar  # включить мини‑панель (миниатюрную строку с подсказками или кнопками).
set softwrap  # включить мягкий перенос строк: длинные строки визуально переносятся на следующую строку без добавления символа переноса в текст.
set trimblanks  # удалять пробелы в конце строк при сохранении файла.
set titlecolor bold,yellow,blue  # настроить цвет заголовка окна: жирный текст жёлтого цвета на синем фоне.
set promptcolor lightwhite,grey
set statuscolor bold,white,green
set errorcolor bold,white,red
set spotlightcolor black,lightyellow
set selectedcolor lightwhite,magenta
set stripecolor #444
set scrollercolor cyan
set numbercolor cyan
set keycolor cyan
set functioncolor green
set smarthome
set backup
set backupdir "~/.back"
set bookstyle
set preserve
EOF
	clear
	center_text "Настройка NANO завершена"
	sleep 3
	clear

}

zsh_add() {
  clear
  center_text "Установка ZSH"
  sleep 2
  clear
        pkg install curl zsh git python eza bat -y
  echo "zsh" | chsh
  echo "y" | sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
  sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="af-magic"/g' ~/.zshrc

  # Установка подсветки синтаксиса Oh My Zsh

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME/.zsh-syntax-highlighting" --depth 1
  echo "source $HOME/.zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> "$HOME/.zshrc"

  # Плагин автодополнения для Oh My Zsh
  git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
  sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions)/g' ~/.zshrc

  echo "
alias ls='eza --icons'
alias ll='eza -l --icons'
alias cat='bat --style=plain'
alias q='exit'
alias h='cd ~/'
alias ..='cd ../'
alias c='clear'
alias rc='nano ~/.zshrc'
alias lm='ls -A'
alias os='daijin'
alias pri='proot-distro install '
alias prl='proot-distro login '
alias prr='proot-distro rename '
alias pr='proot-distro'
alias pro='nano /sdcard/newnew/pro.sh'
alias prod='cd /sdcard/newnew'
alias .pro='bash /sdcard/newnew/pro.sh'" >> ~/.zshrc

        clear
        center_text "ZSH установлен"
        sleep 2
  clear

}

fish_add() {
	clear
	center_text "Установка Fish"
	sleep 3
	clear
	pkg install curl fish git python eza bat -y
	echo "fish" | chsh
	curl	https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish
	sleep 3
	bash -c 'fish -c "omf update"'
	bash -c 'fish -c "omf install agnoster"'
	bash -c 'fish -c "set -U fish_greeting ''"'
	
	# Добавление иконок
	mkdir -p $HOME/.config/fish
	cat >  $HOME/.config/fish/symbols.fish << 'EOF'
# Статус и операции
set -gx ICON_SUCCESS \u2714    # ✔
set -gx ICON_ERROR   \u2718    # ✘
set -gx ICON_WARN    \u26a0    # ⚠
set -gx ICON_INFO    \u2139    # ℹ
set -gx ICON_LOAD    \uf01e    #  (Refresh)

# Навигация
set -gx ICON_ARROW   \u279c    # ➜
set -gx ICON_FOLDER  \uf413    # 
set -gx ICON_FILE    \uf15c    # 
set -gx ICON_LOCK    \uf023    # 

# Система и железо
set -gx ICON_CPU     \uf4bc    # 
set -gx ICON_RAM     \ufb19    # ﬙
set -gx ICON_SERVER  \uf233    # 

# Git
set -gx ICON_BRANCH  \ue0a0    # 
set -gx ICON_PULL    \uf418    # 
set -gx ICON_PUSH    \uf419    # 
EOF


	# Конфиг файл fish
	mkdir -p $HOME/.config/fish
	cat > $HOME/.config/fish/config.fish << 'EOF'
# Алиасы
if status is-interactive
  alias ls='eza --icons'
  alias ll='eza -l --icons'
  alias cat='bat --style=plain'
	alias q='exit'
	alias b='cd ..'
	alias h='cd ~/'
	alias ..='cd ../'
	alias c='clear'
	alias k='pkill "termux"'
	alias rc='nano ~/.config/fish/config.fish'
	alias .rc='cd ~/.config/fish'
	alias lm='ls -A'
	alias os='daijin'
	alias pri='proot-distro install '
	alias prl='proot-distro login '
	alias prr='proot-distro rename '
	alias pr='proot-distro'
	alias pro='nano /sdcard/newnew/pro.sh'
	alias .pro='bash /sdcard/newnew/pro.sh'
end

# Подключение файла с символами
if test -f ~/.config/fish/symbols.fish
	source ~/.config/fish/symbols.fish
end
EOF
	clear
	center_text "Fish установлен"
	sleep 2
  clear

}

# Установка Udocker
udocker_add() {
	clear
	center_text "Установка Udocker"
	sleep 3
	clear
	pkg install udocker -y
	udocker install
	clear
	center_text "Udocker установлен"
	sleep 3

}

# Мое добавление: современные утилиты (экстра)
extra_add() {
	clear
	center_text "Установка дополнительных утилит (eza, bat, fastfetch)"
	sleep 2
	pkg install eza bat fastfetch -y

	# Добавляем алиасы в Fish, если конфиг существует
	if [ -f "$HOME/.config/fish/config.fish" ]; then
		cat >> $HOME/.config/fish/config.fish << 'EOF'

# --- Extra Aliases ---
alias ls='eza --icons'
alias ll='eza -l --icons'
alias cat='bat --style=plain'
fastfetch
EOF
	fi
	clear
	center_text "Дополнительные утилиты установлены!"
	sleep 3
}

run_all() {
	termux_add
	nano_add
	fish_add
	style_add
	daijin_add
	udocker_add
	extra_add
	clear
	center_text "ГОТОВО: Все компоненты установлены"
	sleep 3
}

# --- Интерактивное меню ---
grand_menu() {
	while true; do
		clear
		echo -e "${CYAN}"
		center_text "===================================="
		center_text " TERMUX SETUP SCRIPT "
		center_text "===================================="
		echo -e "${RESET}"

		echo -e "     ${YELLOW}[1]${RESET} ${GREENB}${BLACK}Первичная настройка Termux${RESET}"
		echo -e "     ${YELLOW}[2]${RESET} ${GREENB}${BLACK}Установка SHELL${RESET}"
		echo -e "     ${YELLOW}[8]${RESET} ${GREEN}Установить всё сразу${RESET}"
		echo -e "     ${YELLOW}[0]${RESET} ${RED}Выход${RESET}"
		echo ""

		read -p "$(echo -e ${SIREN}"  Выберите пункт меню (0-8): "${RESET})" choice

		case $choice in
			1) termux_menu ;;
      2) shell_menu ;;
			0) clear; center_text "Выход..."; exit 0 ;;
			*) echo -e "${RED}Неверный ввод, попробуйте снова.${RESET}"; sleep 1 ;;
		esac
	done
}
# --- Интерактивное меню ---
termux_menu() {
	while true; do
		clear
		echo -e "${CYAN}"
		center_text "===================================="
		center_text " Первичная настройка Termux "
		center_text "===================================="
		echo -e "${RESET}"

		echo -e "     ${YELLOW}[1]${RESET} ${GREENB}${BLACK}Обновление Termux${RESET}"
		echo -e "     ${YELLOW}[2]${RESET} ${GREENB}${BLACK}Настройка Nano${RESET}"
		echo -e "     ${YELLOW}[3]${RESET} ${GREENB}${BLACK}Установка шрифта${RESET}"
		echo -e "     ${YELLOW}[4]${RESET} ${GREENB}${BLACK}Установить все${RESET}"
		echo -e "     ${YELLOW}[0]${RESET} ${RED}Назад${RESET}"
		echo ""

		read -p "$(echo -e ${SIREN}"  Выберите пункт меню (0-8): "${RESET})" choice

		case $choice in
			1) termux_add ;;
			2) nano_add ;;
			3) font_add ;;
			4) termux_add; nano_add; font_add ;;
			0) grand_menu ;;
			*) echo -e "${RED}Неверный ввод, попробуйте снова.${RESET}"; sleep 1 ;;
		esac
	done
}

shell_menu() {
	while true; do
		clear
		echo -e "${CYAN}"
		center_text "===================================="
		center_text " Установка SHELL "
		center_text "===================================="
		echo -e "${RESET}"

		echo -e "     ${YELLOW}[1]${RESET} ${GREENB}${BLACK}Установка FISH${RESET}"
		echo -e "     ${YELLOW}[2]${RESET} ${GREENB}${BLACK}Установка ZSH${RESET}"
		echo -e "     ${YELLOW}[4]${RESET} ${GREENB}${BLACK}Установить все${RESET}"
		echo -e "     ${YELLOW}[0]${RESET} ${RED}Назад${RESET}"
		echo ""

		read -p "$(echo -e ${SIREN}"  Выберите пункт меню (0-8): "${RESET})" choice

		case $choice in
			1) fish_add ;;
      2) zsh_add ;;
			0) grand_menu ;;
			*) echo -e "${RED}Неверный ввод, попробуйте снова.${RESET}"; sleep 1 ;;
		esac
	done
}
# Запуск меню при старте скрипта
grand_menu

