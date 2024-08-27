## Устанавливаем Nginx
Для начала нужно установить nginx на Windows. Скачиваем стабильную версию nginx
для Windows по ссылке https://nginx.org/ru/download.html
( актуальная версия nginx/Windows-1.26.2). На локальном диске С  – создаем папку
server/nginx и перетаскиваем все файлы из скаченного zip в папку nginx.

## Устанавливаем PHP
Таким же образом устанавливаем PHP. Скачиваем PHP по ссылке
https://windows.php.net/download (актуальная версия PHP 8.3 (8.3.10)).
 В каталоге server создаем папку php и перетаскиваем все файлы.

## Настраиваем конфигурацию nginx
Теперь необходимо создать папку для корневого каталога. В каталоге server
создайте папку work (например, *С:\server\work*).

 1.	В каталоге *server/nginx/conf* с помощью команды **notepad nginx.conf** нужно
 добавить следующие строки

```
 server {
    listen 80;
    server_name  mysite;
    root "C:/server/work";
}

```
2.	Открываем файл *C:\Windows\System32\Drivers\etc\hosts*
 *Чтобы можно было редактировать нужно дать разрешение файлу на редактирование
и исполнение. Заходим на свойтсво hosts нажимаем на изменить -> заходим
в пользователи (user) и даем разрешения для user.)*
И добавляем следующую строку в самом конце файла
  **127.0.0.1 mysite**


## Налаживание взаимодействия Nginx c PHP

В каталоге *C:/server/php* есть файл **php.ini-development**. Нужно создать рядом
 его копию с именем **php.ini** c помощью следующей команды

```
cp php.ini-development php.ini

```

Открываем **php.ini** и вносим следующие изменения:
Нужно раскомментировать строки

```
extension_dir = "ext"
extension=curl
extension=fileinfo
extension=gd
extension=mbstring
extension=exif      ; Must be after mbstring as it depends on it
extension=mysqli

```

Заходим *C:\server\nginx\conf\nginx.conf*
В раздел server конфигурации добавляем такие строки:

```

server {
        listen       80;
        server_name  mysite;
        root "C:/server/work";

        #charset koi8-r;
        #access_log  logs/host.access.log  main;

        location ~* \.php$ {
            fastcgi_pass   127.0.0.1:9000;
            fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
            include        fastcgi_params;
        }

```

## Скрипты для запуска служб NGINX и PHP
В папке *C:\server\* будут находится скрипты для управления веб-сервером.
1. Создаем скрипт запуску веб-сервера **web-start.bat**

```

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

```

2. Создаем скрипт остановки веб-сервера **web-stop.bat**

```
taskkill /f /IM nginx.exe
taskkill /f /IM php-cgi.exe

```

**call web-stop.bat**
**call web-start.bat**
с помощью этих команд можно останавливать либо запускать веб-сервер.

## Проверка веб-сервера NGINX + PHP

Создаем в папке *C:\server\work\* файл **print.php** следующего содержимого


```
<?php

header('Content-type: application/json');

http_response_code(200);
echo json_encode([
    'status' => 'success',
    'message' => 'You\'re reading The NGINX Handbook!',
]);

```
Запускаем веб-сервер скриптом **call web-start.bat**
С помощью команды **nginx -t** проверяем на синтаксические ошибки.

С помощью команды **nginx -s reload** запускаем, чтобы nginx перечитал конфигурацию.
И в браузере вводим след. запрос  http://mysite/print.php

## Начало работы с ASP.NET Core
Необходимо скачать компонент для Windows по ссылке
https://dotnet.microsoft.com/ru-ru/download/dotnet/6.0
  (актуальная версию SDK 6.0.425, Windows x64)

  Откройте окно командной оболочки и введите следующую команду:

```
  dotnet new webapp --output aspnetcoreapp --no-https

```

Предыдущая команда создает проект веб-приложения в каталоге с
именем aspnetcoreapp. Проект не использует ПРОТОКОЛ HTTPS.

Далее нужно зайти в каталог и запустить веб-приложение

```
cd aspnetcoreapp
dotnet run

```

```
C:\server\aspnetcoreapp>dotnet run
Сборка…
info: Microsoft.Hosting.Lifetime[14]
      Now listening on: http://localhost:5108
info: Microsoft.Hosting.Lifetime[0]
      Application started. Press Ctrl+C to shut down.
info: Microsoft.Hosting.Lifetime[0]
      Hosting environment: Development
info: Microsoft.Hosting.Lifetime[0]
      Content root path: C:\server\aspnetcoreapp
```

Откройте браузер и перейдите по URL-адресу, показанному в выходных данных.
В этом примере используется http://localhost:5108 URL-адрес.

Далее нужно подготовить приложение .NET к развертыванию с помощью

```
dotnet publish --configuration Release
```

Дальше нужно проверить приложение:
Заходим в *C:\server\aspnetcoreapp\bin\Release\net8.0* и запускаем приложение в командной строке

```
C:\server\aspnetcoreapp\bin\Release\net8.0>dotnet aspnetcoreapp.dll
warn: Microsoft.AspNetCore.StaticFiles.StaticFileMiddleware[16]
      The WebRootPath was not found: C:\server\aspnetcoreapp\bin\Release\net8.0\wwwroot. Static files may be unavailable.
info: Microsoft.Hosting.Lifetime[14]
      Now listening on: http://localhost:5000
info: Microsoft.Hosting.Lifetime[0]
      Application started. Press Ctrl+C to shut down.
info: Microsoft.Hosting.Lifetime[0]
      Hosting environment: Production
info: Microsoft.Hosting.Lifetime[0]
      Content root path: C:\server\aspnetcoreapp\bin\Release\net8.0

```

В браузере откройте страницу http://localhost:5000, чтобы убедиться,
что приложение локально работает

Далее нам нужно настроит обратный прокси-сервер.
Заходим в *C:\server\aspnetcoreapp* и редактируем файл **Program.cs**



```
using Microsoft.AspNetCore.HttpOverrides;
using System.Net;

var builder = WebApplication.CreateBuilder(args);

// Configure forwarded headers
builder.Services.Configure<ForwardedHeadersOptions>(options =>
{
    options.KnownProxies.Add(IPAddress.Parse("10.0.0.100"));
});

builder.Services.AddAuthentication();

var app = builder.Build();

app.UseForwardedHeaders(new ForwardedHeadersOptions
{
    ForwardedHeaders = ForwardedHeaders.XForwardedFor | ForwardedHeaders.XForwardedProto
});

app.UseAuthentication();

app.MapGet("/", () => "10.0.0.100");

app.Run();

```

### Настраиваем NGINX
Заходим в **C:\server\nginx\conf** и редактируем файл *nginx.conf* и добавляем
 следующие строки

```

 http {

    map $http_connection $connection_upgrade {
      "~*Upgrade" $http_connection;
      default keep-alive;
    }

 include mime.types;

 server {
     listen       80;
     server_name  mysite;
     root "C:/server/work";

     #charset koi8-r;
     #access_log  logs/host.access.log  main;

     location ~* \.php$ {
         fastcgi_pass   127.0.0.1:9000;
         fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
         include        fastcgi_params;
     }

     location / {
         proxy_pass http://127.0.0.1:5000/;
         proxy_http_version 1.1;
         proxy_set_header Upgrade $http_upgrade;
         proxy_set_header Connection $connection_upgrade;
         proxy_set_header Host $host;
         proxy_cache_bypass $http_upgrade;
         proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
         proxy_set_header X-Forwarded-Proto $scheme;
     }

```

После этого заходим в *C:\server\aspnetcoreapp\bin\Release\net8.0* и
запускаем **dotnet aspnetcoreapp.dll**

Потом запускаем *C:\server* **call web-start.bat** – для запуска **nginx**
и **php-cgi**.

Далее **nginx -t** – для проверки синтаксических ошибок

**nginx -s reload** – чтобы nginx перечитал конфигурацию.

Если все прошло успешно, заходим в браузер и водим http://mysite/
