#!/bin/sh -

IPT=/sbin/iptables

$IPT -N INTO-PHASE2
$IPT -A INTO-PHASE2 -m recent --name PHASE1 --remove
$IPT -A INTO-PHASE2 -m recent --name PHASE2 --set
$IPT -A INTO-PHASE2 -j LOG --log-prefix "INTO PHASE2: "

$IPT -N INTO-PHASE3
$IPT -A INTO-PHASE3 -m recent --name PHASE2 --remove
$IPT -A INTO-PHASE3 -m recent --name PHASE3 --set
$IPT -A INTO-PHASE3 -j LOG --log-prefix "INTO PHASE3: "

$IPT -N INTO-PHASE4
$IPT -A INTO-PHASE4 -m recent --name PHASE3 --remove
$IPT -A INTO-PHASE4 -m recent --name PHASE4 --set
$IPT -A INTO-PHASE4 -j LOG --log-prefix "INTO PHASE4: "

$IPT -A FROM_HOME -p tcp --dport 101 -m recent --set --name PHASE1
$IPT -A FROM_HOME -p tcp --dport 202 -m recent --rcheck --name PHASE1 -j INTO-PHASE2
$IPT -A FROM_HOME -p tcp --dport 303 -m recent --rcheck --name PHASE2 -j INTO-PHASE3
$IPT -A FROM_HOME -p tcp --dport 404 -m recent --rcheck --name PHASE3 -j INTO-PHASE4
$IPT -A FROM_HOME -p tcp --dport 22 -m recent --rcheck --seconds 5 --name PHASE4 -j ACCEPT

