#!/bin/sh -

IPT=/sbin/iptables
HOME_IP=
LAN_IP=


$IPT -P INPUT DROP
$IPT -P FORWARD ACCEPT
$IPT -P OUTPUT ACCEPT

$IPT -N FROM_LAN
$IPT -N FROM_HOME
$IPT -N FROM_ANYWHERE

# allow lo, established and icmp
$IPT -A INPUT -i lo -j ACCEPT
$IPT -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
$IPT -A INPUT -p icmp -m icmp --icmp-type 8 -j ACCEPT

$IPT -A INPUT -s $LAN_IP -j FROM_LAN
$IPT -A INPUT -s $HOME_IP -j FROM_HOME
$IPT -A INPUT -j FROM_ANYWHERE

# LAN CHAIN #
$IPT -A FROM_LAN -p tcp -m tcp --dport 22 -j LOG --log-prefix "SSH_FROM_LAN "
$IPT -A FROM_LAN -p tcp -m tcp --dport 22 -j ACCEPT
$IPT -A FROM_LAN -p tcp -m tcp --dport 80 -j ACCEPT
$IPT -A FROM_LAN -p tcp -m tcp --dport 443 -j ACCEPT

# HOME CHAIN # 
$IPT -A FROM_HOME -p tcp -m tcp --dport 22 -j LOG --log-prefix "SSH_FROM_HOME "
#open port 22 after port knocking
#. './fw.knock.sh'
#or without knocking
#$IPT -A FROM_HOME -p tcp -m tcp --dport 22 -j ACCEPT
$IPT -A FROM_HOME -p tcp -m tcp --dport 22 -j ACCEPT
$IPT -A FROM_HOME -p tcp -m tcp --dport 80 -j ACCEPT
$IPT -A FROM_HOME -p tcp -m tcp --dport 443 -j ACCEPT

# ANYWHERE CHAIN #
$IPT -A FROM_ANYWHERE -p tcp -m tcp --dport 80  -j ACCEPT
$IPT -A FROM_ANYWHERE -p tcp -m tcp --dport 443 -j ACCEPT
$IPT -A FROM_ANYWHERE -p tcp -m tcp --dport 22 -j LOG --log-prefix "SSH_DROPPED "

