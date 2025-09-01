#!/bin/sh

CONFIG=/opt/etc/config/huawei
LOGFILE=/var/log/huawei_signal.log
RESPONSE=/tmp/huawei_response.xml

# Read IP, username, and password from config
[ -f "$CONFIG" ] || { echo "Config file $CONFIG not found" >> "$LOGFILE"; exit 1; }
IP=$(uci get huawei.config.ip)
USER=$(uci get huawei.config.username)
PASS=$(uci get huawei.config.password)

# Function to get signal data from Huawei router
get_huawei_signal() {
  curl -s -u "$USER:$PASS" "http://$IP/api/monitoring/status" > "$RESPONSE"
  if [ $? -ne 0 ]; then
    echo "Failed to connect to Huawei modem at $IP" >> "$LOGFILE"
    exit 1
  fi
  RSRP=$(grep -oP '(?<=<RSRP>)[^<]+' "$RESPONSE")
  SINR=$(grep -oP '(?<=<SINR>)[^<]+' "$RESPONSE")
  RSRQ=$(grep -oP '(?<=<RSRQ>)[^<]+' "$RESPONSE")
  RSSI=$(grep -oP '(?<=<RSSI>)[^<]+' "$RESPONSE")
  CELL_ID=$(grep -oP '(?<=<CellID>)[^<]+' "$RESPONSE")
  PCI=$(grep -oP '(?<=<PCI>)[^<]+' "$RESPONSE")
  BAND=$(grep -oP '(?<=<Band>)[^<]+' "$RESPONSE")
  BANDWIDTH=$(grep -oP '(?<=<Bandwidth>)[^<]+' "$RESPONSE")
  OPERATOR=$(grep -oP '(?<=<Operator>)[^<]+' "$RESPONSE")
  MCC=$(grep -oP '(?<=<MCC>)[^<]+' "$RESPONSE")
  MNC=$(grep -oP '(?<=<MNC>)[^<]+' "$RESPONSE")
  SIGNAL_LEVEL=$(grep -oP '(?<=<SignalIcon>)[^<]+' "$RESPONSE")
  DOWNLOAD_RATE=$(grep -oP '(?<=<CurrentDownloadRate>)[^<]+' "$RESPONSE")
  UPLOAD_RATE=$(grep -oP '(?<=<CurrentUploadRate>)[^<]+' "$RESPONSE")
  echo "RSRP=$RSRP SINR=$SINR RSRQ=$RSRQ RSSI=$RSSI CELL_ID=$CELL_ID PCI=$PCI BAND=$BAND BANDWIDTH=$BANDWIDTH OPERATOR=$OPERATOR MCC=$MCC MNC=$MNC SIGNAL_LEVEL=$SIGNAL_LEVEL DOWNLOAD_RATE=$DOWNLOAD_RATE UPLOAD_RATE=$UPLOAD_RATE" >> "$LOGFILE"
  echo "RSRP=$RSRP SINR=$SINR RSRQ=$RSRQ RSSI=$RSSI CELL_ID=$CELL_ID PCI=$PCI BAND=$BAND BANDWIDTH=$BANDWIDTH OPERATOR=$OPERATOR MCC=$MCC MNC=$MNC SIGNAL_LEVEL=$SIGNAL_LEVEL DOWNLOAD_RATE=$DOWNLOAD_RATE UPLOAD_RATE=$UPLOAD_RATE"
}

# Function to get status
get_huawei_status() {
  curl -s -u "$USER:$PASS" "http://$IP/api/device/information" > "$RESPONSE"
  if [ $? -ne 0 ]; then
    echo "Failed to get status from Huawei modem at $IP" >> "$LOGFILE"
    exit 1
  fi
  DEVICE_NAME=$(grep -oP '(?<=<DeviceName>)[^<]+' "$RESPONSE")
  SERIAL_NUMBER=$(grep -oP '(?<=<SerialNumber>)[^<]+' "$RESPONSE")
  echo "DEVICE_NAME=$DEVICE_NAME SERIAL_NUMBER=$SERIAL_NUMBER" >> "$LOGFILE"
  echo "DEVICE_NAME=$DEVICE_NAME SERIAL_NUMBER=$SERIAL_NUMBER"
}

# Function to reboot Huawei router
reboot_huawei() {
  curl -s -u "$USER:$PASS" -X POST "http://$IP/api/device/control" -d '<?xml version="1.0" encoding="UTF-8"?><request><Control>1</Control></request>' > /dev/null
  if [ $? -eq 0 ]; then
    echo "Reboot command sent to Huawei modem at $IP" >> "$LOGFILE"
  else
    echo "Failed to send reboot command to Huawei modem at $IP" >> "$LOGFILE"
    exit 1
  fi
}

# Main logic
case "$1" in
  signal)
    get_huawei_signal
    ;;
  status)
    get_huawei_status
    ;;
  reboot)
    reboot_huawei
    ;;
  *)
    echo "Usage: $0 {signal|status|reboot}" >> "$LOGFILE"
    exit 1
    ;;
esac

rm -f "$RESPONSE"
exit 0
