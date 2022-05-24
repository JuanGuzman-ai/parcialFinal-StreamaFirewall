#!/bin/bash
sudo -i
#Instalamos las librerias necesarias
yum update -y
yum install vim wget httpd mod_ssl -y
#Instalamos java
yum install java-1.8.0-openjdk-devel
#Descargamos Streama War
wget https://github.com/streamaserver/streama/releases/download/v1.6.1/streama-1.6.1.war
#Creamos la carpeta streama y movemos la descarga .war
mkdir /opt/streama
mv streama-1.6.1.war /opt/streama/streama.war
#Creamos la carpeta media en el directorio creado anterio y le damos privilegios
mkdir /opt/streama/media
chmod 664 /opt/streama/media
chmod 777 /etc/systemd/system
#Agregamos las siguientes lineas al servicios de streama
echo "[Unit]
Description=Streama Server
After=syslog.target
After=network.target

[Service]
User=root
Type=simple
ExecStart=/bin/java -jar /opt/streama/streama.war
Restart=always
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=Streama

[Install]
WantedBy=multi-user.target" >> /etc/systemd/system/streama.service
#Dejamos funcionando el servicios de streama y el servicios httpd
systemctl start streama
systemctl enable streama
systemctl start httpd
systemctl enable httpd
