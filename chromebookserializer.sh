#!/bin/bash

getSerial() {
  (vpd -l | grep -w "serial_number" | tr -d "serial_number" | tr -d "=" | tr -d '""')
}

getServiceTag() {
  (vpd -l | grep -w "service_tag" | tr -d "service_tag" | tr -d "=" | tr -d '""')
}

serialize() {
  if [ -n "$serviceTag" ];
    then
      
      echo "Current Serial Number is $(getSerial)"
      
      echo ""
      
      echo "Current Service Tag is $(getServiceTag)"
      
      echo ""
        
      echo "Enter custom Serial Number & Service Tag: "

      read -e custSerial

      vpd -s "serial_number"="$custSerial"
      
      vpd -s "service_tag"="$custSerial"
        
      echo ""

      echo "Serial Number is now $(getSerial)"
      
      echo ""
      
      echo "Service Tag is now $(getServiceTag)"
      
    else
      echo "Current Serial Number is: $(getSerial)"
      
      echo ""
  
      echo "Enter custom Serial Number : "

      read -e custSerial

      vpd -s "serial_number"="$custSerial"
  
      echo ""

      echo "Serial Number is now: $(getSerial)"
  fi
}

cleanUp() {
  
  echo ""
  
  echo "Cleaning up and rebooting... "

  /usr/share/vboot/bin/set_gbb_flags.sh 0 &> /dev/null

  vpd -d "mlb_serial_number" &> /dev/null

  vpd -d "stable_device_secret_DO_NOT_SHARE" &> /dev/null

  dump_vpd_log --force --full --stdout &> /dev/null

  shutdown -r 0
  
}

end="n"

serialNumber=$(getSerial)

serviceTag=$(getServiceTag)

while [ $end == "n" ]; do

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
      
    esac
    
  done
  
  
done
  


#Written by Kyle Kubiak for the Trinity3 RMA team :)
  