# Keenetic Huawei Integration

OPKG-пакет для интеграции роутеров Huawei (B636-336, B535-232a-LTE, B530-336, B320-323) с роутерами Keenetic (Hero 4G+, Skipper 4G, Explorer 4G, Runner 4G и другими с поддержкой OPKG/Entware). Позволяет получать данные о сигнале (RSSI, RSRP, SINR) и управлять модемом через HiLink API.

## Поддерживаемые модели
- Huawei: B636-336, B535-232a-LTE, B530-336, B320-323 (адаптировано для вариаций API).
- Keenetic: Все модели на KeeneticOS 3.7+ с OPKG/Entware (KN-2311, KN-2910, KN-4910, KN-2212 и т.д.).

## Установка
1. Установите OPKG и Entware на Keenetic (в веб-интерфейсе: Настройки → Компоненты → Open Package support; затем Entware на USB).
2. Соберите пакет с помощью OpenWRT/Keenetic SDK (см. инструкции ниже).
3. Установите: `opkg install /path/to/huawei-integration_1.0-1_mipsel.ipk`.
4. Настройте IP Huawei в скрипте (по умолчанию 192.168.8.1).

## Использование
- Получить сигнал: `/opt/bin/huawei_signal signal [MODEL]` (MODEL: B636, B535, B530, B320).
- Статус: `/opt/bin/huawei_signal status`.
- Перезагрузка: `/opt/bin/huawei_signal reboot`.
- Автозапуск: Логирует сигнал в /var/log/huawei_signal.log при старте.

## Сборка пакета
1. Установите Keenetic SDK с GitHub[](https://github.com/keenetic/keenetic-sdk).
2. Поместите этот репозиторий в `package/` SDK.
3. Выполните: `make package/huawei-integration/compile V=s`.
4. Получите .ipk в bin/packages.

## Адаптация
- Для новых моделей Huawei добавьте case в huawei_signal.sh.
- Тестируйте API с curl на ПК.

## Лицензия
MIT
