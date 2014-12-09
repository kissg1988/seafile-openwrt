#
# Copyright (C) 2007-2014 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=seafile-server
PKG_VERSION:=3.1.7
PKG_RELEASE:=1
PKG_LICENSE:=GPL-3.0

PKG_BUILD_DIR:=$(BUILD_DIR)/seafile-$(PKG_VERSION)-server
PKG_SOURCE:=v$(PKG_VERSION)-server.tar.gz
PKG_SOURCE_URL:=https://github.com/haiwen/seafile/archive/
PKG_MD5SUM:=af35324998b6c98fe1442d5d775871ee
PKG_CAT:=zcat
PKG_FIXUP:=autoreconf
PKG_INSTALL:=1

include $(INCLUDE_DIR)/package.mk

define Package/seafile-server
    SECTION:=net
    CATEGORY:=Network
    TITLE:=Seafile server
    MAINTAINER:=Gergely Kiss <mail.gery@gmail.com>
    URL:=http://seafile.com/
    DEPENDS:=+shadow-useradd +libarchive +libopenssl +glib2 +seafile-ccnet +libsearpc \
		+jansson +libevent2 +libevent2-openssl +zlib +libzdb +libsqlite3 \
		+libpthread +libuuid +seafile-seahub +bash +sudo +libevhtp \
		+procps-pkill +procps
endef

define Package/seafile-server/description
   Open source cloud storage with advanced features on privacy protection and teamwork.
endef

CONFIGURE_ARGS += --disable-riak \
		    --disable-client \
		    --disable-fuse \
		    --enable-server \
		    --enable-python \
		    --disable-static-build \
		    --disable-server-pkg \
		    --disable-console

CONFIGURE_VARS += JANSSON_CFLAGS= \
		    JANSSON_LIBS=-ljansson

TARGET_CFLAGS += -I$(STAGING_DIR)/usr/lib/libiconv-stub/include
TARGET_LDFLAGS += -L$(STAGING_DIR)/usr/lib/libiconv-stub/lib -L$(STAGING_DIR)/usr/lib/mysql -lmysqlclient -lz

PKG_BUILD_DEPENDS:=vala/host \
		    libsearpc/host \
		    libiconv

Hooks/Prepare/Post += delete_source_package

define delete_source_package
	# deleting downloaded source package as its filename is ambiguous
	rm -f $(DL_DIR)/$(PKG_SOURCE)
endef

define Package/seafile-server/install
	$(INSTALL_DIR) $(1)/usr/{bin,lib}
	$(INSTALL_DIR) $(1)/usr/lib/python2.7/site-packages
	$(INSTALL_DIR) $(1)/usr/share/seafile/seafile-server/runtime
	$(INSTALL_DIR) $(1)/etc/init.d
	$(CP) $(PKG_INSTALL_DIR)/usr/bin/* $(1)/usr/bin/
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/python2.7/site-packages/seafile/ $(1)/usr/lib/python2.7/site-packages/
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/python2.7/site-packages/seaserv/ $(1)/usr/lib/python2.7/site-packages/
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libseafile.so* $(1)/usr/lib/
	$(CP) $(PKG_BUILD_DIR)/scripts/reset-admin.sh $(1)/usr/share/seafile/seafile-server/
	$(CP) $(PKG_BUILD_DIR)/scripts/seaf-gc.sh $(1)/usr/share/seafile/seafile-server/
	$(CP) $(PKG_BUILD_DIR)/scripts/upgrade/ $(1)/usr/share/seafile/seafile-server/
	$(INSTALL_BIN) ./files/seafile.init $(1)/etc/init.d/seafile
endef

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/include
	$(INSTALL_DIR) $(1)/usr/lib/pkgconfig
	$(CP) $(PKG_INSTALL_DIR)/usr/include/seafile/ $(1)/usr/include/
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/pkgconfig/libseafile.pc $(1)/usr/lib/pkgconfig/
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libseafile.so* $(1)/usr/lib/
endef

define Package/seafile-server/postinst
#!/bin/sh

if ! id -u seafile >/dev/null 2>&1; then
    useradd seafile -d "$$IPKG_INSTROOT/usr/share/seafile" -s /bin/sh; fi

# create pidfile directory
if [ ! -d "/var/run/seafile" ]; then
    mkdir -p /var/run/seafile; fi

chown -R seafile:seafile $$IPKG_INSTROOT/usr/share/seafile/ /var/run/seafile
chmod -R o-rwx $$IPKG_INSTROOT/usr/share/seafile/ /var/run/seafile

# create symlink for init script in case using non-default installation path
if [ ! -e /etc/init.d/seafile ]; then
    ln -s $$IPKG_INSTROOT/etc/init.d/seafile /etc/init.d/seafile; fi

sed -i "s#_IPKG_INSTROOT_#$$IPKG_INSTROOT#g" /etc/init.d/seafile
sed -i "s#_IPKG_INSTROOT_#$$IPKG_INSTROOT#g" $$IPKG_INSTROOT/usr/share/seafile/seafile-server/reset-admin.sh
sed -i "s#_IPKG_INSTROOT_#$$IPKG_INSTROOT#g" $$IPKG_INSTROOT/usr/share/seafile/seafile-server/seaf-gc.sh

if [ ! -d "$$IPKG_INSTROOT/usr/share/seafile/seafile-data" ]
then
   echo "*** Installation completed, running configuration script..."
   export -n IPKG_INSTROOT
   /etc/init.d/seafile setup

   if [ $$? -ne 0 ]
   then
      echo
      echo "*** ERROR: Configuration failed. Please fix the issues if any and re-run the script using the command below:"
      echo "*** \"/etc/init.d/seafile setup\""
   fi
echo
echo "*** NOTE: you need to create an admin account before using seafile."
echo "*** Please run \"/etc/init.d/seafile create_admin\" to do so."
fi

export -n IPKG_INSTROOT
/etc/init.d/seafile enable
/etc/init.d/seafile restart
endef

define Package/seafile-server/prerm
#!/bin/sh
/etc/init.d/seafile stop
if [ -e /etc/init.d/seafile ]; then
    rm -f /etc/init.d/seafile; fi
endef

$(eval $(call BuildPackage,seafile-server))
