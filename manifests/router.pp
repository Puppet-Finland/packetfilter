#
# == Class: packetfilter::router
#
# Typical set of rules for simplistic router nodes. Allows only limited inbound 
# traffic without placing restrictions on outbound traffic.
#
# == Authors
#
# Samuli Seppänen <samuli.seppanen@gmail.com>
#
class packetfilter::router
(
    $source,
    $iniface,
    $outiface
)
{
    include packetfilter::endpoint

    # Masquerade rules
    firewall { "101 ipv4 masquerade ${outiface}":
        provider => 'iptables',
        chain => 'POSTROUTING',
        proto => 'all',
        outiface => $outiface,
        source => $source,
        table => 'nat',
        jump => 'MASQUERADE',
    }

    # INPUT chain
    firewall { "102 ipv4 accept ${iniface}":
        provider => 'iptables',
        chain => 'INPUT',
        proto => 'all',
        state => [ 'NEW' ],
        iniface => $iniface,
        action => 'accept',
    }

    # FORWARD chain
    firewall { "102 ipv4 forward ${iniface}":
        provider => 'iptables',
        chain => 'FORWARD',
        proto => 'all',
        state => [ 'NEW' ],
        iniface => $iniface,
        action => 'accept',
    }

    firewall { '104 ipv4 forward related and established':
        provider => 'iptables',
        chain => 'FORWARD',
        proto => 'all',
        state => [ 'ESTABLISHED', 'RELATED' ],
        action => 'accept',
    }
}
