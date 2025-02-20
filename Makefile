# 
# Copyright (C) 2006-2014 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=tgwireguard
PKG_VERSION=2.0.9
PKG_RELEASE:=0

include $(INCLUDE_DIR)/package.mk

define Package/tgwireguard
SECTION:=luci
CATEGORY:=LuCI
SUBMENU:=7. TorGuard
TITLE:= LuCI config tools for torguard wireguard client
PKGARCH:=all
DEPENDS:=kmod-wireguard wireguard-tools
endef

define Package/tgwireguard/description
	This package contains LuCI configuration for Wireguard, provided by TorGuard.
endef

define Package/tgwireguard/conffiles
/etc/config/tgwireguard_cfg
endef

define Build/Prepare
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/tgwireguard/install

	$(INSTALL_DIR)  $(1)/etc/uci-defaults
	$(INSTALL_BIN)  ./files/etc/uci-defaults/tgwireguard_def $(1)/etc/uci-defaults/tgwireguard_def

	$(INSTALL_DIR)  $(1)/etc/config
	$(INSTALL_DIR)  $(1)/etc/init.d
	$(INSTALL_DIR)  $(1)/usr/lib/lua/luci/model/cbi/torguard
	$(INSTALL_DIR)  $(1)/usr/lib/lua/luci/controller/admin

	$(INSTALL_CONF) ./files/etc/config/tgwireguard_cfg $(1)/etc/config/tgwireguard_cfg
	$(INSTALL_BIN)  ./files/etc/init.d/tgwireguard $(1)/etc/init.d/tgwireguard
	$(INSTALL_DATA) ./files/usr/lib/lua/luci/model/cbi/torguard/tgwireguard.lua $(1)/usr/lib/lua/luci/model/cbi/torguard/tgwireguard.lua
	$(INSTALL_DATA) ./files/usr/lib/lua/luci/controller/admin/tgwireguard.lua $(1)/usr/lib/lua/luci/controller/admin/tgwireguard.lua

endef

$(eval $(call BuildPackage,$(PKG_NAME)))