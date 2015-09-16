# tlaloc
Generating OpenBSD images using resflash.

## Preparing an OpenBSD system to create the resflash images

* Install the a OpenBSD system using the architecture you would like to be the image for.

* To have sufficient space for the tlaloc/resflash scripts to build the image on the hard drive as root we are redirecting the roots home directory.
```sh
su
cp -Rp /root /home/
mv /root /root.bak
ln -s /home/root /root
```
**IMPORTANT**: It is recommended to have at least 50 GB free disk space to build the image.

## Building the resflash image and file system files

* Get the tlaloc project repository, change to the project directory and start the default build.
```
cd ~
git clone https://github.com/xoro/tlaloc.git
cd tlaloc
tlaloc.sh
```
The created image and file system files can be found in the image directory within the tlaloc project directory.

## Putting the image on a hard diskflashimg.amd64-date

* The simples way to put the image onto a hard disk is using the dd command on UNIX systems.

  * OpenBSD:

    ```
    dd if=resflash-amd64-com0-115200-20150720_0257.img of=/dev/rsd3c bs=1m
    ```

  * FreeBSD:

    ```
    dd if=resflash-amd64-com0-115200-20150720_0257.img of=/dev/ada1 bs=1m
    ```

  * Mac OSX:

    ```
    dd if=resflash-amd64-com0-115200-20150720_0257.img of=/dev/disk1 bs=1m
    ```

  * Linux:

    ```
    dd if=resflash-amd64-com0-115200-20150720_0257.img of=/dev/sda0 bs=1M
    ```

## Converting the resflash image to a Virtualbox vdi image file

* Copy the resflash image to system that contains an installed version of Virtualbox and execute the following statement on the command line:

```
VBoxManage convertfromraw resflash-amd64-com0-115200-20150720_0257.img resflash-amd64-com0-115200-20150720_0257.vdi --format vdi
```

## Starting the reflash image im qemu

It is possible start the resflash build image in qemu under OpenBSD. Therefore you have to install qemu on Openbsd using the following command:

```
pkg_add qemu
```

Then you can start the reflash image from within the tlaloc directory using this command:

```
qemu-system-x86_64 -nographic resflash-amd64-com0-115200-20150720_0257.img
```

If you created the resflash image using a different architecture than x86_64 just use the appropriate qemu-* executable.
