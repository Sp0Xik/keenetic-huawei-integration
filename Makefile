include $(TOPDIR)/rules.mk

PKG_NAME:=huawei-integration
PKG_VERSION:=1.0
PKG_RELEASE:=1

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/huawei-integration
  SECTION:=net
  CATEGORY:=Network
  TITLE:=Huawei LTE API Integration for Keenetic
  DEPENDS:=+curl +xmlstarlet +luci-base +uci
endef

define Package/huawei-integration/description
  Script to fetch signal and control Huawei LTE routers (B636, B535, B530, B320) via HiLink API, with GUI integration.
endef

define Build/Prepare
  mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Compile
  # No compilation needed for scripts
endef

define Package/huawei-integration/install
  $(INSTALL_DIR) $(1)/opt/bin
  $(INSTALL_BIN) ./files/huawei_signal.sh $(1)/opt/bin/huawei_signal
  $(INSTALL_DIR) $(1)/opt/etc/init.d
  $(INSTALL_BIN) ./files/S99huawei $(1)/opt/etc/init.d/S99huawei
  $(INSTALL_DIR) $(1)/opt/etc/config
  $(INSTALL_DATA) ./files/opt/etc/config/huawei $(1)/opt/etc/config/huawei
  $(INSTALL_DIR) $(1)/opt/lib/lua/luci/controller
  $(INSTALL_DATA) ./files/opt/lib/lua/luci/controller/huawei.lua $(1)/opt/lib/lua/luci/controller/huawei.lua
  $(INSTALL_DIR) $(1)/opt/lib/lua/luci/model/cbi
  $(INSTALL_DATA) ./files/opt/lib/lua/luci/model/cbi/huawei-signal.lua $(1)/opt/lib/lua/luci/model/cbi/huawei-signal.lua
  $(INSTALL_DIR) $(1)/opt/lib/lua/luci/view/huawei
  $(INSTALL_DATA) ./files/opt/lib/lua/luci/view/huawei/signal.htm $(1)/opt/lib/lua/luci/view/huawei/signal.htm
  $(INSTALL_DIR) $(1)/opt/www/ndms
  $(INSTALL_DATA) ./files/opt/www/ndms/huawei.css $(1)/opt/www/ndms/huawei.css
endef

$(eval $(call BuildPackage,huawei-integration))
