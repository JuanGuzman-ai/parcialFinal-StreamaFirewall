#!/bin/bash
sudo -i
#Instalamos vim
yum update -y
yum install vim -y
#Detenemos NetworkManager
service NetworkManager stop
chkconfig NetworkManager off
#Configuramos la ip_forward
echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
#Configuramos el firewall
systemctl start firewalld
systemctl enable firewalld
#Gestionamos las zonas
firewall-cmd --permanent --zone=dmz --add-interface=eth1
firewall-cmd --permanent --zone=internal --add-interface=eth2
firewall-cmd --reload
#Agregamos las reglas
firewall-cmd --direct --permanent --add-rule ipv4 nat POSTROUTING 0 -o eth1 -j MASQUERADE 
firewall-cmd --direct --permanent --add-rule ipv4 filter FORWARD 0 -i eth2 -o eth1 -j ACCEPT 
firewall-cmd --direct --permanent --add-rule ipv4 filter FORWARD 0 -i eth1 -o eth2 -m state --state RELATED,ESTABLISHED -j ACCEPT
#Agregamos servicio http a las zona dmz y el puerto
firewall-cmd --permanent --zone=dmz --add-service=http
firewall-cmd --zone=dmz --add-port=8080/tcp --permanent
#Añadimos el redirect al servidor streama
firewall-cmd --zone="dmz" --add-forward- port=8080:proto=tcp:toport=8080:toaddr=192.168.50.4 --permanent 
firewall-cmd --zone="internal" --add-forward- port=8080:proto=tcp:toport=8080:toaddr=192.168.50.4 --permanent
firewall-cmd --reload