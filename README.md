# LA check
Проверка load average 

## About LA check
Скрипт написан для проверки load average группы серверов.

## Requirements

+ notify-send (Желательно выбрать notify-send от MATE так как он позволяет увидеть все уведомления сразу, а на Ubuntu это было проблемой)
+ Доступ по ключам к серверам, которые нужно мониторить
 
## Installing 

`$ git clone https://github.com/velgi/la_check`  
`$ mv variables.example variables`  

После переименования файла `variables.example` в файле `variables`нужно задать значение переменных под свои нужды.

## Using

`/bin/bash path/la_check.sh`  


## Details

Также, были подготовлены файлы для создания собственного systemd сервиса.
Сервис создан для установки из-под своего юзера (non-root).

Т.е. , примерная установка и использование выглядят так:

`$ mkdir -p ~/.config/systemd/user/default`  
`$ mv systemd.service/la_check.service ~/.config/systemd/user/`  
`$ mv systemd.service/la_check ~/.config/systemd/user/default/`  
`$ systemctl --user enable la_check`  
`$ systemctl --user start la_check`  

Переменные окружения, которые нужны для коректной работы сервиса и скрипта задаются в файле 
~/.config/systemd/user/default/la_check

Переменная `SCRIPT_DIR` задается относительно корневой директрии пользователя.
Т.е. для пользователя `user` с домашней директорией `/home/user` и расположением скрипта в `/home/user/scripts/la_check` значение переменной будет иметь вид `scripts/la_check`

Переменная `SSH_AUTH_SOCK` (используется, так как у ключа есть passphrase) может отличаться от дистрибутива к дистрибутиву, поэтому, советую ее проверять, например так:
`$ set | grep 'SSH_AUTH_SOCK'`   
