Установка Symfony на VagrantUp + nginx
========================

У кого не получилось поставить и запустить symfony 
--------------
**На windows**


Написал небольшую инструкция, методом проб и ошибок =)

* 0)  Если у вас на винде ваша учетная запись на русском – vagrant работать не будет.
Нужно изменить на латиницу, если не знаете как смотрите [**тут**][1]

* 0.1)  Качаем [**VagrantUp**][2]
* 0.2)  Качаем  [**virtualbox**][3] 
* 0.3)  Первым ставим [**virtualbox**][3]   затем [**VagrantUp**][2] (попросит перезагрузится - перезагружаемся)


* 1)  Качаем с этого репозитория настроенный **образ vagrant**
* 1.1) заходим в папку **.vagrant/machines/default/virtualbox/creator_uid**  - открываем этот файл любым редактором и меняем **501** на **0** сохраняем.
* 1.2) идем по пути `C:\Users\ваше_имя` Проверяем чтобы не было папок с такими названиями: **.vagrant.d, .VirtualBox, VirtualBox VMs** если они есть – удалите их.


* 2) Качаем [**git**][5]    - устанавливаем


* 3) заходим в Git Bash или CMD либо PowerShell
* 3.1) переходим в папку cо скаченым вагрантом п. 1) (я ее переименовал в **vg** ) , если она в корне вашего диска пишем `cd  c:/vg/` 
* 3.2) Далее пишем vagrant up и ждем пока установится.
* 3.3) После установки пишем `vagrant ssh`
* 3.4) Если очень долго тупит на входе ssh и потом выдает ошибку, вам нужно вкл. виртуализацию  [**bios virtualization enabled**][6] 
* 3.5) когда зашли на вириальную машину пишем: 
       `sudo curl -LsS https://symfony.com/installer -o /usr/local/bin/symfony`

       `sudo chmod a+x /usr/local/bin/symphony`
* 3.6) переходим в папку куда будет установлен проект: `cd /var/www/`
       в это папке пишем  `sudo symfony new shop`
       (shop –название моего проекта, называйте как хотите)


* 4) настраиваем nginx чтобы проект запускался по http://192.168.50.7/
* 4.1) переходим в папку c nginx где редактируем файл **default**:   
      `cd /etc/nginx/sites-enabled/`
      далее идем открываем файл **default** в редакторе:
      `sudo nano default`

* 4.2) Удаляем оттуда все, я делал это так: ставил курсор на самый первый символ зажимаем **alt** и держа его жме **mt**
* 4.3) Копируем вот это:
        (2-я строка где  `root /var/www/shop/web/;`     shop – название моего проекта который я создал ранее на шаге 3.6)
```
server {
    root /var/www/shop/web/;

    location / {
        # try to serve file directly, fallback to app.php
        try_files $uri /app.php$is_args$args;
    }
    # DEV
    # This rule should only be placed on your development environment
    # In production, don't include this and don't deploy app_dev.php or config.php
    location ~ ^/(app_dev|config)\.php(/|$) {
        fastcgi_pass unix:/var/run/php5-fpm.sock;
        fastcgi_split_path_info ^(.+\.php)(/.*)$;
        include fastcgi_params;
        # When you are using symlinks to link the document root to the
        # current version of your application, you should pass the real
        # application path instead of the path to the symlink to PHP
        # FPM.
        # Otherwise, PHP's OPcache may not properly detect changes to
        # your PHP files (see https://github.com/zendtech/ZendOptimizerPlus/issues/126
        # for more information).
        fastcgi_param  SCRIPT_FILENAME  $realpath_root$fastcgi_script_name;
        fastcgi_param DOCUMENT_ROOT $realpath_root;
    }
    # PROD
    location ~ ^/app\.php(/|$) {
        fastcgi_pass unix:/var/run/php5-fpm.sock;
        fastcgi_split_path_info ^(.+\.php)(/.*)$;
        include fastcgi_params;
        # When you are using symlinks to link the document root to the
        # current version of your application, you should pass the real
        # application path instead of the path to the symlink to PHP
        # FPM.
        # Otherwise, PHP's OPcache may not properly detect changes to
        # your PHP files (see https://github.com/zendtech/ZendOptimizerPlus/issues/126
        # for more information).
        fastcgi_param  SCRIPT_FILENAME  $realpath_root$fastcgi_script_name;
        fastcgi_param DOCUMENT_ROOT $realpath_root;
        # Prevents URIs that include the front controller. This will 404:
        # http://domain.tld/app.php/some-path
        # Remove the internal directive to allow URIs like this
        internal;
    }

    error_log /var/log/nginx/project_error.log;
    access_log /var/log/nginx/project_access.log;
}
```

И вставляем это туда, где удалили все, чтобы сохранить жмем **ctrl+o**      потом жмем enter
Выходим из редактора **ctrl+x**
* 4.4) перезагружаем nginx для этого пишем: `sudo service nginx restart`


* 5) Теперь нам нужно создать папки для кэш и логов
* 5.1) `sudo mkdir /var/cache/shop`
* 
        `sudo mkdir /var/log/shop`
* 5.2) меняем этим папка права на запись
  `sudo chmod -R 777 /var/cache/shop`

  `sudo chmod 777 /var/log/shop`


* 6) Открываем в NetBeans или, в любом другом редакторе в вашем проекте файл **app_dev.php** путь к нему такой:    **с:\vg\shop\web\     и в 15** строке добавляем **192.168.50.1**  чтобы получилось так:
```php

|| !(in_array(@$_SERVER['REMOTE_ADDR'], ['192.168.50.1','127.0.0.1', 'fe80::1', '::1']) || php_sapi_name() === 'cli-server')

```

* 6.1) меняем путь к кэшу и логам в самом проекте, для этого идем: **с:\vg\shop\app\   
  Открываем файл  app/AppKernel.php** , и редактируем **38 и 43** строки, чтобы методы возвращали:
  ```php
public function getCacheDir()
    {
        return '/var/cache/shop/'.$this->getEnvironment();
    }

    public function getLogDir()
    {
        return '/var/log/shop/';
    }
```
* 6.2) Переходим в терминале, в проект `cd /var/www/shop/`    и чистим кэш
  `sudo php  bin/console cache:clear`

  `sudo php  bin/console cache:clear --env=prod`
* 6.3) Запускаем в браузере **192.168.50.7**    - должно работать, у меня работает, на 2-х компах ставил


Для установки готового проекта с шаблоном 
========================
7) качаем [**Shop**][7]

7.1) Ставим или заменяем свой каталог `/shop/` который лежит в каталоге vagrant `c:/vg/`

7.2) Идем в терминал устанавливаем MySQL `sudo apt-get -f install`

7.3) Переходим в `cd /var/www/shop/` далее создаем БД `bin/console doctrine:database:create`  //т.к. не указали имя, создаст базу с названием symfony

7.4) Создаем таблицы в базе `bin/console doctrine:schema:create` (на время написание этого текста было всего 2 таблицы: item, category) 

7.5) Теперь проверяем в браузере http://192.168.50.7/  //должно работать.




[1]:  http://goo.gl/jjrhgq
[2]:  https://www.vagrantup.com/
[3]:  https://www.virtualbox.org/wiki/Downloads
[5]:  https://git-scm.com/downloads
[6]:  https://goo.gl/FyqFbs
[7]:  https://github.com/JAZzmiX/shop2
