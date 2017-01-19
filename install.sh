mkdir cs350-work
cd cs350-work

if [ ! `which docker ` ]; then
    sudo apt-get install --yes docker.io
    newgrp docker
fi
wget http://www.student.cs.uwaterloo.ca/~cs350/os161_repository/os161.tar.gz -O os161.tar.gz && tar -xzf os161.tar.gz
sudo docker run --volume "$(pwd):/root/cs350-os161" --interactive uberi/cs350:latest bash < ../additional_processing.sh

sudo docker exec -t -i `sudo docker ps -ql | xargs -I{} sudo docker start {}` bash

# now in the new shell type
# cd /root/cs350-os161/root && sys161 kernel


