
What's this?
------------

This is a work-in-progress porting attempt of <a href="http://seafile.com/">Seafile</a> to <a href="http://openwrt.org/">OpenWRT</a>.

Why was it created?
-------------------

This project was created to be able to run Seafile on OpenWRT-based devices (routers primarily). Some routers and other OpenWRT-compatible consumer devices are now fast enough and have enough memory to host a Seafile server. This makes it possible to conveniently store your personal files at a central location, just like in the cloud, but hosted in your own home. This makes it possible to enjoy the benefits of cloud storage while keeping (physical) control over your data and retain your privacy. Also, having the possibility to run Seafile on your router eliminates the need to run a server machine in your home.

Requirements
------------

* You need to have about 100 MB of non-volatile storage on your router to install the packages. It's advised to set up an <a href="http://wiki.openwrt.org/doc/howto/extroot">extroot</a> configuration using a USB stick or a portable hard disk.

* Seahub, the web interface of Seafile consumes a lot of memory. Make sure your router has at least 128 MB of RAM and some additional swap space before installing and starting Seafile server.

How to use
----------

* Checkout all the files from here to a directory of your choice
* Within OpenWRT's buildroot, open the file feeds.conf.default in an editor
* Append the line to the file:

<code>src-link seafile [path-to-checked-out-files]</code>

* Update feed information:

<code>./scripts/feeds update seafile</code>

* Run make menuconfig and configure the environment as per your needs (make sure to select the correct platform for your router model):

<code>make menuconfig</code>

* Start building a default image of OpenWRT (will take a lot of time, you can optimize the build process using make's '-j' option to use multiple CPU cores simultaneously, eg. 'make -j 5' for a quad-core machine):

<code>make defconfig && make</code>

* Install the packages to the menuconfig interface and mark them to be compiled as modules:

<code>./scripts/feeds install -a -p seafile -d m</code>

* Start compiling the packages:

<code>make package/seafile-server/{clean,compile} V=s</code>

* Once done, you'll find the packages generated in './bin/[platform]/packages/seafile' ready to be installed on your router.

NOTE: you'll need to copy the packages to a directory accessible by your router and also, need to generate package index.

To make opkg aware of your custom package repository, set the line in /etc/opkg.conf (replace '/mnt/packages/seafile' with the directory containing the packages):

<code>src/gz seafile file:///mnt/packages/seafile</code>

* Should you want to install the packages to an external location other than the / [root] directory, issue the following commands on your router (substitute '-d ext' with the name of the root directory of your choice and set IPKG_INSTROOT to the destination directory):

<code>opkg install libfuse shadow-useradd bash libncurses sudo procps-pkill
<code>IPKG_INSTROOT=/mnt/extroot opkg -d ext install seafile-server</code>

Known bugs
----------

* The jansson package needs to be patched (included) as the current version does not install the .pc file (pkg-config) by default
* The fileserver daemon cannot accept file uploads, CORS is not working as expected (400 Bad request returned instead of 200 OK, needs debugging)
* Building the packages with "make -j" sometimes fails, rebuilding without the "-j" switch solves the problem
