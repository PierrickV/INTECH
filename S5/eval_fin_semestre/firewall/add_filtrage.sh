#!/usr/bin/env bash
#Pierrick VERAN ITI13S SR - Evaluation de fin de semestre
#Permet d'ajouter une régle de filtrage

ip_src="None"
ip_dst="None"
port_src="None"
port_dst="None"
proto="None"
rule_type="None"
type="None"

ip_src=$1
ip_dst=$2
port_src=$3
port_dst=$4
proto=$5

echo "---------------------------------------------------"
echo "          Ajout d'une régle de filtrage            "
echo "---------------------------------------------------"

echo "Type de régles"
echo "[0] INPUT"
echo "[1] OUTPUT"
echo "[2] FORWARD"
read rule_type

case "$rule_type" in
    0)type="INPUT";;
    1)type="OUTPUT";;
    2)type="FORWARD";;
esac

case "$proto" in
    udp)regle="iptables -A $type -s $ip_src -d $ip_dst -p $proto --sport $port_src --dport $port_dst -m state --state NEW -j ACCEPT";;
    tcp)regle="iptables -A $type -s $ip_src -d $ip_dst -p $proto --sport $port_src --dport $port_dst -m state --state NEW --syn -j ACCEPT";;
    *) echo "udp ou tcp? Vous avez écris $proto"
esac

echo $regle >> $('pwd')/firewall/firewall.filtrage.sh

$('pwd')/firewall/firewall.base.sh
$('pwd')/firewall/firewall.filtrage.sh
$('pwd')/firewall/firewall.redirect.sh

echo "La régle suivante a été rajouté au parefeu:"
echo $regle