# Python Flask on Unikraft

## Prerequisites
Make sure to have `kraft` installed and a project structure setup as follows:
```
.unikraft
├── apps
├── libs
└── unikraft
```

`cd` into the `apps` directory and clone this repository:
```
git clone https://github.com/FredrikBakken/app-flask.git
```

## Getting Started
Make sure to untar the `flask-fs.tar` file by running: `tar -xvf flask-fs.tar`. This should create a new directory named `fs0` with all the necessary Python files and modules.

Use `make menuconfig` to select the following configurations:
1. `Platform Configuration` &rarr; `KVM`
2. `Library Configuration`
    1. `Python 3`
        - `Provide main function`
        - `Extensions`
    2. `vfscore: Configuration`
        - `Automatically mount a root filesystem (/)`
            - `9PFS`

Before building the application, make sure that `unikraft` is in the `usoc` branch and that the dependencies are on the `staging` branch.

Build the application with `make`.

After a successful build, the next step is to configure the networking for the application. We do this by running the following:
```
sudo brctl addbr virbr0
sudo ip a a  172.44.0.1/24 dev virbr0
sudo ip l set dev virbr0 up
```

As soon as the network configuration is up and running, it is time to launch the application:
```
sudo qemu-system-x86_64 \
    -netdev bridge,id=en0,br=virbr0 \
    -fsdev local,id=myid,path=$(pwd)/fs0,security_model=none \
    -device virtio-net-pci,netdev=en0 \
    -device virtio-9p-pci,fsdev=myid,mount_tag=rootfs,disable-modern=on,disable-legacy=off \
    -kernel build/app-flask_kvm-x86_64 \
    -append "netdev.ipv4_addr=172.44.0.2 netdev.ipv4_gw_addr=172.44.0.1 netdev.ipv4_subnet_mask=255.255.255.0 -- app.py" \
    -enable-kvm \
    -m 1G \
    -nographic
```

You should now have a running instance of Python Flask within a Unikraft unikernel! Access your favorite browser and open the URL: http://172.44.0.2:5000/. If everything works as expected, you will be greeted by the following message:
```
Hello, World!
```

Make sure to remove the network configuration after the application has stopped:
```
sudo ip l set dev virbr0 down
sudo brctl delbr virbr0
```
