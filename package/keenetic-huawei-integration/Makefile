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
  DEPENDS:=+lighttpd
  MAINTAINER:=Sp0Xik <sp0xik@example.com>
  PKGARCH:=all
endef

define Package/keenetic-huawei-integration/description
  A package to integrate Huawei routers (B636-336, B535-232a-LTE, B530-336, B320-323)
  with Keenetic routers (Hero 4G+, Skipper 4G, Explorer 4G, Runner 4G) to display
  mobile network parameters and manage connections via GUI.
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
	$(CP) ./src/* $(PKG_BUILD_DIR)/
endef

define Build/Configure
endef

define Build/Compile
	$(TARGET_CROSS)gcc -o $(PKG_BUILD_DIR)/huawei_signal $(PKG_BUILD_DIR)/huawei_signal.c -I$(STAGING_DIR)/usr/include -L$(STAGING_DIR)/usr/lib
endef

define Package/keenetic-huawei-integration/install
	$(INSTALL_DIR) $(1)/opt/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/huawei_signal $(1)/opt/bin/
	$(INSTALL_DIR) $(1)/opt/lib/lua/luci/controller
	$(INSTALL_DIR) $(1)/opt/lib/lua/luci/model/cbi
	$(INSTALL_DIR) $(1)/opt/lib/lua/luci/view/huawei
	$(INSTALL_DIR) $(1)/opt/etc/config
	$(INSTALL_DIR) $(1)/opt/etc/lighttpd/conf.d
	$(CP) ./files/opt/lib/lua/luci/controller/huawei.lua $(1)/opt/lib/lua/luci/controller/
	$(CP) ./files/opt/lib/lua/luci/model/cbi/huawei-signal.lua $(1)/opt/lib/lua/luci/model/cbi/
	$(CP) ./files/opt/lib/lua/luci/view/huawei/signal.htm $(1)/opt/lib/lua/luci/view/huawei/
	$(CP) ./files/opt/etc/config/huawei $(1)/opt/etc/config/
	$(CP) ./files/opt/etc/lighttpd/conf.d/99-huawei.conf $(1)/opt/etc/lighttpd/conf.d/
endef

$(eval $(call BuildPackage,keenetic-huawei-integration))
