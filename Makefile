include $(TOPDIR)/rules.mk

PKG_NAME:=keenetic-huawei-integration
PKG_VERSION:=1.0
PKG_RELEASE:=1

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/keenetic-huawei-integration
  SECTION:=net
  CATEGORY:=Network
  TITLE:=Huawei Integration for Keenetic
  DEPENDS:=+lighttpd +uci +luci-base
  MAINTAINER:=Sp0Xik
endef

define Package/keenetic-huawei-integration/description
  Huawei Integration package for Keenetic routers to display mobile connection parameters and manage Huawei routers.
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
	$(CP) ./files/* $(PKG_BUILD_DIR)/
endef

define Package/keenetic-huawei-integration/install
	$(INSTALL_DIR) $(1)/opt/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/huawei_signal $(1)/opt/bin/
	$(INSTALL_DIR) $(1)/opt/lib/lua/luci/controller
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/huawei.lua $(1)/opt/lib/lua/luci/controller/
	$(INSTALL_DIR) $(1)/opt/lib/lua/luci/model/cbi
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/huawei-signal.lua $(1)/opt/lib/lua/luci/model/cbi/
	$(INSTALL_DIR) $(1)/opt/lib/lua/luci/view/huawei
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/signal.htm $(1)/opt/lib/lua/luci/view/huawei/
	$(INSTALL_DIR) $(1)/opt/etc/config
	$(INSTALL_CONF) $(PKG_BUILD_DIR)/huawei $(1)/opt/etc/config/
endef

$(eval $(call BuildPackage,keenetic-huawei-integration))
