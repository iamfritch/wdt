#!/bin/sh

info() {
    cat << EOF
        WhoisDig Tool v2.1 - written by Mark Fritchen in February 2016
        
        Returns relevant fields from a whois and dig query for the domain.
        
        Use: wdt [wdD] [domain]
             wdt -h
             wdt
        
        -h : Print this help screen. Overrides any other options.
        
        -w: Print whois information for domain.
        
        -d: Print domain information.
        
        -D: Print domain information.
	    This option includes the www. version of the domain

        -@: Print domain information from our servers specifically.
EOF
}

whoisinfo() {
    echo "***  whois  ********************************************************************"
    whois $domain
}

whoisgrepinfo() {
    whos=$(whois $domain)
    echo "***  whois  ********************************************************************"
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
}

digdomain() {
    echo "***  non-www  ******************************************************************"
    zoneRecord=$(dig $domain any)
    echo "$zoneRecord" | grep -P "A\t"
    echo "$zoneRecord" | grep -P "A "
    echo "$zoneRecord" | grep -P "MX\t"
    echo "$zoneRecord" | grep -P "MX "
    echo "$zoneRecord" | grep -P "CNAME\t"
    echo "$zoneRecord" | grep -P "CNAME "
    echo "$zoneRecord" | grep -P "NS\t"
    echo "$zoneRecord" | grep -P "NS "
}

digwwwdotdomain() {
    echo "***  www  **********************************************************************"
    zoneRecord=$(dig "www."$domain any)
    echo "$zoneRecord" | grep -P "A\t"
    echo "$zoneRecord" | grep -P "A "
    echo "$zoneRecord" | grep -P "MX\t"
    echo "$zoneRecord" | grep -P "MX "
    echo "$zoneRecord" | grep -P "CNAME\t"
    echo "$zoneRecord" | grep -P "CNAME "
    echo "$zoneRecord" | grep -P "NS\t"
    echo "$zoneRecord" | grep -P "NS "
}

digdomainourns() {
    echo "***  non-www our server  *******************************************************"
    zoneRecord=$(dig @74.220.195.31 $domain any)
    echo "$zoneRecord" | grep -P "A\t"
    echo "$zoneRecord" | grep -P "A "
    echo "$zoneRecord" | grep -P "MX\t"
    echo "$zoneRecord" | grep -P "MX "
    echo "$zoneRecord" | grep -P "CNAME\t"
    echo "$zoneRecord" | grep -P "CNAME "
    echo "$zoneRecord" | grep -P "NS\t"
    echo "$zoneRecord" | grep -P "NS "
}

if [ $1 ]; then
    eval domain=\$$#
else
    info
    exit
fi

options=false
while getopts hwdD@ option; do
  case $option in
    h)
        info
        options=true;;
    w)
        whoisinfo
        options=true;;
    d)
        digdomain
        options=true;;
    D)
        digdomain
        digwwwdotdomain
        options=true;;
    @)
        digdomainourns
        options=true;;
    \?)
        echo "invalid argument"
        info
        exit;;
  esac
done
if($options) then
    echo "********************************************************************************"
    exit
else
    whoisgrepinfo
    digdomain
    digwwwdotdomain
    echo "********************************************************************************"
fi
