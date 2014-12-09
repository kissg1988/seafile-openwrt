
What's this?
------------

This is a port of <a href="http://seafile.com/">Seafile</a> to <a href="http://openwrt.org/">OpenWRT</a>'s current stable release (Barrier Breaker).

NOTE: Packages in this repository are for Barrier Breaker only. Package sources to be used with the development branch are currently <a href="https://github.com/kissg1988/packages">in a fork</a> until they get pulled into master. 

Why was it created?
-------------------

This project was created to be able to run Seafile on OpenWRT-based devices (routers primarily). Some routers and other OpenWRT-compatible consumer devices are now fast enough and have enough memory to host a Seafile server. This makes it possible to conveniently store your personal files at a central location, just like in the cloud, but hosted in your own home. This makes it possible to enjoy the benefits of cloud storage while keeping (physical) control over your data and retain your privacy. Also, having the possibility to run Seafile on your router eliminates the need to run a server machine in your home.

What's the status of the port?
------------------------------

It can be considered as completed now (see "Known issues"), although it might need some long-run stability testing and maybe some performance optimization.

Requirements
------------

* You need to have about 100 MB of non-volatile storage on your router to install the packages. It's advised to set up an <a href="http://wiki.openwrt.org/doc/howto/extroot">extroot</a> configuration using a USB stick or a portable hard disk.

* Seahub, the web interface of Seafile consumes a lot of memory. Make sure your router has at least 128 MB of RAM and some additional swap space (optional but highly recommended) before installing and starting Seafile server.

How to use
----------

* Checkout all the files from here to a directory of your choice
* Checkout and initialize the buildroot of the Barrier Breaker branch of OpenWRT as per the instructions on the <a href="http://wiki.openwrt.org/doc/howto/build">OpenWrt Buildroot – Usage</a> page. Use the link "git://git.openwrt.org/14.07/openwrt.git" to fetch the appropriate buildroot from Git.
* Within OpenWRT's buildroot, open the file feeds.conf.default in an editor
* Append the line to the file:

<code>src-link seafile [path-to-checked-out-files]</code>

* Update feed information:

<code>./scripts/feeds update seafile</code>

* Run make menuconfig and configure the environment as per your needs (make sure to select the correct platform for your router model!):

<code>make menuconfig</code>

* Start building a default image of OpenWRT. This will take a lot of time, you can optimize the build process using make's '-j' option to use multiple CPU cores simultaneously, eg. 'make -j 5' for a quad-core machine.

<code>make defconfig && make</code>

* Install the packages to the menuconfig interface:

<code>./scripts/feeds install -a -p seafile</code>

* Run <code>make menuconfig</code> and select <code>Network -> seafile-server</code> to be built as a package ('M' marker). This will also make all the required dependencies compiled.

* Finally, start the packaging process:

<code>make package/seafile-server/{clean,compile}</code>

* Once done, you'll find the packages in './bin/(platform)/packages/seafile' ready to be installed on your router.

Installation
------------

To install or update the packages, you need to copy the package files to a directory accessible by your router along with a package index file. To do so, copy the script 'deploy-to-router.sh' to the directory holding the generated packages and set your router's IP address along with the local path on the router that should hold the repository's files (scp parameters). Once done, run the script to have the files copied to the router.

To make opkg aware of your custom package repository, append the lines below to /etc/opkg.conf on your router (change paths as appropriate):

<code>dest ext /mnt/sda1/extroot</code>

<code>src/gz seafile file:///mnt/sda1/packages/seafile</code>

If you want to install the packages to an external location other than the / (root) directory, issue the following commands on your router (set the value of IPKG_INSTROOT so that it points to the desired destination directory):

<code>opkg install shadow-useradd bash libncurses sudo procps procps-pkill</code>

<code>IPKG_INSTROOT=/mnt/sda1/extroot opkg -d ext install seafile-server</code>

IMPORTANT: packages listed in the first command must be installed to root, otherwise they won't function correctly!

Known issues
------------

* <del>The fileserver daemon does not accept file uploads from Seahub because CORS is not working as expected (400 Bad request returned instead of 200 OK)</del> FIXED
* Building the packages with "make -j" sometimes fails - restarting the build or removing the "-j" switch solves the problem (this is more like a phenomenon than an actual problem)
* Seahub is pretty slow - some additional optimizations might be needed if possible
