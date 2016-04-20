#!/usr/bin/env bash

route del default
route del 192.168.0.0
route add default gw 192.168.1.22 eth0
route add -net 192.168.0.0 netmask 255.255.255.0 gw 192.168.1.22 eth0
