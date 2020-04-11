# LA check
Проверка load average 

## About LA check
Скрипт написан для проверки load average группы серверов.

## Requirements

+ notify-send (Желательно выбрать notify-send от MATE так как он позволяет увидеть все уведомления сразу, а на Ubuntu это было проблемой)
+ Доступ по ключам к серверам, которые нужно мониторить
 
## Installing 

`$ git clone https://github.com/velgi/la_check`  
`$ mv la_check variables.example variables`  

После переименования файла `variables.example` в файле `variables`нужно задать значение переменных под свои нужды.

## Using

`/bin/bash path/la_check.sh`  
