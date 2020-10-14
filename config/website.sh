sudo chown ubuntu:ubuntu /var/www/html/xyz.com -R;
sudo chown www-data:www-data /var/www/html/xyz.com/uploads -R;
sudo cp /var/www/html/xyz.com/config/nginx.conf /etc/nginx/sites-available/xyz.com;
sudo sed -i 's/your_server_ip/ipv4_address/g' /etc/nginx/sites-available/xyz.com;
sudo sed -i 's/your_server_domain/xyz.com/g' /etc/nginx/sites-available/xyz.com;
sudo ln -s /etc/nginx/sites-available/xyz.com /etc/nginx/sites-enabled/xyz.com;
sudo cp /var/www/html/xyz.com/config/apache2.conf /etc/apache2/sites-available/xyz.com.conf;
sudo sed -i 's/your_server_domain/xyz.com/g' /etc/apache2/sites-available/xyz.com.conf;
a2ensite xyz.com;
sudo systemctl reload nginx;
sudo service apache2 start;
sudo certbot --agree-tos --no-eff-email --email tech@wildfire.world --nginx -d xyz.com -d www.xyz.com;
sudo service apache2 restart;
sudo cp /var/www/html/xyz.com/themes/wildfire-2020 /var/www/html/xyz.com/themes/xyz.com -R;
sudo chown ubuntu:ubuntu /var/www/html/xyz.com/themes/xyz.com -R;
sudo cp /var/www/html/xyz.com/config/vars.php.sample /var/www/html/xyz.com/config/vars.php;
sudo sed -i 's/xyz-domain-var/xyz.com/g' /var/www/html/xyz.com/config/vars.php;
sudo sed -i 's/xyz-db-name-var/mysql_w_user/g' /var/www/html/xyz.com/config/vars.php;
sudo sed -i 's/xyz-db-pass-var/mysql_w_pass/g' /var/www/html/xyz.com/config/vars.php;
echo "CREATE USER 'mysql_w_user'@'localhost' IDENTIFIED WITH mysql_native_password BY 'mysql_w_pass'; FLUSH PRIVILEGES;" | mysql -umysql_root_user -pmysql_root_pass -hlocalhost;
echo "CREATE DATABASE mysql_w_user CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;" | mysql -umysql_root_user -pmysql_root_pass -hlocalhost;
echo "GRANT ALL PRIVILEGES on mysql_w_user.* to 'mysql_w_user'@'localhost';" | mysql -umysql_root_user -pmysql_root_pass -hlocalhost;
sudo mysql -umysql_w_user -pmysql_w_pass mysql_w_user < /var/www/html/xyz.com/config/install.sql;
sudo bash config/composer.sh;
php composer.phar install;
php composer.phar dump-autoload;