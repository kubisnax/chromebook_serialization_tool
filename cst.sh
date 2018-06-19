#!/bin/bash

getSerial() {
  (vpd -g "serial_number")
  #pulls serial number from vpd and displays only the serial number
}

getServiceTag() {
  (vpd -g "service_tag" 2> /dev/null )
  #pulls service tag from vpd and only displays the service tag
}

serialNumber=$(getSerial)

serviceTag=$(getServiceTag)

serialize() {
  if [ -n "$serviceTag" ]; #determines if a service tag is present
    then
      
      echo "Current Serial Number is $(getSerial)"
      
      echo "Current Service Tag is $(getServiceTag)"
      
      echo ""
        
      echo "Enter custom Serial Number & Service Tag then press Enter key to continue: "

      read -e custSerial #takes custom serial number entered by user

      vpd -s "serial_number"="$custSerial" #writes custom serial number to device
      
      vpd -s "service_tag"="$custSerial" #writes custom serial to device under service tag
        
      echo ""

      echo "Serial Number is now $(getSerial)"
      
      echo ""
      
      echo "Service Tag is now $(getServiceTag)"
  
    else
      
      echo "Current Serial Number is: $(getSerial)" #Used if there is no service tag on device
      
      echo ""
  
      echo "Enter custom Serial Number then press Enter key to continue: "

      read -e custSerial #takes custom serial number entered by user

      vpd -s "serial_number"="$custSerial" #writes custom serial number to device
  
      echo ""

      echo "Serial Number is now: $(getSerial)"
  fi
}

cleanUp() {
  
  echo ""
  
  echo "Cleaning up and rebooting... "

  /usr/share/vboot/bin/set_gbb_flags.sh 0 &> /dev/null #sets gbb_flags to 0x0, sends output to /dev/null/

  vpd -d "mlb_serial_number" -d "stable_device_secret_DO_NOT_SHARE" -d "Product_S/N" &> /dev/null #deletes mlb_serial_number, stable_device_secret & Product_S/N then sends output to /dev/null/

  vpd -i "RW_VPD" -s "check_enrollment"="0" -s "block_devmode"="0" -d "stable_device_secret_DO_NOT_SHARE" &> /dev/null #Breaks FRE

  dump_vpd_log --force &> /dev/null #dumps vpd logs, sends output to /dev/null/
  
  shutdown -r 0 #reboots device
  
  exit 0
  
}


while true; do

serialize

echo ""

echo "Enter 1 to Finish or 2 to Restart: "

  select end in "Finish" "Restart"; do

    case $end in
    
      Finish ) cleanUp;;
      
      Restart ) serialize
      echo ""
      echo "Enter 1 to Finish and 2 to Restart: "
      echo "1) Finish"
      echo "2) Restart";;
      
      * ) echo -e "\e[31mInvalid Input\e[0m";;
      
    esac
    
  done
  
  
done

  
