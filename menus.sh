#!/bin/bash

function headerLogo {
  clear
  printf "\n  ${YELLOW}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ \n"
  printf "  +++-----------------------------------------------------------------------------------------+++ \n"
  printf "  +++------------------------------------ [ ${RED}BLOCK_IT${YELLOW} ] ---------------------------------------+++ \n"
  printf "  +++-----------------------------------------------------------------------------------------+++ \n"
  printf "  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ ${WHITE} \n"
  printf "\n \n"
}

function openingHeader {
  # SHOW HEADER WHEN OPEN APP
  headerLogo

  # GET USER INTERFACE AND IP ADDRESS
  getDefaultInterface
  echo -e "                             Your selected interface is ${YELLOW}"$defaultInterface ${WHITE};
  getIPAddress
  echo -e "                             Your IP Address is${YELLOW}" $userIPAddress;
  printf "\n \n${WHITE}"
}

function firstMenu {
  printf "  [1] Remove device from network \n"
  printf "  [2] Show devices in the network \n\n"
  printf "  [3] EXIT \n"

  read -n 1 -s -r firstMenuSelectedOption

  if [ $firstMenuSelectedOption = 1 ]
    then
      getIPAddressesInNetwork
      removeDeviceFromNetwork
  elif [ $firstMenuSelectedOption = 2 ]
    then
      getIPAddressesInNetwork
      showDevicesInNetwork
  elif [ $firstMenuSelectedOption = 3 ]
    then
      printf "\n\n"
      printf "  ${YELLOW}Bye! Have a great time!\n  ${WHITE}\n\n"
      sleep 2

      exit
  fi
}


function askForAnyKeyReturn {

  printf "\n\n"
  read -n 1 -s -r -p "     Press any key to return to MENU...
      

      "
  return
}
