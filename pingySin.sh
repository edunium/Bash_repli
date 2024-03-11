#!/bin/bash
clear
rm octeto.txt 2>/dev/null
rm ipfind.txt 2>/dev/null
rm  puerto 2>/dev/null
trap ctrl_c INT
function ctrl_c(){
  echo "Saliendo..."
  exit 1  

}

ifconfig | grep "flags" | awk '{print $1}' | tr -d ":" > interfaces.txt
echo "Buscando..."
sleep 1

echo "INTERFACES DISPONIBLES: " $(cat interfaces.txt)
read -p "Elija una opcion: " op

while IFS= read -r interface
do 
  if [ $op = $interface ]
  then
      ifconfig $interface | grep "netmask" | awk '{print $2}' | cut -d "." -f 1,2,3 >> octeto.txt
    fi
done < interfaces.txt
for ip in {1..254}
do
  while IFS= read -r contador
  do
    ping -c 1 $contador.$ip | grep "64 bytes" | awk '{print $4}' | tr -d ":" >> ipfind.txt &
  done < octeto.txt
    echo -e "espere... $ip "

done
clear
echo "ESCANEO TERMINADO..."
sleep 2
clear
echo "Lista de ip encontradas"
echo ""
echo -e "$(cat ipfind.txt)\n"
echo ""
echo "ej. -p- --open -sS --min-rate 5000 -vvv -n -Pn ip -oG * -sC -sV -p22,xx ip -oN o -oG text"
echo ""
read -p "Ingrese la host: " host
nmap -p- -sS --min-rate 5000 -vvv -n -nP $host -oG puerto
exit 1

