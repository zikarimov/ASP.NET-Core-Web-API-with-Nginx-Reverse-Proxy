:: Запуск PHP FastCGI
:: Если файл RunHiddenConsole.exe существует, то запускаем PHP через утилиту 
if exist "RunHiddenConsole.exe" (  
    :: PHP будет запущен в скрытом режиме  
    RunHiddenConsole.exe "php\php-cgi.exe" -b 127.0.0.1:9000 -c "php\php.ini" 
) else (  
    start php\php-cgi.exe -b 127.0.0.1:9000 -c "php\php.ini" 
) 
 
:: Запуск nginx 
cd nginx 
start nginx.exe
