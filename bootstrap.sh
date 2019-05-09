!/bin/bash

apt-get update
# Primero instalamos Apache
apt-get install -y apache2

# Instalamos las librerias de php.
apt-get install -y php libapache2-mod-php php-mysql

# Reiniciamos Apache
sudo systemctl restart apache2

# Vamos al directorio html
cd /var/www/html

# Descargamos el adminer con wget
wget https://github.com/vrana/adminer/releases/download/v4.3.1/adminer-4.3.1-mysql.php

# Cambimos el nombre del archivo php por adminer.php
mv adminer-4.3.1-mysql.php adminer.php

# Actualizamos con apt-get update
apt-get update

# Instalamos los paquetes de debconf
apt-get -y install debconf-utils

# Ahora damos una contraseña de la base de datos
DB_ROOT_PASSWD=root
debconf-set-selections <<< "mysql-server mysql-server/root_password password $DB_ROOT_PASSWD"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $DB_ROOT_PASSWD"

# Instalamos mysql
apt-get install -y mysql-server

# Habilitamos esta opcion
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mysql/mysql.conf.d/mysqld.cnf

# Reiniciamos mysql
sudo systemctl restart mysql

# Asignamos la contraseña de root de mysql
mysql -uroot mysql -p$DB_ROOT_PASSWD <<< "GRANT ALL PRIVILEGES ON *.* TO root@'%' IDENTIFIED BY '$DB_ROOT_PASSWD'; FLUSH PRIVILEGES;"

# Para finalizar creamos una prueba de base de datos
mysql -uroot mysql -p$DB_ROOT_PASSWD <<< "CREATE DATABASE test;"
