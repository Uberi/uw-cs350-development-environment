CS350 OS/161 Setup
==================

[Docker](https://www.docker.com/) container for the [OS/161](http://os161.eecs.harvard.edu/) setup used in [CS350 at the University of Waterloo](https://www.student.cs.uwaterloo.ca/~cs350/). This setup is current as of the Spring 2016 term.

Set up a fully functional CS350 development environment with one command!

Quickstart on Debian/Ubuntu:

```bash
sudo apt-get install --yes docker.io
wget http://www.student.cs.uwaterloo.ca/~cs350/os161_repository/os161.tar.gz -O os161.tar.gz && tar -xzf os161.tar.gz
sudo docker run --volume "$(pwd):/cs350-os161" --interactive --tty uberi/cs350:latest bash
# you are now in an interactive shell in the development environment
```

Supports most x86/x86-64 Linux/OS X systems.

Rationale
---------

CS350 (Operating Systems) is a course at the University of Waterloo. In this course, to do the assignments, you need to either set up OS/161 locally, or use the student environment.

I prefer being able to do my work without requiring a network connection. However, the installation process requires a few things that are somewhat cumbersome with most desktop system configurations.

This Docker container contains a fully set up development environment for CS350 coursework, avoiding issues such as GCC versions, ncurses compatibility, and having to manually copy and paste commands around.

Usage
-----

You do not need to clone or download this repository.

First, make sure you have Docker - refer to the [official Docker installation instructions](https://docs.docker.com/engine/installation/) for details.

Download and extract the [CS350 OS/161 archive](http://www.student.cs.uwaterloo.ca/~cs350/os161_repository/os161.tar.gz) into a convenient folder. This will be where you can work on the OS/161 code in here.

**Note:** On platforms that use Boot2Docker, like OS X, this folder will be read-only inside the container - changing files inside of the container will not change any files on the host machine.

Now, start an interactive shell inside the image by running the following in the same folder the OS/161 archive was extracted to (this folder should now contain a folder named `os161-1.99`):

    sudo docker run --volume "$(pwd):/cs350-os161" --interactive --tty uberi/cs350:latest bash

If this is the first run, and you haven't built the image yourself, this might take a little while to start while Docker downloads the image from Docker Hub.

Now, you can edit the source code on the host machine, and compile/test/debug inside the Docker image.

If `bmake install` fails with `mkdir: cannot create directory '/root/os161/root': No such file or directory`, just create the directory: `mkdir --parents /root/os161`.

Building
--------

First, make sure you have Docker - refer to the [official Docker installation instructions](https://docs.docker.com/engine/installation/) for details.

Download all of the [archives listed in the Step 1 table](https://www.student.cs.uwaterloo.ca/~cs350/common/Install161NonCS.html), and place them in the same directory as this README. The `os161.tar.gz` archive is technically not necessary for building the image, but you will need it to actually use the environment.

To build the image, run the following in the repository root:

    sudo docker build -t uberi/cs350:latest .

There will be a lot of warnings, but give it at least a few minutes and it'll build.

To upload the image to Docker Hub, I use the following command:

    sudo docker push uberi/cs350:latest

License
-------

The files that are part of this project are made available under the 3-Clause BSD license - see `LICENSE.txt` for details. That means you are free to copy/modify/distribute them with very few restrictions.

This project does not include the additional files that are separately downloaded from the [course websites](https://www.student.cs.uwaterloo.ca/~cs350/common/WorkingWith161.html), as they do not seem to include a compatible license as of this writing.