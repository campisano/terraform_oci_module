#!/usr/bin/env bash

set -x -o errexit -o nounset -o pipefail

(
    echo -e "\n\t\tCustom init script start...\n"

    echo -e "\n\tconfigure apt and upgrade:"
    echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
    apt-get -y update > /dev/null
    apt-get -y install --no-install-recommends apt-utils > /dev/null
    apt-get -y install ca-certificates > /dev/null
    apt-get -y autoremove --purge snapd unattended-upgrades networkd-dispatcher > /dev/null
    apt-get -y dist-upgrade > /dev/null
    apt-get -y install binutils nano psmisc lsof findutils grep less tar gzip bzip2 procps iptables kmod curl cron dnsutils telnet iputils-ping netcat-traditional > /dev/null
    apt-get -y clean > /dev/null

    echo -e "\n\tconfigure firewall:"
    iptables-save > /root/iptables.bkp
    iptables --insert INPUT 1 --source 10.1.21.0/24 --proto tcp --dport 2376 --jump ACCEPT
    iptables --insert INPUT 1 --source 10.1.21.0/24 --proto tcp --dport 2377 --jump ACCEPT
    iptables --insert INPUT 1 --source 10.1.21.0/24 --proto tcp --dport 7946 --jump ACCEPT
    iptables --insert INPUT 1 --source 10.1.21.0/24 --proto udp --dport 7946 --jump ACCEPT
    iptables --insert INPUT 1 --source 10.1.21.0/24 --proto udp --dport 4789 --jump ACCEPT
    iptables --insert INPUT 1 --match state --state NEW --proto tcp --dport 80 --jump ACCEPT

    echo -e "\n\tinstall and setup docker:"
    apt-get -y install docker.io docker-compose > /dev/null
    apt-get -y clean > /dev/null
    mkdir -p /srv/local/swarm
    useradd --system --uid 500 --gid nogroup --groups docker --no-create-home --home-dir /srv/local/swarm --shell /bin/bash swarm
    chown swarm:nogroup /srv/local/swarm

    echo -e "\n\t\tCustom init script completed.\n"
) &> /root/init_script.log
