mkdir cs350-work
cd cs350-work

# install Docker if not already installed
sudo apt-get install --yes -qq docker.io

# get OS161
wget https://www.student.cs.uwaterloo.ca/~cs350/os161_repository/os161.tar.gz -O os161.tar.gz
tar -xzf os161.tar.gz

# get useful processing scripts
wget https://github.com/Uberi/uw-cs350-development-environment/blob/master/start-interactive-cs350-shell.sh -O start-interactive-cs350-shell.sh
wget https://github.com/Uberi/uw-cs350-development-environment/blob/master/build-and-run-kernel.sh -O build-and-run-kernel.sh

# get the prebuilt Docker image
sudo docker pull uberi/cs350:latest
