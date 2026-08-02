#!/vendor/bin/sh

sarstate=$(getprop "persist.sys.sar" "")
log "set sar!"
log $sarstate

if [ $sarstate = "0" ] 
then
    log "disabled sar"
    /vendor/bin/vendor_cmd_tool -f /vendor/etc/sar/sar-vendor-cmd.xml -i wlan0 --START_CMD --SAR_SET --ENABLE 5 --NUM_SPECS 0 --END_CMD

elif [ $sarstate = "1" ] 
then
    log "enable sar 1"
    /vendor/bin/vendor_cmd_tool -f /vendor/etc/sar/sar-vendor-cmd.xml -i wlan0 --START_CMD --SAR_SET --ENABLE 7 --NUM_SPECS 2 --SAR_SPEC --NESTED_AUTO  --CHAIN 0  --POW_IDX 0 --END_ATTR --NESTED_AUTO --CHAIN 1 --POW_IDX 0 --END_ATTR  --END_ATTR --END_CMD

elif [ $sarstate = "2" ] 
then
    log "enable sar 2"
    /vendor/bin/vendor_cmd_tool -f /vendor/etc/sar/sar-vendor-cmd.xml -i wlan0 --START_CMD --SAR_SET --ENABLE 7 --NUM_SPECS 2 --SAR_SPEC --NESTED_AUTO  --CHAIN 0  --POW_IDX 1 --END_ATTR --NESTED_AUTO --CHAIN 1 --POW_IDX 1 --END_ATTR  --END_ATTR --END_CMD

elif [ $sarstate = "3" ] 
then
    log "enable sar 3"
    /vendor/bin/vendor_cmd_tool -f /vendor/etc/sar/sar-vendor-cmd.xml -i wlan0 --START_CMD --SAR_SET --ENABLE 5 --NUM_SPECS 0 --END_CMD

elif [ $sarstate = "4" ] 
then
    log "enable sar 4"
    /vendor/bin/vendor_cmd_tool -f /vendor/etc/sar/sar-vendor-cmd.xml -i wlan0 --START_CMD --SAR_SET --ENABLE 5 --NUM_SPECS 0 --END_CMD

elif [ $sarstate = "5" ]
then
    log "enable sar 5"
    /vendor/bin/vendor_cmd_tool -f /vendor/etc/sar/sar-vendor-cmd.xml -i wlan0 --START_CMD --SAR_SET --ENABLE 5 --NUM_SPECS 0 --END_CMD

else
    log "disable sar-do nothing!"

fi
