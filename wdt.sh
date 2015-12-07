#!/bin/sh

info() {
    cat << EOF
        WhoisDig Tool v1.2 - written by Mark Fritchen 2015
        
        Returns relevant fields from a whois and dig query for the domain.
        
        Use: dwt [domain]
EOF
}

lookup() {
    whos=$(whois $domain)
    echo "********************************************************************************"
    echo "$whos" | grep "WHOIS database:"
    echo "$whos" | grep "Registrar:"
    echo "$whos" | grep "Registrar Name:"
    echo "$whos" | grep "Registrar WHOIS"
    echo "$whos" | grep "Name Server:"
    echo "$whos" | grep "Provider Name"
    echo "$whos" | grep "Whois Server"
    echo "$whos" | grep "Updated Date"
    echo "$whos" | grep "Creation Date"
    echo "$whos" | grep "Registration Expiration Date"
    echo "$whos" | grep "Domain Status"
    echo "$whos" | grep "Registrant Email"
    echo "$whos" | grep "Admin Street"
    echo "$whos" | grep "Admin City"
    echo "$whos" | grep "Admin State"
    echo "$whos" | grep "Admin Phone"
    echo "$whos" | grep "Admin Email"
    echo "********************************************************************************"
    zoneRecord=$(dig $domain any)
    echo "$zoneRecord" | grep -P "A\t"
    echo "$zoneRecord" | grep -P "A "
    echo "$zoneRecord" | grep -P "MX\t"
    echo "$zoneRecord" | grep -P "MX "
    echo "$zoneRecord" | grep -P "CNAME\t"
    echo "$zoneRecord" | grep -P "CNAME "
    echo "$zoneRecord" | grep -P "NS\t"
    echo "$zoneRecord" | grep -P "NS "
    echo "********************************************************************************"
}

while getopts ":H:h" option; do
  case $option in
    h|H)
        info
        exit;;
    \?)
        echo "invalid argument"
        info
        exit;;
  esac
done

if [ $1 ]; then
    domain=$1
    lookup
else
    info
fi
exit
