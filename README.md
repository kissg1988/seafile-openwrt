
What's this?
------------

This is a work-in-progress porting attempt of <a href="http://seafile.com/">Seafile</a> to <a href="http://openwrt.org/">OpenWRT</a>.

Why was it created?
-------------------

This project was created to be able to run Seafile on openwrt-based devices (routers primarily). Some routers and other openwrt-compatible consumer devices are now fast enough and have enough memory to host a seafile server to conveniently store your files at a central location, your home. This way you can enjoy the benefits of cloud storage while keeping (physical) control over your data and privacy. Also, having the possibility to run Seafile on your router eliminates the need to run a server machine all the time in your home.

IMPORTANT: You need about 100 MB of non-volatile storage to install the packages built. It's advised to set up an <a href="http://wiki.openwrt.org/doc/howto/extroot">extroot</a> configuration using a USB stick or a portable hard disk to have enough free disk space.

WARNING: seahub, the web interface of seafile consumes a lot of memory. Make sure your router has at least 128 MB of RAM and some additional swap space before installing and starting seafile.

How to use
----------

* Checkout all the files from here to a directory of your choice
* Within openwrt's buildroot, open the file feeds.conf.default in an editor
* Append the line to the file:

<code>src-link seafile [path-to-this-projects-files]</code>

* Update the list of available feeds:

<code>./scripts/feeds update seafile</code>

* Run make menuconfig and configure the environment as per your needs (make sure to select your platform):

<code>make menuconfig</code>

* Start building a default image of openwrt (will take a lot of time, optimize with make's -j option to use multiple CPU cores simultaneously):

<code>make defconfig && make</code>

* Install the packages to the menuconfig interface and mark them to be compiled as modules:

<code>./scripts/feeds install -a -p seafile -d m</code>

* Start compiling the packages:

<code>make package/seafile-server/{clean,compile} V=s</code>

* Once done, you'll find the packages generated in "./bin/[platform]/packages/seafile" ready to be installed on your router.

Known bugs
----------

* the jansson package needs to be patched (included) as the current version does not install the .pc file (pkg-config) by default required by the build process
* the fileserver component cannot accept file uploads, CORS is not working as expected (400 Bad request returned instead of 200 OK, needs debugging)
* compiling with <a href="http://wiki.openwrt.org/doc/devel/gdb">debug capabilities</a> fails for packages depending on libpthread for an unknown reason
* building the packages with "make -j" sometimes fails, rebuilding without the "-j" switch solves the problem
