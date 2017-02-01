#!/usr/bin/env bash

# runs OS/161 in SYS/161 and attaches GDB, side by side in a tmux window

# set up bash to handle errors more aggressively - a "strict mode" of sorts
set -e # give an error if any command finishes with a non-zero exit code
set -u # give an error if we reference unset variables
set -o pipefail # for a pipeline, if any of the commands fail with a non-zero exit code, fail the entire pipeline with that exit code

# display an error if we're not running inside a Docker container
if ! grep docker /proc/1/cgroup -qa; then
  echo 'ERROR: PLEASE RUN THIS SCRIPT INSIDE THE INTERACTIVE CS350 SHELL (SEE `start-interactive-cs350-shell.sh`)'
  exit 1
fi

ASSIGNMENT=ASST0

# copy in the SYS/161 default configuration
mkdir --parents /root/cs350-os161/root
cp --update /root/sys161/share/examples/sys161/sys161.conf.sample /root/cs350-os161/root/sys161.conf

# build kernel
cd /root/cs350-os161/os161-1.99
./configure --ostree=/root/cs350-os161/root --toolprefix=cs350-
cd /root/cs350-os161/os161-1.99/kern/conf
./config $ASSIGNMENT
cd /root/cs350-os161/os161-1.99/kern/compile/$ASSIGNMENT
bmake depend
bmake
bmake install

# build user-level programs
cd /root/cs350-os161/os161-1.99
bmake
bmake install

# set up the simulator run
cd ~/cs350-os161/root
apt-get install --yes -qq tmux

# set up a tmux session with SYS/161 in one pane, and GDB in another
tmux kill-session -t os161 || true # kill old tmux session, if present
tmux new-session -d -s os161 # start a new tmux session, but don't attach to it just yet
tmux split-window -h -t os161:0 # split the tmux window in half
tmux send-keys -t os161:0.0 'sys161 -w kernel' C-m # start SYS/161 and wait for GDB to connect
tmux send-keys -t os161:0.1 'cs350-gdb kernel' C-m # start GDB
sleep 0.5 # wait a little bit for SYS/161 and GDB to start
tmux send-keys -t os161:0.1 "dir ~/cs350-os161/os161-1.99/kern/compile/$ASSIGNMENT" C-m # in GDB, switch to the kernel directory
tmux send-keys -t os161:0.1 'target remote unix:.sockets/gdb' C-m # in GDB, connect to SYS/161
tmux send-keys -t os161:0.1 'c' # in GDB, fill in the continue command automatically so the user can just press Enter to continue
tmux attach-session -t os161 # attach to the tmux session
