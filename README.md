Keenetic Huawei Integration
Этот проект предоставляет OPKG-пакет для роутеров Keenetic (Hero 4G+ KN-2311, Skipper 4G KN-2910, Explorer 4G KN-4910, Runner 4G KN-2212) для интеграции с роутерами Huawei (B636-336, B535-232a-LTE, B530-336, B320-323). Пакет отображает параметры мобильного подключения (RSRP, SINR, RSRQ, RSSI, Cell ID, PCI, Band, Bandwidth, Operator, MCC/MNC, Signal Level, Download/Upload Rate) в GUI KeeneticOS с формой логина/пароля.
Скачивание готового пакета

Перейдите в Releases.
Скачайте последний файл huawei-integration_1.0-1_mipsel.ipk из раздела "Assets".
Скопируйте .ipk на USB-накопитель или в /tmp на роутере Keenetic.

Установка

Подключите USB-накопитель (EXT4/NTFS) к Keenetic.
Включите OPKG в веб-интерфейсе (my.keenetic.net → "Настройки" → "Компоненты" → "Open Package support").
Установите зависимости через SSH:opkg update
opkg install entware-opt lighttpd


Убедитесь, что Huawei в bridge-режиме и доступен по IP (по умолчанию 192.168.8.1).
Установите пакет:/opt/bin/opkg install /tmp/huawei-integration_1.0-1_mipsel.ipk


Перезагрузите веб-сервер:/etc/init.d/lighttpd restart



Использование

Откройте веб-интерфейс Keenetic (my.keenetic.net) и перейдите в "Сеть" → "Huawei Integration".
Введите IP-адрес роутера Huawei (например, 192.168.8.1), имя пользователя и пароль (по умолчанию admin/admin).
Проверьте отображение параметров (RSRP, SINR, RSRQ, RSSI, Cell ID, PCI, Band, Bandwidth, Operator, MCC/MNC, Signal Level, Download/Upload Rate).
Используйте кнопки "Show Status" для получения статуса и "Reboot" для перезагрузки модема.
Для CLI используйте команды:/opt/bin/huawei_signal signal
/opt/bin/huawei_signal status
/opt/bin/huawei_signal reboot

Логи хранятся в /var/log/huawei_signal.log.

Сообщение об ошибках
Если возникли проблемы, создайте issue на GitHub Issues. Укажите модель Keenetic, Huawei, версию KeeneticOS и описание ошибки.
