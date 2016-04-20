#!/bin/bash
#Script d'automatisation d'autorité à clé publique (PKI)

#Run as root
if [ "$EUID" -ne 0 ]
 then cat menu.txt; echo "Please run with sudo"
 exit
fi

#------------------------------------------------------------------------------------------------------------------------------------------------------------
#								Inclusion des diffèrentes fonction du script
#------------------------------------------------------------------------------------------------------------------------------------------------------------
#echo " Include: Start .."
#Include PKI functions
function add_ca { eval "source pki/add_ca.sh"; }
function add_cert { eval "source pki/add_cert.sh"; }
function del_cert { eval "source pki/del_cert.sh"; }
function del_ca { eval "source pki/del_ca.sh"; }


#Include VPN functions
function add_x509_config_client { eval "source vpn/x509/add_x509_config_client.sh"; }
function del_x509_config_client { eval "source vpn/x509/del_x509_config_client.sh"; }
function add_x509_config_server { eval "source vpn/x509/add_x509_config_server.sh"; }
function del_x509_config_server { eval "source vpn/x509/del_x509_config_server.sh"; }
function activate_x509_config_server { eval "source vpn/x509/activate_x509_config_server.sh"; }
function desactivate_x509_config_server { eval "source vpn/x509/desactivate_x509_config_server.sh"; }
function activate_client_to_client { eval "source vpn/x509/activate_client_to_client.sh"; }
function desactivate_client_to_client { eval "source vpn/x509/desactivate_client_to_client.sh"; }

#Include firewall functions
function add_filtrage { eval "source firewall/add_filtrage.sh"; }
function del_filtrage { eval "source firewall/del_filtrage.sh"; }
function add_redirect { eval "source firewall/add_redirect.sh"; }
function del_redirect { eval "source firewall/del_redirect.sh"; }
function activate_nat { eval "source firewall/activate_nat.sh"; }
function desactivate_nat { eval "source firewall/desactivate_nat.sh"; }


#Include firewall functions

#declare -F #Permet de lister les fonctions ajouté dans le script.

#echo " Include: .. end "

#------------------------------------------------------------------------------------------------------------------------------------------------------------
#										Déclaration des variables
#------------------------------------------------------------------------------------------------------------------------------------------------------------

# Déclaration des variables:

#
VAR1=$1
#echo " VAR1: $VAR1"
#
VAR2=$2
#echo " VAR2: $VAR2"

# 
VAR3=$3
#echo " VAR3: $VAR3"

# 
VAR4=$4
#echo " VAR4: $VAR4"

#
VAR5=$5
#echo " VAR5: $VAR5"

#
VAR6=$6
#echo " VAR6: $VAR6"

VAR7=$7
#echo " VAR7: $VAR7"
VAR8=$8
#echo " VAR7: $VAR7"
#------------------------------------------------------------------------------------------------------------------------------------------------------------
#											Main
#------------------------------------------------------------------------------------------------------------------------------------------------------------

case $VAR1 in #Choix du type de service à administrer
    pki) case $VAR2 in #Choix du type d'action à réaliser
        add) case $VAR3 in #Choix du module à modifier
            cassl) add_ca;;
            cert) add_cert;;

            *) cat menu.txt ;;
            esac;;

        del) case $VAR3 in
            cassl) del_ca;;
            cert) del_cert;;
            *) cat menu.txt ;;
            esac;;

        *) cat menu.txt ;;
        esac;;

    vpn) case $VAR2 in
            add) case $VAR3 in
                conf_client) add_x509_config_client;;
                conf_serveur) add_x509_config_server;;
                *) cat menu.txt ;;
                esac;;

            del) case $VAR3 in
                conf_client) del_x509_config_client;;
                conf_serveur) del_x509_config_server;;
                *) cat menu.txt ;;
                esac;;

            activate) case $VAR3 in
                client_to_client) activate_client_to_client ;;
                server) activate_x509_config_server ;;
                *) cat menu.txt ;;
                esac;;

            desactivate) case $VAR3 in
                client_to_client) desactivate_client_to_client ;;
                server) desactivate_x509_config_server ;;
                *)  cat menu.txt;;
                esac;;
    esac;;

    firewall) case $VAR2 in
            add) case $VAR3 in
                filtrage) add_filtrage $VAR4 $VAR5 $VAR6 $VAR7 $VAR8;; #<ip src> <ip_dst> <port_src> <port_dst> <proto>
                redirect) add_redirect $VAR4 $VAR5 $VAR6 $VAR7;; #<ip dst> <port_dst_ext> <port_dst_int> <proto>
                *) cat menu.txt ;;
                esac;;

            del) case $VAR3 in
                filtrage) del_filtrage $VAR4 $VAR5 $VAR6 $VAR7 $VAR8;;
                redirect) del_redirect $VAR4 $VAR5 $VAR6 $VAR7;;
                *) cat menu.txt ;;
                esac;;

            nat) case $VAR3 in
                activate) activate_nat;;
                desactivate) desactivate_nat;;
                esac;;
            *) cat menu.txt ;;

    esac;;

    *) cat menu.txt ;;
esac