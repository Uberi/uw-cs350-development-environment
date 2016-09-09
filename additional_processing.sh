DIR=/root
cd $DIR/cs350-os161/os161-1.99
./configure --ostree=$DIR/cs350-os161/root --toolprefix=cs350-
cd kern/conf
./config ASST0
cd ../compile/ASST0
bmake depend
bmake
bmake install
cd $DIR/cs350-os161/os161-1.99 && bmake && bmake install

mkdir --parents /root/cs350-os161/root
cp /root/sys161/share/examples/sys161/sys161.conf.sample /root/cs350-os161/root/sys161.conf

