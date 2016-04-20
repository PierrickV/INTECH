#!/bin/bash
# Supervision du CPU
# Faites deux autres graphes RRDTOOL ou InfluxDB, l’un indiquant la variation de l’utilisation du processeur toutes les minutes, et l’autres toutes les heures en récupérant l’information d’une source de données unique
#Pour créé la base de données:
#rrdtool create /var/www/html/rrd/cpu.rrd --step 60 DS:cpu:GAUGE:120:U:U RRA:AVERAGE:0.5:1:40320 RRA:AVERAGE:0.5:60:672

DBPath=/var/www/html/rrd

#Mise à jours des variables:
let "cpu= 100-$(snmpget -v 1 -c operator 127.0.0.1  .1.3.6.1.4.1.2021.11.11.0 | cut -d " " -f 4)"

#cpu=$(snmpget -v 1 -c operator 127.0.0.1  .1.3.6.1.4.1.2021.11.11.0 | cut -d " " -f 4)
#cpu=$(snmpget -v 1 -c operator 127.0.0.1 1.3.6.1.4.1.2021.10.1.3.1 | cut -d " " -f 4)
#cpu=$(vmstat | /usr/bin/tail -n1 | cut -d " " -f 41)

echo $cpu

#Mise à jours de la base de données RRDTool
rrdtool update $DBPath/cpu.rrd N:$cpu

#Mise à jours du graphs
rrdtool graph $DBPath/cpu_minutes.png --start -3600 \
	DEF:cpuUsage=$DBPath/cpu.rrd:cpu:AVERAGE \
	CDEF:cpu=cpuUsage \
	AREA:cpu#00FF00:"CPU Utilisé" \

rrdtool graph $DBPath/cpu_heures.png --start -40320 \
	DEF:cpuUsage=$DBPath/cpu.rrd:cpu:AVERAGE \
	CDEF:cpu=cpuUsage \
	AREA:cpu#00FF00:"CPU Utilisé" \
