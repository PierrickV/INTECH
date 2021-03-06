#!/usr/bin/env bash
#Pierrick VERAN ITI13S SR - Evaluation de fin de semestre
#Permet de supprimer une régle de redirection

ip_dst="None"
port_dst_ext="None"
port_dst_int="None"
proto="None"
regle_1="None"
regle_2="None"

ip_dst=$1
port_dst_ext=$2
port_dst_int=$3
proto=$4

echo "---------------------------------------------------"
echo "          Suppression d'une régle de redirection   "
echo "---------------------------------------------------"

case "$proto" in
    udp)
        regle_1="iptables -t nat -A PREROUTING -i eth0 -p $proto --dport $port_dst_ext -j DNAT --to-destination $ip_dst:$port_dst_int"
        regle_2="iptables -A FORWARD -i eth0 -o eth1 -p $proto --dport $port_dst_ext -m state --state NEW -j ACCEPT"
    ;;
    tcp)
        regle_1="iptables -t nat -A PREROUTING -i eth0 -p $proto --dport $port_dst_ext -j DNAT --to-destination $ip_dst:$port_dst_int"
        regle_2="iptables -A FORWARD -i eth0 -o eth1 -p $proto --dport $port_dst_ext -m state --state NEW --syn -j ACCEPT"
    ;;
    *) echo "udp ou tcp? Vous avez écris $proto"
esac

find ./firewall/firewall.redirect.sh -type f -exec sed -i "s/$regle_1/ /g" {} \+
find ./firewall/firewall.redirect.sh -type f -exec sed -i "s/$regle_2/ /g" {} \+
$('pwd')/firewall/firewall.base.sh
$('pwd')/firewall/firewall.filtrage.sh
$('pwd')/firewall/firewall.redirect.sh

echo "Les régles suivantes ont étés supprimées du parefeu:"
echo $regle_1
echo $regle_2