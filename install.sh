DOMAIN='example.com'

apt-get update
apt-get upgrade
apt-get install -y software-properties-common htop pwgen letsencrypt composer

# mariadb
apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xF1656F24C74CD1D8
echo "deb http://mariadb.mirror.iweb.com/repo/10.0/ubuntu `lsb_release -cs` main" > /etc/apt/sources.list.d/mariadb.list
apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install -y mariadb-server

mysql -u root -p #empty password
CREATE DATABASE IF NOT EXISTS shopware;
CREATE USER 'shopware'@'localhost' IDENTIFIED BY 'athooghoJ6Eoj5EKocuB';
GRANT ALL PRIVILEGES ON shopware.* TO 'shopware'@'localhost';
FLUSH PRIVILEGES;


# php
apt-get install -y php7.0 php7.0-mysql php7.0-gd php7.0-zip php7.0-xml php7.0-intl php7.0-mbstring php7.0-curl

# ioncube loader
curl -#L http://downloads3.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz -o /tmp/ioncube.tar.gz
tar xzf /tmp/ioncube.tar.gz -C /tmp/
install -m 0644 /tmp/ioncube/ioncube_loader_lin_$(php -r 'printf("%s.%s", PHP_MAJOR_VERSION, PHP_MINOR_VERSION);').so $(php -r 'printf("%s", PHP_EXTENSION_DIR);')/ioncube_loader.so
rm -rf /tmp/ioncube /tmp/ioncube.tar.gz
echo "zend_extension=ioncube_loader.so" > /etc/php/7.0/mods-available/ioncube_loader.ini
ln -s /etc/php/7.0/mods-available/ioncube_loader.ini /etc/php/7.0/cli/conf.d/00-ioncube_loader.ini && ln -s /etc/php/7.0/mods-available/ioncube_loader.ini /etc/php/7.0/fpm/conf.d/00-ioncube_loader.ini
echo "memory_limit=512M" > /etc/php/7.0/mods-available/custom.ini
echo "upload_max_filesize=24M" >> /etc/php/7.0/mods-available/custom.ini
ln -s /etc/php/7.0/mods-available/custom.ini /etc/php/7.0/cli/conf.d/90-custom.ini && ln -s /etc/php/7.0/mods-available/custom.ini /etc/php/7.0/fpm/conf.d/90-custom.ini
# check: php -r "echo "ionCube loader is installed: "var_export(extension_loaded('ionCube Loader'), true);"
service php7.0-fpm reload

# nginx
apt-get install -y nginx
mv /etc/nginx /etc/nginx.old && git clone https://github.com/d1rk/shopware-with-nginx.git /etc/nginx
cp /etc/nginx/sites-available/example.com.conf /etc/nginx/sites-available/$DOMAIN.conf
sed -i -e "s/example.com/$DOMAIN/" /etc/nginx/sites-available/$DOMAIN.conf
ln -s /etc/nginx/sites-available/$DOMAIN.conf /etc/nginx/sites-enabled/$DOMAIN

# nginx conf
procs=$(cat /proc/cpuinfo |grep processor | wc -l)
sed -i -e "s/worker_processes auto/worker_processes $procs/" /etc/nginx/nginx.conf


letsencrypt certonly -a webroot --agree-tos --webroot-path=/var/www -d $DOMAIN -d www.$DOMAIN

rm -rf /var/www
curl -#L https://s3-eu-west-1.amazonaws.com/releases.s3.shopware.com/Downloader/index.php -o /var/www/index.php
chown www-data:www-data www/
