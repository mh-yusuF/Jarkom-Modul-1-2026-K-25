#!/bin/bash 
iptables -t nat -F 
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE 
for i in 1 2 3; do 
iptables -A FORWARD -i eth$i -o eth0 -j ACCEPT 
iptables -A FORWARD -i eth0 -o eth$i -m state --state RELATED,ESTABLISHED -j ACCEPT 
done 
