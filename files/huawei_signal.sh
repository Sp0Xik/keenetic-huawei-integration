#!/bin/sh

# Читаем конфиг из UCI
HUAWEI_IP=$(uci get huawei.config.ip 2>/dev/null || echo "192.168.8.1")
USER=$(uci get huawei.config.username 2>/dev/null || echo "admin")
PASS=$(uci get huawei.config.password 2>/dev/null || echo "admin")

get_token() {
  curl -s "http://${HUAWEI_IP}/api/webserver/SesTokInfo" -u "${USER}:${PASS}" | xmlstarlet sel -t -v "//TokInfo"
}

get_model() {
  curl -s "http://${HUAWEI_IP}/api/device/information" -H "Cookie: SessionId=$TOKEN" -u "${USER}:${PASS}" | xmlstarlet sel -t -v "//DeviceName" | grep -o "B[0-9]\{3\}-[0-9]\{3\}"
}

TOKEN=$(get_token)
MODEL=$(get_model)

case "$1" in
  signal)
    SIGNAL_DATA=$(curl -s "http://${HUAWEI_IP}/api/device/signal" -H "Cookie: SessionId=$TOKEN" -u "${USER}:${PASS}")
    PLMN_DATA=$(curl -s "http://${HUAWEI_IP}/api/net/current-plmn" -H "Cookie: SessionId=$TOKEN" -u "${USER}:${PASS}")
    STATUS_DATA=$(curl -s "http://${HUAWEI_IP}/api/monitoring/status" -H "Cookie: SessionId=$TOKEN" -u "${USER}:${PASS}")
    TRAFFIC_DATA=$(curl -s "http://${HUAWEI_IP}/api/monitoring/traffic-statistics" -H "Cookie: SessionId=$TOKEN" -u "${USER}:${PASS}")
    case "$MODEL" in
      B535-232|B530-336)
        echo "$SIGNAL_DATA" | xmlstarlet sel -t \
          -v "//rsrp" -o " dBm" -n \
          -v "//sinr" -o " dB" -n \
          -v "//rsrq" -o " dB" -n \
          -v "//rssi" -o " dBm" -n \
          -v "//cell_id" -o "" -n \
          -v "//pci" -o "" -n \
          -v "//band" -o "" -n \
          -v "//dlbandwidth" -o " MHz" -n
        echo "$PLMN_DATA" | xmlstarlet sel -t \
          -v "//FullName" -o "" -n \
          -v "//Numeric" -o "" -n
        echo "$STATUS_DATA" | xmlstarlet sel -t \
          -v "//SignalIcon" -o "" -n
        echo "$TRAFFIC_DATA" | xmlstarlet sel -t \
          -v "//CurrentDownloadRate" -o " bytes/s" -n \
          -v "//CurrentUploadRate" -o " bytes/s" -n
        ;;
      B320-323)
        echo "$SIGNAL_DATA" | xmlstarlet sel -t \
          -v "//rsrp" -o " dBm" -n \
          -v "//sinr" -o " dB" -n \
          -v "//rssi" -o " dBm" -n \
          -v "//cell_id" -o "" -n \
          -v "//pci" -o "" -n \
          -v "//band" -o "" -n
        echo "$PLMN_DATA" | xmlstarlet sel -t \
          -v "//FullName" -o "" -n \
          -v "//Numeric" -o "" -n
        echo "$STATUS_DATA" | xmlstarlet sel -t \
          -v "//SignalIcon" -o "" -n
        echo "$TRAFFIC_DATA" | xmlstarlet sel -t \
          -v "//CurrentDownloadRate" -o " bytes/s" -n \
          -v "//CurrentUploadRate" -o " bytes/s" -n
        ;;
      *)
        echo "$SIGNAL_DATA" | xmlstarlet sel -t \
          -v "//rsrp" -o " dBm" -n \
          -v "//sinr" -o " dB" -n \
          -v "//rssi" -o " dBm" -n \
          -v "//cell_id" -o "" -n \
          -v "//pci" -o "" -n \
          -v "//band" -o "" -n
        echo "$PLMN_DATA" | xmlstarlet sel -t \
          -v "//FullName" -o "" -n \
          -v "//Numeric" -o "" -n
        echo "$STATUS_DATA" | xmlstarlet sel -t \
          -v "//SignalIcon" -o "" -n
        echo "$TRAFFIC_DATA" | xmlstarlet sel -t \
          -v "//CurrentDownloadRate" -o " bytes/s" -n \
          -v "//CurrentUploadRate" -o " bytes/s" -n
        ;;
    esac
    ;;
  status)
    curl -s "http://${HUAWEI_IP}/api/monitoring/status" -H "Cookie: SessionId=$TOKEN" -u "${USER}:${PASS}" | xmlstarlet sel -t -v "//ConnectionStatus"
    ;;
  reboot)
    curl -s -X POST "http://${HUAWEI_IP}/api/device/control" -H "Cookie: SessionId=$TOKEN" -u "${USER}:${PASS}" -d '<request><Control>1</Control></request>'
    ;;
  *)
    echo "Usage: $0 {signal|status|reboot}"
    exit 1
    ;;
esac
