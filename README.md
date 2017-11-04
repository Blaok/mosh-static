# mosh-static
Build scripts for building a static [mosh](https://github.com/rinne/mosh) with agent forwarding.

## Motivation

### Why mosh?
Mosh uses UDP instead of TCP after authentication, which allows you to resume your connection after changing the network environment, which is important to people having remote connections on all the time, like me.

### Why build?
Generally you don't want to build things available from the package manager by yourself. However, due to some unknown, mysterious reasons, mosh maintainers refuse to merge agent forwarding functionality (in the last two years). [@rinne](https://github.com/rinne), who started the pull request, maintains a [fork](https://github.com/rinne/mosh) implementing this crutial functionality.

### Why static?
Even if you do need to build mosh from source, you wouldn't want to make a static build. Nevertheless, you'll need this unoffcial version of mosh binaries on both client and server, which will be painful to compile on every one of them if you have a heterogeneous cluster. In this case, building a static mosh with agent-forwarding becomes a good idea.

## Usage

1. prepare build tools (GCC, make, etc.)
2. `./build.sh`

## Tested environment

The scripts are tested on Ubuntu 16.04.3 LTS.
