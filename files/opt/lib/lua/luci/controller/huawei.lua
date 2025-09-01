module("luci.controller.huawei", package.seeall)

function index()
  entry({"admin", "network", "huawei"}, alias("admin", "network", "huawei/signal"), _("Huawei Integration"), 20).dependent = true
  entry({"admin", "network", "huawei/signal"}, cbi("huawei-signal"), _("Huawei Signal & Control"), 1)
  entry({"admin", "network", "huawei/signal_data"}, call("get_signal_data"), nil).leaf = true
end

function get_signal_data()
  local signal_output = luci.sys.exec("/opt/bin/huawei_signal signal")
  if not signal_output or signal_output == "" then
    luci.http.prepare_content("application/json")
    luci.http.write_json({error="Failed to fetch signal data"})
    return
  end
  local data = {
    rsrp = "-", sinr = "-", rsrq = "-", rssi = "-", cell_id = "-", pci = "-",
    band = "-", dlbandwidth = "-", operator = "-", mccmnc = "-", signal_icon = "-",
    download_rate = "-", upload_rate = "-"
  }
  local line_count = 0
  for line in signal_output:gmatch("[^\r\n]+") do
    line_count = line_count + 1
    if line:match("dBm$") then
      if line:match("RSRP") then data.rsrp = line:match("[-0-9.]+") .. " dBm"
      elseif line:match("SINR") then data.sinr = line:match("[-0-9.]+") .. " dB"
      elseif line:match("RSRQ") then data.rsrq = line:match("[-0-9.]+") .. " dB"
      elseif line:match("RSSI") then data.rssi = line:match("[-0-9.]+") .. " dBm"
      end
    elseif line:match("MHz$") then
      data.dlbandwidth = line:match("[0-9.]+") .. " MHz"
    elseif line:match("^[0-9]+$") and line_count <= 6 then
      if not data.cell_id:match("-") then data.pci = line
      else data.cell_id = line end
    elseif line:match("^B[0-9]+$") then data.band = line
    elseif line:match("^[0-9]{5,6}$") then data.mccmnc = line
    elseif line:match("^[0-5]$") then data.signal_icon = line
    elseif line_count == 9 then data.operator = line
    elseif line:match("^[0-9]+$") then
      if line_count == 11 then
        data.download_rate = string.format("%.2f KB/s", tonumber(line) / 1024)
      elseif line_count == 12 then
        data.upload_rate = string.format("%.2f KB/s", tonumber(line) / 1024)
      end
    end
  end
  luci.http.prepare_content("application/json")
  luci.http.write_json(data)
end
