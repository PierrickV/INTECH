#!/usr/bin/env bash
#Pierrick VERAN ITI13S SR - Evaluation de fin de semestre
#Permet d'activer la nat

#Variables
nat="iptables -t nat -A POSTROUTING -o $NET_IFACE -j MASQUERADE"
no_nat="#iptables -t nat -A POSTROUTING -o $NET_IFACE -j MASQUERADE"

echo "---------------------------------------------------"
echo "              Activation de la nat                 "
echo "---------------------------------------------------"

sudo sed '/iptables -t nat -A POSTROUTING -o $NET_IFACE -j MASQUERADE/ s/^#//' firewall/firewall.base.sh > firewall/firewall.base.sh.tmp
mv firewall/firewall.base.sh.tmp firewall/firewall.base.sh
chmod u+x ./firewall/firewall.base.sh
./firewall/firewall.base.sh

echo "Nouvelle valeur de la NAT:"
cat ./firewall/firewall.base.sh | grep "iptables -t nat -A POSTROUTING -o \$NET_IFACE -j MASQUERADE"

exit 0

