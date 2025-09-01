include $(TOPDIR)/rules.mk

PKG_NAME:=huawei-integration
PKG_VERSION:=1.0
PKG_RELEASE:=1

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/huawei-integration
  SECTION:=net
  CATEGORY:=Network
  TITLE:=Huawei Integration for Keenetic
  DEPENDS:=+luci-base +uci +lighttpd
endef

define Package/huawei-integration/description
  Integration of Huawei routers with Keenetic routers to display mobile network parameters.
endef

define Build/Compile
endef

define Package/huawei-integration/install
  $(INSTALL_DIR) $(1)/opt/bin
  $(INSTALL_BIN) ./files/huawei_signal.sh $(1)/opt/bin/huawei_signal
  $(INSTALL_DIR) $(1)/opt/etc/init.d
  $(INSTALL_BIN) ./files/S99huawei $(1)/opt/etc/init.d/
  $(INSTALL_DIR) $(1)/opt/etc/config
  $(INSTALL_CONF) ./files/opt/etc/config/huawei $(1)/opt/etc/config/
  $(INSTALL_DIR) $(1)/opt/lib/lua/luci/controller
  $(INSTALL_DATA) ./files/opt/lib/lua/luci/controller/huawei.lua $(1)/opt/lib/lua/luci/controller/
  $(INSTALL_DIR) $(1)/opt/lib/lua/luci/model/cbi
  $(INSTALL_DATA) ./files/opt/lib/lua/luci/model/cbi/huawei-signal.lua $(1)/opt/lib/lua/luci/model/cbi/
  $(INSTALL_DIR) $(1)/opt/lib/lua/luci/view/huawei
  $(INSTALL_DATA) ./files/opt/lib/lua/luci/view/huawei/signal.htm $(1)/opt/lib/lua/luci/view/huawei/
  $(INSTALL_DIR) $(1)/opt/www/ndms
  $(INSTALL_DATA) ./files/opt/www/ndms/huawei.css $(1)/opt/www/ndms/
endef

$(eval $(call BuildPackage,huawei-integration))
