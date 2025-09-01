Keenetic Huawei Integration
OPKG-пакет для интеграции роутеров Huawei (B636-336, B535-232a-LTE, B530-336, B320-323) с роутерами Keenetic (Hero 4G+, Skipper 4G, Explorer 4G, Runner 4G) через Entware. Отображает все параметры мобильного подключения (RSRP, SINR, RSRQ, RSSI, Cell ID, PCI, Band, Bandwidth, Operator, MCC/MNC, Signal Level, Download/Upload Rate) через HiLink API в веб-интерфейсе Keenetic, с дизайном, идентичным встроенному 4G-модему. Модель определяется автоматически, логин/пароль вводятся через GUI.
Поддерживаемые модели

Huawei: B636-336, B535-232a-LTE, B530-336, B320-323.
Keenetic: Все модели на KeeneticOS 3.7+ с OPKG/Entware (KN-2311, KN-2910, KN-4910, KN-2212).

Скачивание готового пакета

Перейдите в Releases.
Скачайте последний файл huawei-integration_1.0-1_mipsel.ipk из раздела "Assets".
Скопируйте .ipk на USB-накопитель или в /tmp на роутере Keenetic.

Установка

Подключите USB-накопитель (EXT4/NTFS) к Keenetic.
Включите OPKG в веб-интерфейсе (my.keenetic.net):
"Настройки" → "Компоненты" → "Open Package support" → "Применить".


Установите Entware и зависимости через SSH:opkg update
opkg install entware-opt luci-base uci lighttpd


Убедитесь, что Huawei в bridge-режиме и доступен по IP (по умолчанию 192.168.8.1). Если заблокирован оператором, разблокируйте модем.
Установите пакет:/opt/bin/opkg install /tmp/huawei-integration_1.0-1_mipsel.ipk

Или, если .ipk на USB:/opt/bin/opkg install /mnt/<usb>/huawei-integration_1.0-1_mipsel.ipk


Перезагрузите веб-сервер:/etc/init.d/lighttpd restart

Или роутер:reboot



Использование

GUI:
Откройте веб-интерфейс (my.keenetic.net).
Перейдите в "Сеть" → "Huawei Integration".
Введите IP (обычно 192.168.8.1), логин и пароль Huawei (по умолчанию admin/admin).
Нажмите "Сохранить".
Просмотрите параметры (RSRP, SINR, RSRQ, RSSI, Cell ID, Band, трафик и др.) в таблице, обновляемой каждые 5 секунд.
Используйте кнопки "Show Status" и "Reboot" для управления модемом.


CLI:
/opt/bin/huawei_signal signal — все параметры сигнала.
/opt/bin/huawei_signal status — статус соединения.
/opt/bin/huawei_signal reboot — перезагрузка модема.


Логи: Проверяйте ошибки в /var/log/huawei_signal.log.

Сборка из исходников (опционально)

Установите Keenetic SDK:git clone https://github.com/keenetic/keenetic-sdk


Поместите репозиторий в package/:git clone https://github.com/Sp0Xik/keenetic-huawei-integration keenetic-sdk/package/keenetic-huawei-integration


Выполните:cd keenetic-sdk
make package/huawei-integration/compile V=s


Найдите .ipk в bin/packages/mipsel/.

Адаптация

Для новых моделей Huawei добавьте case в files/huawei_signal.sh.
Для кастомизации GUI измените /opt/lib/lua/luci/view/huawei/signal.htm или /opt/www/ndms/huawei.css.
Тестируйте API:curl -s http://192.168.8.1/api/device/information -u admin:admin



Отладка

Если в GUI ошибка "Failed to connect to Huawei modem", проверьте IP, логин, пароль.
Если параметры не отображаются, смотрите /var/log/huawei_signal.log.
Для Runner 4G (KN-2212) используйте USB для Entware (32 MB flash).

Лицензия
MIT
