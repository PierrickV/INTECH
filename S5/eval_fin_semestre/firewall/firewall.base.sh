#!/bin/bash
#Pierrick VERAN ITI13S SR - Evaluation de fin de semestre
#Firewall cantbreakit
#-------------------------------------------------------------------------------------
# Variables
#-------------------------------------------------------------------------------------

LO_IFACE="lo"
LO_IP="127.0.0.1"

NET_IFACE="eth0"
NET_IP="192.168.0.14"

LAN_IFACE="eth1"
LAN_IP="192.168.1.22"

VPN_PSK_IFACE="tun0"
VPN_PSK_IP="10.8.0.1/24"

VPN_X509_IFACE="tun1"
VPN_X509_IP="10.8.0.1/24"
#-------------------------------------------------------------------------------------
# Régles par défault
#-------------------------------------------------------------------------------------

#Efface toutes les régles
iptables -F

#Met la politique de filtrage à DROP pour toute la table filter
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP

#Autorise tous les flux sur l’interface lo
iptables -A INPUT -i $LO_IFACE -j ACCEPT
iptables -A OUTPUT -o $LO_IFACE -j ACCEPT

#Autorise toutes les connexions déjà ouverte
iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT

#Nat toutes les requêtes passant par votre machine
iptables -t nat -A POSTROUTING -j MASQUERADE

#-------------------------------------------------------------------------------------
# Régles par propre à l'entrepise
#-------------------------------------------------------------------------------------

# Tout le traffic est bloqué sauf le traffic entrant et sortant vers
# SSH VPN HTTP/HTTPS DNS:8.8.8.8

# DNS TCP
iptables -A FORWARD -m state --state NEW -p tcp -d "8.8.8.8" --dport 53 --syn -j ACCEPT
iptables -A INPUT -m state --state NEW -p tcp -d "8.8.8.8" --dport 53 --syn -j ACCEPT
iptables -A OUTPUT -m state --state NEW -p tcp -d "8.8.8.8" --dport 53 --syn -j ACCEPT

# DNS UDP
iptables -A FORWARD -m state --state NEW -p udp -d "8.8.8.8" --dport 53 -j ACCEPT
iptables -A INPUT -m state --state NEW -p udp -d "8.8.8.8" --dport 53 -j ACCEPT
iptables -A OUTPUT -m state --state NEW -p udp -d "8.8.8.8" --dport 53 -j ACCEPT

# HTTP
iptables -A FORWARD -m state --state NEW -p tcp --dport 80 --syn -j ACCEPT #HTTP
iptables -A INPUT -m state --state NEW -p tcp --dport 80 --syn -j ACCEPT #HTTP
iptables -A OUTPUT -m state --state NEW -p tcp --dport 80 --syn -j ACCEPT #HTTP

#HTTPS
iptables -A FORWARD -m state --state NEW -p tcp --dport 443 --syn -j ACCEPT
iptables -A INPUT -m state --state NEW -p tcp --dport 443 --syn -j ACCEPT
iptables -A OUTPUT -m state --state NEW -p tcp --dport 443 --syn -j ACCEPT

# SSH
iptables -A FORWARD -m state --state NEW -p tcp --dport 22 --syn -j ACCEPT #SSH
iptables -A INPUT -m state --state NEW -p tcp --dport 22 --syn -j ACCEPT #SSH
iptables -A OUTPUT -m state --state NEW -p tcp --dport 22 --syn -j ACCEPT #SSH

# VPN TCP
iptables -A FORWARD -m state --state NEW -p tcp --dport 1194 --syn -j ACCEPT #VPN
iptables -A INPUT -m state --state NEW -p tcp --dport 1194 --syn -j ACCEPT #VPN
iptables -A OUTPUT -m state --state NEW -p tcp --dport 1194 --syn -j ACCEPT #VPN

# VPN UDP
iptables -A FORWARD -m state --state NEW -p udp --dport 1194 -j ACCEPT #VPN
iptables -A INPUT -m state --state NEW -p udp --dport 1194 -j ACCEPT #VPN
iptables -A OUTPUT -m state --state NEW -p udp --dport 1194 -j ACCEPT #VPN

#On autorise le ping
iptables -A INPUT -p icmp -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -p icmp -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -p icmp -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT

echo "Result:"
iptables -L -v