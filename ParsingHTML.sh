#!/bin/bash
if [ "$1" == "" ]
then
	printf "\033[31;1mERRO:\033[m Informe os argumentos corretamente...\n"
	printf "\033[34;1mUsage:\033[m $0 alvo.com.br"
else
	echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
	echo "+                                                                 +"
	printf "+....................... \033[34;1mPARSING HTML v1.0\033[m .......................+\n"
	echo "+                                                                 +"
	printf "+.\033[34;1mCreated by: Murillo NP\033[m..........................................+\n"
	echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
	if wget $1 2> /dev/null
	then
		echo " "
		printf "\033[32;1m[+] Resolvendo URLS em: \033[36;1m$1\n\n\033[m"

		cat index.html | grep -o '<a .*href=.*>' | sed -e 's/<a /\n<a /g' | sed -e 's/<a .*href=['"'"'"]//' -e 's/["'"'"'].*$//' -e '/^$/ d' | grep :// | cut -d "/" -f 3 | cut -d ":" -f 1 | grep "\." | grep -v "%" | sort | uniq > dominios.txt
	else
		printf "\033[31;1mSite sem resposta!"
	fi

	for dominio in $(cat dominios.txt);
	do
        	host $dominio | grep "has address" | cut -d " " -f 4 > ips.txt

        	for ip in $(cat ips.txt);
        	do
                	printf "\033[31;1m==> \033[32;1m$ip\t\033[31;1m$dominio\n\033[m"
        	done
	done

echo " "
printf "\033[31;1m[+] Analize concluida! Resultados salvos em: \033[32;1m$1.ip.txt\n\033[m"

fi

echo
	rm index*.* &> /dev/null
	rm dominios.txt &> /dev/null
