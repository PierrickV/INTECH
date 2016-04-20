#!/usr/bin/env bash
#https://stackoverflow.com/questions/29742454/ssh-tunnel-through-remote-server-to-another-server
ssh-add
ssh-add -L
ssh -At ec2-user@10.8.100.82 ssh ec2-user@192.168.1.19 -p 22

#ssh -At ec2-user@labo.itinet.fr -p 10020 ssh ec2-user@192.168.1.13 -p 22

