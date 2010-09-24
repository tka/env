#! /bin/bash

# ----------------------------------------------------------------------------
#
# script to set the iptables firewall
#
#	http://wiki.archlinux.org/index.php/Simple_stateful_firewall_HOWTO
#
# :: blocks bruteforce attacks (useful for securing SSH servers)
#
# ----------------------------------------------------------------------------


# allow local connections (disable for testing purposes only)
allow_lo="yes";


# ----------------------------------------------------------------------------
# interfaces (confirm)

localnet="lo";
internet="eth+";	# the ending '+' is a wildcard for matching patterns
                       # will match for example 'eth0' , 'eth1' ,  etc..
# ----------------------------------------------------------------------------

#  reset iptables rules
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT
iptables -F
iptables -X


# create the chains
iptables -N open
iptables -N interfaces


# >> INPUT chain
iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A INPUT -j interfaces
iptables -A INPUT -j open
iptables -P INPUT DROP


# set the default policies for OUTPUT and FORWARD chains
iptables -P OUTPUT ACCEPT
iptables -P FORWARD DROP


# ----------------------------------------------------------------------------
# >> interfaces chain :: allow all connections from these interfaces
#
[[ "${allow_lo}" == "yes" ]] && iptables -A interfaces -i ${localnet} -j ACCEPT


# ----------------------------------------------------------------------------
# the 'open' chain :: rules for accept incoming external connections (daemons)
#
iptables -A open -p tcp -m tcp --dport 80 -j ACCEPT	# apache/http
iptables -A open -p tcp -m tcp --dport 443 -j ACCEPT	# apache/https
iptables -A open -p tcp -m tcp --dport 22 -j ACCEPT	# ssh(default)

# print the iptables
iptables -L;
iptables-save > /etc/iptables.rules

exit 0;
