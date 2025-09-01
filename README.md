Keenetic Huawei Integration
OPKG-пакет для интеграции роутеров Huawei (B636-336, B535-232a-LTE, B530-336, B320-323) с роутерами Keenetic (Hero 4G+, Skipper 4G, Explorer 4G, Runner 4G) через Entware. Отображает все параметры мобильного подключения (RSRP, SINR, RSRQ, RSSI, Cell ID, PCI, Band, трафик и др.) через HiLink API в веб-интерфейсе Keenetic, с дизайном, идентичным встроенному 4G-модему. Модель определяется автоматически, логин/пароль вводятся через GUI.
Поддерживаемые модели

Huawei: B636-336, B535-232a-LTE, B530-336, B320-323.
Keenetic: Все модели на KeeneticOS 3.7+ с OPKG/Entware (KN-2311, KN-2910, KN-4910, KN-2212).

Установка

Включите OPKG: "Настройки" → "Компоненты" → "Open Package support".
Установите Entware на USB (EXT4/NTFS): opkg update && opkg install entware-opt.
Соберите пакет с Keenetic SDK (см. ниже).
Установите: opkg install /path/to/huawei-integration_1.0-1_mipsel.ipk.
Перезагрузите роутер или веб-сервер: /etc/init.d/lighttpd restart.
В "Сеть" → "Huawei Integration" введите IP, логин и пароль Huawei.

Использование

CLI:
/opt/bin/huawei_signal signal — все параметры сигнала.
/opt/bin/huawei_signal status — статус соединения.
/opt/bin/huawei_signal reboot — перезагрузка модема.


GUI: В "Сеть" → "Huawei Integration" введите логин/пароль, смотрите параметры (RSRP, SINR, RSRQ, RSSI, Cell ID, Band, трафик и др.) и управляйте модемом.
Автозапуск: Логирует сигнал в /var/log/huawei_signal.log.

Сборка пакета

Установите Keenetic SDK: git clone https://github.com/keenetic/keenetic-sdk.
Поместите репозиторий в package/ SDK.
Выполните: make package/huawei-integration/compile V=s.
Найдите .ipk в bin/packages.

Адаптация

Для новых моделей Huawei добавьте case в huawei_signal.sh.
Для кастомизации GUI измените /opt/lib/lua/luci/view/huawei/signal.htm или /opt/www/ndms/huawei.css.
Тестируйте API: curl -s http://192.168.8.1/api/device/information -u admin:admin.

Лицензия
MIT
