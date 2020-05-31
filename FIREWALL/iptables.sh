#!/bin/bash

TCP_PORTS=${TCP_PORTS:-""}
HOSTS=${HOSTS:-""}

iptables -P INPUT ACCEPT
iptables -F
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
 
# Allow incoming ssh only
for port in ${TCP_PORTS//,/ }; do
  echo Allowing traffic to TCP $port
  iptables -A INPUT -p tcp -s 0/0 --dport ${port} -m state --state NEW,ESTABLISHED -j ACCEPT
done

for host in ${HOSTS//,/ }; do
  echo Allowing traffic from ${host}
  iptables -A INPUT -p tcp -s ${host} -m state --state NEW,ESTABLISHED -j ACCEPT
done

iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT



exec syslogd -n -O -