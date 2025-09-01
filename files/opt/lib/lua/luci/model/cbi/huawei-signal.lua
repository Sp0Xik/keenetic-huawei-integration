local os = require "os"
local io = require "io"
local uci = require "luci.model.uci".cursor()

m = Map("huawei", "Huawei LTE Integration", "Monitor signal and control Huawei modem (auto-detected model).")

-- Секция конфигурации
s = m:section(NamedSection, "config", "huawei", "Huawei Modem Settings")
s.anonymous = true

ip = s:option(Value, "ip", "Huawei IP Address")
ip.datatype = "ipaddr"
ip.default = "192.168.8.1"

username = s:option(Value, "username", "Username")
username.default = "admin"

password = s:option(Value, "password", "Password")
password.password = true
password.default = "admin"

-- Секция данных сигнала
s2 = m:section(NamedSection, "signal", "huawei", "Signal Data")
s2.anonymous = true

val = s2:option(DummyValue, "_signal", "Signal Parameters")
val.rawhtml = true
val.value = "<div id='signal-placeholder'>Loading...</div>"

status_btn = s2:option(Button, "_status", "Connection Status")
status_btn.inputtitle = "Show Status"
status_btn.inputstyle = "apply"
function status_btn.write(self, section)
  local status = io.popen("/opt/bin/huawei_signal status"):read("*a")
  luci.http.redirect(luci.dispatcher.build_url("admin/network/huawei/signal") .. "?status=" .. status)
end

reboot_btn = s2:option(Button, "_reboot", "Reboot Modem")
reboot_btn.inputtitle = "Reboot"
reboot_btn.inputstyle = "reset"
function reboot_btn.write(self, section)
  os.execute("/opt/bin/huawei_signal reboot")
  luci.http.redirect(luci.dispatcher.build_url("admin/network/huawei/signal"))
end

return m
