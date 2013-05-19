#!/bin/sh -

IPT=/sbin/iptables

$IPT -F
$IPT -X
$IPT -t raw -F
$IPT -t raw -X
$IPT -t nat -F
$IPT -t nat -X
$IPT -t mangle -F
$IPT -t mangle -X
$IPT -P INPUT ACCEPT
$IPT -P FORWARD ACCEPT
$IPT -P OUTPUT ACCEPT

