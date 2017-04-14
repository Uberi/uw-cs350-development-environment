CS350 OS/161 Setup
==================

[Docker](https://www.docker.com/) container for the [OS/161](http://os161.eecs.harvard.edu/) setup used in [CS350 at the University of Waterloo](https://www.student.cs.uwaterloo.ca/~cs350/). This setup is current as of the Winter 2017 term.

Set up an isolated, fully functional CS350 development environment with one command!

Quickstart on Debian/Ubuntu: download `install.sh`, then run `sudo bash install.sh`.

Rationale
---------

CS350 (Operating Systems) is a course at the University of Waterloo. In this course, to do the assignments, you need to either set up OS/161 locally, or use the student environment.

I prefer being able to do my work without requiring a network connection. However, the installation process requires several configuration changes that can potentially break other parts of your system.

This Docker container contains a fully set up development environment for CS350 coursework, avoiding issues such as GCC versions, ncurses compatibility, and having to manually copy and paste commands around.

Usage
-----

You do not need to clone or download this repository.

If you're on Debian/Ubuntu, download [install.sh](https://github.com/Uberi/uw-cs350-development-environment/blob/master/start-interactive-cs350-shell.sh), then run `bash install.sh` in a convenient folder.

If you are not on Debian/Ubuntu:

1. Make sure you have Docker - refer to the [official Docker installation instructions](https://docs.docker.com/engine/installation/) for details.
2. Download and extract the [CS350 OS/161 archive](http://www.student.cs.uwaterloo.ca/~cs350/os161_repository/os161.tar.gz) into a convenient folder. This will be where you can work on the OS/161 code in here.
3. Download [start-interactive-cs350-shell.sh](https://github.com/Uberi/uw-cs350-development-environment/blob/master/start-interactive-cs350-shell.sh) and [build-and-run-kernel.sh](wget https://github.com/Uberi/uw-cs350-development-environment/blob/master/build-and-run-kernel.sh) to the same folder (this folder should now contain a folder named `os161-1.99`).
4. Run `bash start-interactive-cs350-shell.sh` to open a shell inside a Docker environment with everything set up. If this is the first run, this might take a while to start while Docker downloads the image from Docker Hub.

Now you can do your assignments by editing files in `os161-1.99` (this can be done outside of the Docker container, if you prefer).

Whenever you need to test/run/debug, run `bash build-and-run-kernel.sh` inside the Docker environment to build (or fully rebuild) the kernel, start SYS/161 and GDB, and open both of them side by side in a TMux session. With the emulator and debugger on screen at the same time, debugging is made a lot easier.

Building
--------

This section contains instructions for building the Docker image from scratch. You probably don't need to do this unless you're making your own image based on this one. If you just want to do your assignments in the development environment, refer to the "Usage" section above.

First, make sure you have Docker - refer to the [official Docker installation instructions](https://docs.docker.com/engine/installation/) for details.

Download all of the [archives listed in the Step 1 table](https://www.student.cs.uwaterloo.ca/~cs350/common/Install161NonCS.html), and place them in the same directory as this README. The `os161.tar.gz` archive is technically not necessary for building the image, but you will need it to actually use the environment.

For posterity, here are the hashes of each file:

    $ sha256sum os161-binutils.tar.gz os161-gcc.tar.gz os161-gdb.tar.gz os161-bmake.tar.gz os161-mk.tar.gz sys161.tar.gz os161.tar.gz
    ec41fd01fa89f3956a8c93b4ed12a11633a6fd58e8804a8ac6df201f16bb8f8d  os161-binutils.tar.gz
    a1e382f7eaf7bda34acb4ba5da6e2a1208d2930f9430fb2023ec356a2ecaf593  os161-gcc.tar.gz
    65975a9fc405d0e5e965a3413d3830789d1198415bd8d7df6507290c633c3fb8  os161-gdb.tar.gz
    aea63d5de54540445e9cd3f4b6f603bdabaebabff8e0567ad6d420b8078cd11f  os161-bmake.tar.gz
    37abd0c420f9caec56af27909b8cdda7e81fd4c4eac6a15e4583511693050e7b  os161-mk.tar.gz
    587c8638357d360d77f13d812d0b980cc699c9ca7f474ae640b4eb199e8db0a2  sys161.tar.gz
    b3b55d77d7e3173eec2e663521e20e0837d3e768280b88c0084bd2016bed2f73  os161.tar.gz

To build the image, run the following in the repository root:

```bash
sudo docker build -t uberi/cs350:latest .
```

There will be a lot of warnings, but give it at least a few minutes and it'll build.

To upload the image to Docker Hub, I use the following command:

    sudo docker push uberi/cs350:latest

License
-------

The files that are part of this project are made available under the 3-Clause BSD license - see `LICENSE.txt` for details. That means you are free to copy/modify/distribute them with very few restrictions.

This project does not include the additional files that are separately downloaded from the [course websites](https://www.student.cs.uwaterloo.ca/~cs350/common/WorkingWith161.html), as they do not seem to include a compatible license as of this writing.
