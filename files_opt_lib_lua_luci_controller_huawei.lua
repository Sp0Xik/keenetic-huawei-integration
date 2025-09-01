module("luci.controller.huawei", package.seeall)

function index()
  entry({"admin", "network", "huawei"}, alias("admin", "network", "huawei/signal"), _("Huawei Integration"), 20).dependent = true
  entry({"admin", "network", "huawei/signal"}, cbi("huawei-signal"), _("Huawei Signal & Control"), 1)
  entry({"admin", "network", "huawei/signal_data"}, call("get_signal_data"), nil).leaf = true
end

function get_signal_data()
  local signal_output = luci.sys.exec("/opt/bin/huawei_signal signal")
  local data = {
    rsrp = "-", sinr = "-", rsrq = "-", rssi = "-", cell_id = "-", pci = "-",
    band = "-", dlbandwidth = "-", operator = "-", mccmnc = "-", signal_icon = "-",
    download_rate = "-", upload_rate = "-"
  }
  for line in signal_output:gmatch("[^\r\n]+") do
    if line:match("dBm$") then
      if line:match("RSRP") then data.rsrp = line:match("[-0-9.]+") .. " dBm"
      elseif line:match("SINR") then data.sinr = line:match("[-0-9.]+") .. " dB"
      elseif line:match("RSRQ") then data.rsrq = line:match("[-0-9.]+") .. " dB"
      elseif line:match("RSSI") then data.rssi = line:match("[-0-9.]+") .. " dBm"
      end
    elseif line:match("MHz$") then
      data.dlbandwidth = line:match("[0-9.]+") .. " MHz"
    elseif line:match("bytes/s$") then
      if line:match("DownloadRate") then data.download_rate = line:match("[0-9.]+") .. " bytes/s"
      elseif line:match("UploadRate") then data.upload_rate = line:match("[0-9.]+") .. " bytes/s"
      end
    else
      if line:match("^[0-9]+$") then
        if not data.cell_id:match("-") then data.pci = line
        else data.cell_id = line end
      elseif line:match("^B[0-9]+$") then data.band = line
      elseif line:match("^[0-9]{5,6}$") then data.mccmnc = line
      elseif line:match("^[0-5]$") then data.signal_icon = line
      else data.operator = line end
    end
  end
  luci.http.prepare_content("application/json")
  luci.http.write_json(data)
end