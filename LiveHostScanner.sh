#! /bin/bash

ipv4=$(hostname -I)  # Private ipv4 address assigned to variable
ipblock1=$(echo $ipv4 | cut -f1 -d.)
ipblock2=$(echo $ipv4 | cut -f2 -d.)  # Cut until you see the second (-f2) . (-d.) in the ipv4 variable
ipblock3=$(echo $ipv4 | cut -f3 -d.)

touch liveHosts.txt
echo "" >> liveHosts.txt
echo "---------LIVING HOSTS---------" >> liveHosts.txt

for i in {1..254}
do
    ping -c 1 $ipblock1'.'$ipblock2'.'$ipblock3'.'$i > pingList$i.txt
    awk '{if (NR==2) print$4}' pingList$i.txt > values.txt

    value=$(cat values.txt)
    trueValue=$(echo $value | cut -f1 -d:)
    
    if [ "$trueValue" != "Destination" ]
    then
        echo ${trueValue} >> liveHosts.txt
    else
    	echo $ipblock1'.'$ipblock2'.'$ipblock3'.'$i' => Dead Host'
    fi

    rm -r pingList$i.txt
    rm -r values.txt
done

cat liveHosts.txt
rm -r liveHosts.txt
