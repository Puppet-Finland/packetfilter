# == Define: packetfilter::accept::traffic_from_ip_to_port
#
# Allow traffic of given protocol from a specific IPv4/IPv6 IP to given local 
# port.
#
# == Parameters
#
# [*iface*]
#   The interface the rule applies to
# [*ipv4_address*]
#   Allow traffic from this IPv4 address
# [*ipv6_address*]
#   Allow traffic from this IPv6 address
# [*proto*]
#   Allow only this protocol type (defaults to 'all')
# [*dport*]
#   Allow traffic to this local port/port range
#
# == Examples
#
#   packetfilter::accept::traffic_to_ip { 'allow web access from management node':
#       iface => 'eth0',
#       ipv4_address => '192.168.30.30',
#       ipv6_address => '::1',
#       proto => 'tcp',
#       dport => '443',
#   }
#
# == Authors
#
# Samuli Seppänen <samuli.seppanen@gmail.com>
#
define packetfilter::accept::traffic_from_ip_to_port(
    $iface,
    $ipv4_address,
    $ipv6_address,
    $proto='all',
    $dport
)
{
    firewall { "007 ipv4 accept inbound from $ipv4_address to port $dport":
        provider => 'iptables',
        chain => 'INPUT',
        proto => "$proto",
        action => 'accept',
        source => "$ipv4_address",
        dport => "$dport",
        iniface => "$iface",
    }

    firewall { "007 ipv6 accept inbound from $ipv6_address to port $dport":
        provider => 'ip6tables',
        chain => 'INPUT',
        proto => "$proto",
        action => 'accept',
        source => "$ipv6_address",
        dport => "$dport",
        iniface => "$iface",
    }
}
