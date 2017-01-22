#!/bin/bash

helpInfo() {
    cat << EOF
        WhoisDig Tool v4.0 - written by Mark Fritchen & Daniel Mabey
        
        Returns relevant fields from a whois and dig query for the domain.
        
        Use:    wdt [option]... [domain]    MUST ADD SPACE BETWEEN EACH OPTION
                wdt [-h]
        
        h | -h | --help:
            Print this help screen. Overrides any other options.
        
        w | -w | --whois:
            Print whois information for domain.
        
        d | -d | --dig:
            Print domain information.
        
        D | -D | --digw:
            Print domain information.
            This option includes the www. version of the domain.
        
        p | -p | --propagation
            Runs a dig for the @ A record of the domain name
            Checks through 3 different name servers and displays the result

        @[Name Server IP]:
            Print domain information from the specified Name Server's IP.
EOF
}

whoisInfo() {
    echo -e "***  whois  ********************************************************************"
    whost=$(timeout .5 whois domain | sed 's/\s\+/\n/g' | grep -m 1 whois.)
    if [[ $whost == "" ]]
    then
        whost=$(timeout .5 whois -h whois.iana.org $domain | egrep -e '^whois:' |   sed -e 's/[[:space:]][[:space:]]*/ /g' |   cut -d " " -f 2)
    fi
    whos=$(timeout .5 whois -h $whost $domain)$(whois $domain)
    whos=$(echo "$whos" | sed -e 's/^[ \t]*//' | sort | uniq -i --check-chars=11)
    LIST1=("WHOIS database:"
           "Registrar:"
           "Registrar Name:"
           "Registrar WHOIS"
           "Name Server:"
           "Provider Name"
           "Whois Server"
           "Updated Date"
           "Creation Date"
           "Expiration"
           "Domain Status"
           "Registrant Email"
           "Admin Street"
           "Admin City"
           "Admin State"
           "Admin Phone"
           "Admin Email")
    
    for ((i = 0; i < ${#LIST1[@]}; i++))
    do
        echo "$whos" | grep "${LIST1[$i]}"
    done
}

runDig() {
    LIST=("A"
          "CNAME"
          "MX"
          "NS")
    
    for i in ${LIST[@]}
    do
        records=$(dig @$ip +short $domain $i)
        for j in $records
        do
            if [ ${#j} -gt 3 ]
            then
                echo -e $domain"\t\t"$i"\t\t"$j
            fi
        done
    done
}

digDomain() {
    echo -e "***  non-www  ******************************************************************"
    runDig
    echo -e "***  host   ********************************************************************"
    for i in $(dig +short $domain)
    do
        echo $i | timeout .5 xargs whois 2> /dev/null | grep -i netname
    done
}

digDubDomain() {
    echo -e "***  www  **********************************************************************"
    domain="www."$domain
    runDig
}

propagation() {
    echo -e "***  non-www  ******************************************************************"
    zoneRecord=$(dig @$ip +short $domain)
    echo -e $domain"\t\t"$zoneRecord
    echo -e "***  non-www our server  *******************************************************"
    zoneRecord=$(dig +short $domain)
    echo -e $domain"\t\t"$zoneRecord
    echo -e "***  non-www other name server  ************************************************"
    zoneRecord=$(dig @$otherIP +short $domain)
    echo -e $domain"\t\t"$zoneRecord
    echo -e "***  non-www other name server  ************************************************"
    zoneRecord=$(dig @$otherIP2 +short $domain)
    echo -e $domain"\t\t"$zoneRecord
    echo -e "***  non-www other name server  ************************************************"
    zoneRecord=$(dig @$otherIP3 +short $domain)
    echo -e $domain"\t\t"$zoneRecord
}

if [ $1 ]
then
    domain=""
    for i in $@
    do
        options=("${options[@]}" "$domain")
        domain=$i
    done
    domain=$(echo -e $domain | sed 's|http.*://||' | sed 's|www.||' | sed 's|/.*||')
else
    helpInfo
    exit
fi
ip="8.8.8.8"
otherIP="168.1.79.229"
otherIP2="140.207.198.6"
otherIP3="115.182.93.97"
RANGE=225
if [[ ${options[@]} == "" ]]
then
    whoisInfo
    digDomain
    digDubDomain
    echo -e "********************************************************************************"
    exit
fi
for i in ${options[@]}
do
    case $i in
        h | --help | -h)
            helpInfo
            ;;
        w | --whois | -w)
            whoisInfo
            ;;
        d | --dig | -d)
            digDomain
            ;;
        D | --digw | -D)
            digDomain
            digDubDomain
            ;;
        p | --propagation | -p)
            propagation
            ;;
        @*)
            ip=$i
            digDomain
            ;;
        *)
            echo "invalid argument"
            helpInfo
            exit
    esac
done
echo -e "********************************************************************************"
