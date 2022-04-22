# How to make bootable image with only golang binary

## Pre-install

Some things needed for building & running stuff

`apt-get install bison flex nasm qemu-system-x86_64 libelf-dev bc`

## Nasm simple example

Standart boot sector is 512 bytes that should end with 0xaa55 bytes.

Ive created simple Nasm script that print "Hello Wolrd!" on boot.

Compile Boot binary:

`nasm -f bin boot.nasm -o boot.bin`

Run it with emulator

`qemu-system-x86_64 boot.bin`

## Run go binary on Linux Kernel

First we need to download ltest stable linux Kernel

`curl https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.17.4.tar.xz | tar Jx`

Then we need to configure it and select all things that we need. Thats kind of hard, because there are tons of settings.
Ive made some default config in root/.config that u can copy to linux-5.17.4 folder to use.

If you want to build your own config use: `make menuconfig`

Compile kernel (it will take a while)

`cd linux-5.17.4 && make -j4`

Now lets run image with our kernel to see if it works 

`qemu-system-x86_64 -serial stdio -kernel linux-5.17.4/arch/x86/boot/bzImage`

We got error saying that we didnt mount a disk - it ok, cause we really didnt do it.

Now we need mount disk and add our binary, libs etc on it. We will use initramfs for that, basically put evrything into the RAM.

For that we need to build our go binary with static linking and create gzip archive with our ram mount(basicaly only our binary)

`./build-ramfs.sh`

Now we can run it as before just add our ram mount

`qemu-system-x86_64 -serial stdio -kernel linux-5.17.4/arch/x86/boot/bzImage -initrd go-ram.cpio.gz`


## Creating some mini-linux image.

Of course we can create our custom linux. For example we can use Buxybox image for that

```
curl https://busybox.net/downloads/busybox-1.34.1.tar.bz2 | tar Jz
cd busybox-1.33.2
make menuconfig 
make -j4
make install
cd ..
```

Now let's fill our image

```
mkdir -p bbram/{bin,sbin,etc,proc,sys,usr/bin,usr/sbin}
cp -a busybox-1.34.1/_install/* bbram/
```

Let's create wellcome init script

```
cp init bbram/bin/init
chmod +x bbram/bin/init
```

Create ram archive 
```
cd bbram
find . -print0 | cpio --null -ov --format=newc | gzip -9 > ../bbram.cpio.gz
cd ../
```

Run it

`qemu-system-x86_64 -kernel linux-5.17.4/arch/x86/boot/bzImage -initrd bbram.cpio.gz -m1024`

