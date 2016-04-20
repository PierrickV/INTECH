#!/usr/bin/env bash

cd  /etc/openvpn
openvpn --genkey --secret static.key
