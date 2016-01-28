FROM debian:jessie

RUN apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

RUN apt-get update && apt-get install -y apt-transport-https
RUN echo "deb https://apt.dockerproject.org/repo debian-jessie main"  >> /etc/apt/sources.list.d/docker.list

RUN apt-get -q update \
	&& apt-get -qy install \
		curl \
		docker-engine \
		debootstrap \
		python \
		python-pip \
		ca-certificates \
	&& rm -rf /var/lib/apt/lists/*

RUN pip install awscli

RUN gpg --recv-keys --keyserver pgp.mit.edu 0x9165938D90FDDD2E

COPY . /usr/src/mkimage

WORKDIR /usr/src/mkimage

CMD ./build.sh
