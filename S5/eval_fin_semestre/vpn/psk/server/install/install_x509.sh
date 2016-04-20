#!/usr/bin/env bash
apt-get install openvpn easy-rsa


cd /usr/share/easy-rsa/

cp include/vars /usr/share/easy-rsa/vars
cd /usr/share/easy-rsa/

source vars

#Création les clés de l'autorité
./build-ca

#Création des certificats et clés clients
./build-key-server $(hostname)

client_name="pierrick"
./build-key $client_name

#Création du paramêtre diffie-hellman
./build-dh

#Copie du certificat dans le répertoire openVPN
cp keys/*.crt /etc/openvpn/
cp keys/*.key /etc/openvpn/
cp ./keys/*.pem /etc/openvpn/

groupadd openvpn
useradd -d /dev/null -g openvpn -s /bin/false openvpn

gunzip /usr/share/doc/openvpn/examples/sample-config-files/server.conf.gz
cp /usr/share/doc/openvpn/examples/sample-config-files/server.conf /etc/openvpn/

vi /etc/openvpn/server.conf

#-----------------------------------------------------------        
ifconfoig
ifconfig
ifconfig
vi /etc/openvpn/server.conf
ls
cd /etc/openvpn/
ls
ca.crt  dh2048.pem  server.conf  tp-openvvpn-073e3d52-5e04-4527-a664-9b5b0622c520.crt  tp-openvvpn-073e3d52-5e04-4527-a664-9b5b0622c520.key  update-resolv-conf
vi /etc/openvpn/server.conf
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)
/etc/init.d/openvpn restart
ps aux | grep vpn
ps aux | grep openvpn
sudo openvpn
su openvpn
/etc/init.d/openvpn restart
ps aux | grep openvpn
su openvpn
cat /etc/passwd | grep openvpn
su openvpn
exit
vi /etc/hosts
hostname
tp-openvvpn-073e3d52-5e04-4527-a664-9b5b0622c520
vi /etc/hosts
whereis easy-rsa
cd /usr/share/easy-rsa/
ls
cd keys/
ls
cp ca.crt /etc/openvpn/
cd /etc/openvpn/
ls
vi server.conf
/etc/init.d/openvpn restart
tail -f /var/log/syslog
ifconfig
ping 10.8.0.1
history
cd /etc/openvpn/
ls
cd /usr/share/doc/openvpn/examples/easy-rsa/
find / -name "easy-rsa"
cd /usr/share/easy-rsa/
ls
cd ../
ls
cd /usr/share/easy-rsa/
ls
cd vars
./vars
/build-key pierrick
./build-key pierrick
source vars
./build-key pierrick
./build-dh

echo 1 > /proc/sys/net/ipv4/ip_forward