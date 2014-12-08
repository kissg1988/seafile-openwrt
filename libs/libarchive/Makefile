#
# Copyright (C) 2007-2014 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=libarchive
PKG_VERSION:=3.1.2
PKG_RELEASE:=1
PKG_LICENSE:=BSD-2-Clause

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=http://www.libarchive.org/downloads/
PKG_MD5SUM:=efad5a503f66329bb9d2f4308b5de98a
PKG_CAT:=zcat
PKG_INSTALL:=1

include $(INCLUDE_DIR)/package.mk

define Package/libarchive
    SECTION:=libs
    CATEGORY:=Libraries
    TITLE:=Multi-format archive and compression library 
    MAINTAINER:=Gergely Kiss <mail.gery@gmail.com>
    URL:=http://www.libarchive.org/
    DEPENDS:=+libattr +libbz2 +libexpat +liblzo +libnettle +zlib
endef

define Package/libarchive/description
   Multi-format archive and compression library.
endef

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/include
	$(INSTALL_DIR) $(1)/usr/lib/pkgconfig
	$(CP) $(PKG_INSTALL_DIR)/usr/include/archive* $(1)/usr/include/
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libarchive.so* $(1)/usr/lib/
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/pkgconfig/libarchive.pc $(1)/usr/lib/pkgconfig/
endef

define Package/libarchive/install
	$(INSTALL_DIR) $(1)/usr/{bin,lib}
	$(CP) $(PKG_INSTALL_DIR)/usr/bin/* $(1)/usr/bin/
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libarchive.so* $(1)/usr/lib/
endef

$(eval $(call BuildPackage,libarchive))
