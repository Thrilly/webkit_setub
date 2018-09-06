#!/bin/bash
#
# By Nicolas JOACHIM
# Last Update : May 16, 2018
# OS : Debian 9
#
# REQUIRE :
# - 1 : You need to have "sudo" pkg installed
# - 2 : After mysql installation set : UPDATE mysql.user SET plugin = '' WHERE User = 'root'; FLUSH PRIVILEGES;
# - 3 : Try execute "sed -i -e 's/\r$//' serveur_a2_debian9.sh" if you have ^M in the script

if [[ $USER = "root" ]]; then
	echo "/!\ Please do not use root user"
else
	echo "Do you want to install LAMP server (Apache, Mysql, PHP, PhpMyAdmin)? [y|n]"
	read lamp
	if [[ "$lamp" = "y" ]]; then
		echo "############### LAMP INSTALLATION ################"
		# UPDATE DEBIAN AND PACKAGE
		sudo apt-get update -y
		sudo apt-get upgrade -y
		sudo apt-get dist-upgrade -y

		# INSTALL APACHE2
		sudo apt-get install apache2 -y
		sudo a2enmod rewrite

		# INSTALL PHP7.2
		sudo apt install ca-certificates apt-transport-https -y
		sudo wget -q https://packages.sury.org/php/apt.gpg -O- | sudo apt-key add -
		sudo su -c "echo 'deb https://packages.sury.org/php/ stretch main' >> /etc/apt/sources.list"

		sudo apt-get update -y
		sudo apt-get install php7.2 -y
		sudo apt-get install php7.2-cli php7.2-common php7.2-curl php7.2-gd php7.2-json php7.2-mbstring php7.2-mysql php7.2-xml libapache2-mod-php7.2 -y

		# INSTALL MYSQL/MARIADB
		sudo apt-get install mysql-server -y

	    # INSTALL PHPMYADMIN
	    sudo apt-get install zip -y
	    sudo wget "https://files.phpmyadmin.net/phpMyAdmin/4.8.2/phpMyAdmin-4.8.2-all-languages.zip"
	    sudo unzip phpMyAdmin-4.8.2-all-languages.zip
	    sudo mv phpMyAdmin-4.8.2-all-languages /var/www/phpmyadmin
	    sudo rm -r phpMyAdmin-4.8.2-all-languages.zip

		#  Setup right and conf
		sudo usermod -aG www-data $USER
		sudo chown -R www-data:www-data /var/www/
		sudo chmod -R 775 /var/www/
		sudo mv /var/www/html/index.html /var/www/index.html
		sudo rm -rf /var/www/html/
		sudo rm /etc/apache2/sites-available/000-default.conf
		sudo cp 000-default.conf /etc/apache2/sites-available/000-default.conf
		sudo systemctl restart apache2
		echo "############### END LAMP INSTALLATION ################"

	fi

	# INSTALL COMPOSER
	echo "Install FTP SERVER (Vsftpd)? [y|n]"
	read ftp
	if [[ "$ftp" = "y" ]]; then
		echo "############### FTP SERVER INSTALLATION ################"
		sudo apt-get install vsftpd ftp
		sudo rm /etc/vsftpd.conf
		sudo cp vsftpd.conf /etc/vsftpd.conf
		sudo chown root:root /etc/vsftpd.conf
		echo "############### END FTP SERVER INSTALLATION ################"
	fi

	# INSTALL COMPOSER
	echo "Install COMPOSER? [y|n]"
	read comp
	if [[ "$comp" = "y" ]]; then
		echo "############### COMPOSER INSTALLATION ################"
		sudo php -r "copy('https://getcomposer.org/installer', '/tmp/composer-setup.php');"
		sudo php /tmp/composer-setup.php --install-dir=/usr/local/bin --filename=composer
		echo "############### END COMPOSER INSTALLATION ################"
	fi

	# INSTALL NODE
	echo "Install NODEJS? [y|n]"
	read node
	if [[ "$node" = "y" ]]; then
		echo "############### NODE INSTALLATION ################"
		sudo apt-get install curl -y
		sudo curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
		sudo apt-get install -y nodejs
		echo "############### END INSTALLATION ################"
		echo "Install PM2? [y|n]"
		read pm2
		if [[ "$pm2" = "y" ]]; then
			echo "############### PM2 INSTALLATION ################"
			sudo npm install pm2 -g
			echo "############### END PM2 INSTALLATION ################"
		fi
	fi

	# INSTALL MYSQL_SECURE_INSTALLATION
	echo "Execute Mysql Secure installation? [y|n]"
	read mysql
	if [[ "$mysql" = "y" ]]; then
		sudo mysql_secure_installation
	fi

	# INSTALL MYSQL PLUGINS RM
	echo "Remove plugin of root@mysql to access to phpmyadmin? [y|n]"
	read mysql
	if [[ "$mysql" = "y" ]]; then
		echo "##### MYSQL COMMAND - ENTER PASSWORD ######"
		sudo mysql -u root -p < rm_plugin.sql
		echo "##### END MYSQL COMMAND - ENTER PASSWORD ######"
	fi

	# INSTALL GIT
	echo "Install GIT? [y|n]"
	read git
	if [[ "$git" = "y" ]]; then
		sudo apt-get install git -y
	fi

	echo "Set new password for OS root user for security? [y|n]"
	read root_usr
	if [[ "$root_usr" = "y" ]]; then
		echo "##### CHANGING ROOT PASSWD ######"
		sudo passwd root
		echo "##### END CHANGING ROOT PASSWD ######"
	fi
fi



# RECAP

echo "************ Installation Recap & installed Packages **************"

if [[ "$lamp" = "y" ]]; then
	echo "### LAMP ###"
	echo "Installed Packages :"
	echo " - apache2 (See http://[DOMAIN-NAME]/ . Apache 2 HTML Directory is in /var/www/ . )"
	echo " - phpmyadmin (See http://[DOMAIN-NAME]/phpmyadmin)"
	echo " - mysql (Test command 'mysql -u [username] -p' and set password)"
	echo " "
fi
if [[ "$ftp" = "y" ]]; then
	echo "### FTP SERVER ###"
	echo "Installed Packages :"
	echo " - vsftpd and ftp (connect with local users access. Change setting at /etc/vsftpd.conf)"
	echo " "
fi
if [[ "$comp" = "y" ]]; then
	echo "### COMPOSER ###"
	echo "Installed Packages :"
	echo " - composer (try 'composer -v')"
	echo " "
fi
if [[ "$node" = "y" ]]; then
	echo "### NODE JS AND PM2 ###"
	echo "Installed Packages :"
	echo " - nodejs (try 'node -v')"
	echo "INFO : If you have install PM2, try 'pm2 -v'"
	echo " "
fi
if [[ "$git" = "y" ]]; then
	echo "### GIT ###"
	echo "Installed Packages :"
	echo " - git (try 'git -v')"
	echo " "
fi

echo "*** Others Actions ***"

if [[ "$lamp" = "y" ]]; then
	echo "- Move default Web folder 1 up folder (/var/www/ but not /var/www/html)"
	echo "- Chown folder /var/www/ to www-data user and group"
	# echo "- Chown folder /var/www/ to www-data user and group"
fi

echo "******************* END ******************"
