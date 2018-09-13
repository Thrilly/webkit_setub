# Installation Symfony ORDINE
Pour obtenir un environnent de développement optimal pour contribuer au projet ORDINE, je vous conseille d'utiliser un environnement assez stable pour les technologies de Symfony, soit MacOS ou Debian9.

## Installation sous Debian 9

### 1- Installer la dernière version de Debian 9 sur une VM ou Docker.
Veuillez installer votre machine via une image disque (.iso) en NetInstall, via le lien ci-dessous :
https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-9.5.0-amd64-netinst.iso

**Configurations et performances conseillés:**
 - Stockage : 15Go Dynamiquement alloué
 - RAM : 2048 Mo
 - Mémoire Vidéo : 16 Mo
 - Configuration Réseau : NAT
 - Redirection de port : le *80* invité vers le *80* hôte, et le *22* invité vers le *22* hôte (Voir Image Virtual Box ci dessous)

Image Redirection Ports : https://drive.google.com/file/d/1pCmEUnyfs28SnCL9ay-HxDJO3jve57zJ/view?usp=sharing


> Lors de l'installation, veillez à ne pas installer d'interface graphique. Elle ne vous servira à rien

Installer votre machine comme vous avez l'habitude de faire.
Lors du choix des *Softwar*, ne sélectionner que **SSH**.

Voir cette image : https://drive.google.com/open?id=1fWB19vZpHzv9pOB447jvdd3XlSYqVRr1


### 1- Mettez en place votre serveur LAMP
Dans un premier temps, connectez vous à votre vm en **SSH** à l'aide de **PuTTY**, cela sera plus simple pour la suite.
#
**Passez en super-utilisateur **
```
$ su
$ Enter password : *put root passwd here*
```
#
**Installez le packet *sudo***
```
$ apt-get install sudo -y
```
#
**Mettez votre utilisateur non-admin parmis les sudoers**
Editez le fichier `/etc/sudoers`, puis ajouter en dessous de la ligne 20 la ligne suivante :
```
*yourUserNoAdmin* ALL=(ALL:ALL) ALL
```

pour donner le résultat suivant :
```
[...]
# User privilege specification
root    		ALL=(ALL:ALL) ALL
*yourUserNoAdmin* 	ALL=(ALL:ALL) ALL

# Allow members of group sudo to execute any command
%sudo   ALL=(ALL:ALL) ALL
[...]
```
#
## 2- Téléchargez le setup d’installation de serveur

Vous avez 2 façon d'obtenir ce setup :
 - **Par GIT**

 Lancer les commande suivantes :
```
// Ne soyez pas en root
$ sudo apt-get install git -y
$ sudo git clone https://github.com/Thrilly/webkit_setup.git
$ sudo chmod -R 777 webkit_setup
$ sudo chown -R *yourUserNoAdmin* webkit_setup
```
> Attention ! Le "point" est important dans les commandes


 - **Par WGET**
Lancer les commandes suivantes :
```
$ sudo apt-get install zip -y
$ sudo wget https://github.com/Thrilly/webkit_setup/archive/master.zip
$ sudo unzip master.zip
$ sudo rm master.zip
$ sudo mv -R webkit_setup-master webkit_setup
$ sudo chmod -R 777 webkit_setup
$ sudo chown -R *yourUserNoAdmin* webkit_setup
```

#
**Puis lancer le script *setup.sh* :**

```
$ cd webkit_setup/debian8-9_ubuntu16-18/
$ ./setup.sh
```
Et répondez comme suit :
```
Do you want to install LAMP server (Apache, Mysql, PHP, PhpMyAdmin)? [y|n]
y
[...]
Install FTP SERVER (Vsftpd)? [y|n]
n
[...]
Install COMPOSER? [y|n]
y
[...]
Install NODEJS? [y|n]
n
[...]
Execute Mysql Secure installation? [y|n]
y
Enter current password for root (enter for none):
*Press ENTER*
Change|Enter new root password? [Y/n]
Y
Remove anonymous users? [Y/n]
Y
Disallow root login remotely? [Y/n]
n
Remove test database and access to it? [Y/n]
Y
Reload privilege tables now? [Y/n]
Y
Remove plugin of root@mysql to access to phpmyadmin? [y|n]
y
Install GIT? [y|n]
y
Set new password for OS root user for security? [y|n]
n
[...]
```

## 3- Récupérer le projet ORDINE
Exécutez les commandes suivantes :

```
$ cd /var/www/
$ sudo git clone https://gitlab.com/ordine-group/ordine-web.git
$ sudo chown -R *yourUser* ordine-web
$ cd ordine-web
$ composer install
```

***Et voila, c'est terminé !***

Allez checker aux URLs suivantes via votre navigateur préféré :
http://localhost/
http://localhost/ordine-web/web/app_dev.php
http://localhost/phpmyadmin

## 4- Mettez en place votre environnement
Pour pouvoir éditer vos fichier directement depuis votre machine hôte, je vous conseille d'installer le logiciel **ATOM**. (https://atom.io/)

Il vous permettra d'éditer vos fichier en SFTP.
Via **ATOM**, installer les packets suivants (FILE > SETTING > + INSTALL), et suivez les instructions.

Avec **ATOM**, installez les paquets suivants :
- #### [platformio-ide-terminal](https://atom.io/packages/platformio-ide-terminal)
- #### [ftp-remote-edit](https://atom.io/packages/ftp-remote-edit)

Configurer **ftp-remote-edit** en SFTP avec vos login:mdp non admin de votre Debian, via *Edit Server*

Je vous laisse me contacter pour les questions, mais lisez les documentations et les **README**

## Installation sous Debian 9

### Installez MAMP
Installez via ce lien :
https://www.mamp.info/en/downloads/

### Installez Composer
Suivez ce tutoriel :
https://www.abeautifulsite.net/installing-composer-on-os-x

### Installez GitKraken
Téléchargez via ce lien :
https://www.gitkraken.com/

### Récuperez le projet
Dans GitKraken, cloner le projet via l'url suivante : https://gitlab.com/ordine-group/ordine-web.git

> Attention ! Il faut placer le projet dans le dossier lors du clonage **/Applications/MAMP/htdocs**

**Vous voila enfin prêt.**
Allez checker aux URLs suivantes via votre navigateur préféré :
http://localhost:8080/
http://localhost:8080/ordine-web/web/app_dev.php
http://localhost:8080/phpmyadmin
