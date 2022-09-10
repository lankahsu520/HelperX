# docker build -t="ubuntu:22.04v1" .
# ubuntu 22.04
FROM ubuntu:20.04

RUN apt-get update
RUN apt-get install \
            cmake \
            pkg-config \
            meson \
            ninja-build \
            gio-2.0 \
            git \
            lsb-release \
            -y

# dash -> bash
RUN cd /bin && rm sh; ln -s bash sh

# mkdir /work; cd /work
WORKDIR /work
# cp -avr * /work
#ADD . /work

#CMD ls -al

# open port:9981
EXPOSE 9981

RUN apt-get clean
RUN apt-get autoclean
RUN apt-get autoremove --purge

