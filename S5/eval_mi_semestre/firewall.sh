#!/bin/bash
#Pierrick VERAN ITI13S SR - Evaluation de mi-semestre
#Firewall lan d'une entreprise
#-------------------------------------------------------------------------------------
# Variables
#-------------------------------------------------------------------------------------

LO_IFACE="lo"
LO_IP="127.0.0.1"

NET_IFACE="eth0"
NET_IP="10.0.2.15"

USERS_IFACE="eth0"
USERS_IP="10.0.0.0"
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
iptables -t nat -A POSTROUTING -o $NET_IFACE -j MASQUERADE

#-------------------------------------------------------------------------------------
# Régles par propre à l'entrepise
#-------------------------------------------------------------------------------------

# On ne laisse rien sortir sur internet, ni rentrer depuis internet sauf
# Lorsqu'il s'agit de requête DNS (TCP/UDP) vers 8.8.8.8 (pour tous les réseaux de l'entreprise)

iptables -A FORWARD -m state --state NEW -o $NET_IFACE  -p tcp -d "8.8.8.8" --dport 53 --syn -j ACCEPT #DNS UDP
iptables -A FORWARD -m state --state NEW -o $NET_IFACE  -p udp -d "8.8.8.8" --dport 53 -j ACCEPT #DNS UDP

# De requêtes web http et https issus du réseau des PC de l'entrepise (10.0.0.0/24)
iptables -A FORWARD -m state --state NEW -i $USERS_IP -o $NET_IFACE -p tcp --dport 80 --syn -j ACCEPT #HTTP
iptables -A FORWARD -m state --state NEW -i $USERS_IP -o $NET_IFACE -p tcp --dport 443 --syn -j ACCEPT #HTTPS

# On autorise un accès au Softswitch de l'entreprise depuis internet uniquement sur le port 5060 en TCP et UDP.

iptables -A FORWARD -m state --state NEW -i $NET_IFACE  -p udp --dport "5060" -j ACCEPT #DNS UDP

iptables -A FORWARD -m state --state NEW -i $NET_IFACE  -p tcp --dport "5060" --syn -j ACCEPT #DNS UDP

# On autorise l'accès depuis internet en SSH au parefeu de votre entreprise

iptables -A INPUT -m state --state NEW -i $NET_IFACE -p tcp --dport 22 --syn -j ACCEPT #SSH
