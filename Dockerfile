#!/bin/bash
FROM ubuntu:20.04
#FROM ubuntu:focal
ENV TZ=Asia/Taipei
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone


RUN sed -i 's/deb-src/#deb-src/g' /etc/apt/sources.list

RUN sed -i 's/archive.ubuntu.com/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list

RUN sed -i 's/deb http:\/\/mirrors.tuna.tsinghua.edu.cn\/ubuntu\/ focal-updates/#deb http:\/\/mirrors.tuna.tsinghua.edu.cn\/ubuntu\/ focal-updates/g' /etc/apt/sources.list

RUN sed -i 's/security.ubuntu.com/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list

RUN sed -i 's/deb http:\/\/security.ubuntu.com\/ubuntu\/ focal-security/deb http:\/\/archive.ubuntu.com\/ubuntu\/ focal-security/g' /etc/apt/sources.list

#Mike add update xfce desktop package
RUN apt-get update

RUN apt-get --allow-downgrades install -y --no-install-recommends libudev1=245.4-4ubuntu3.20 udev xorg-input-abi-24 xorg-video-abi-24 xserver-xorg-core

RUN DEBIAN_FRONTEND="noninteractive" apt-get install -y --no-install-recommends \
        dbus-x11 \
        x11-xserver-utils \
        xfce4 \
        xfce4-terminal \
        xorgxrdp \
        xrdp \
    && rm -rf /var/lib/apt/lists/*


RUN apt-get update
RUN apt upgrade --allow-downgrades -y
RUN apt-get install sudo docker --fix-missing -y
RUN echo 'Acquire::https::repos.influxdata.com::Verify-Peer "false";' > sudo /etc/apt/apt.conf.d/99influxdata-cert
RUN echo "$PASSWD" | sudo -S apt-get install --fix-missing -y locales
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

COPY ./linux-libc-dev_5.4.0-186.206_amd64.deb /

RUN echo "$PASSWD" | sudo -S dpkg -i /linux-libc-dev_5.4.0-186.206_amd64.deb || apt-get install -f -y

ARG pwd
ARG user
ARG uid
ARG guid

ENV PASSWD $pwd
ENV ACCOUNT $user
ENV GUID $guid
ENV UID $uid
#RUN groupadd -r -g $guid $user
RUN groupadd docker
#RUN useradd $user -l -u $uid -g $guid -p "$(openssl passwd -1 PASSWD)" -d /home/$user -m -s /bin/bash
#RUN  echo "$ACCOUNT ALL=(ALL) NOPASSWD:ALL" >>/etc/sudoers
RUN useradd -ms /bin/bash $user -l -u $uid -d /home/$user && echo "$ACCOUNT:$PASSWD" | chpasswd
RUN usermod -aG sudo $user
RUN usermod -aG docker $user


USER ${user}

#COPY ./libcurl3-gnutls_7.68.0-1ubuntu2.21_amd64.deb /
#COPY ./libmount1_2.34-0.1ubuntu9.3_amd64.deb /
#COPY ./libblkid1_2.34-0.1ubuntu9.3_amd64.deb /
#COPY ./libcurl4_7.68.0-1ubuntu2.21_amd64.deb /
#COPY ./libmount-dev_2.34-0.1ubuntu9.3_amd64.deb /
#COPY ./libblkid-dev_2.34-0.1ubuntu9.3_amd64.deb /
#COPY ./liblocale-gettext-perl_1.07-5_amd64.deb /
#COPY ./libuuid1_2.34-0.1ubuntu9.3_amd64.deb /
##COPY ./uuid-dev_2.34-0.1ubuntu9.3_amd64.deb /
#COPY ./uuid-dev_2.34-0.1ubuntu9.6_amd64.deb /
#COPY ./libcurl4-gnutls-dev_7.68.0-1ubuntu2.21_amd64.deb /
#COPY ./curl_7.68.0-1ubuntu2.21_amd64.deb /

RUN echo "$PASSWD" | sudo -S apt-get install --fix-missing -y libterm-readkey-perl cpio wget 

#RUN echo "$PASSWD" | sudo -S apt-get install --fix-missing -y /libcurl3-gnutls_7.68.0-1ubuntu2.21_amd64.deb
#RUN echo "$PASSWD" | sudo -S apt-get --allow-downgrades install --fix-missing -y /libmount1_2.34-0.1ubuntu9.3_amd64.deb
#RUN echo "$PASSWD" | sudo -S apt-get --allow-downgrades install --fix-missing -y /libblkid1_2.34-0.1ubuntu9.3_amd64.deb
#RUN echo "$PASSWD" | sudo -S apt-get install --fix-missing -y /libcurl4_7.68.0-1ubuntu2.21_amd64.deb
#RUN echo "$PASSWD" | sudo -S apt-get --allow-downgrades install --fix-missing -y /libuuid1_2.34-0.1ubuntu9.3_amd64.deb
#RUN echo "$PASSWD" | sudo -S apt-get --allow-downgrades install --fix-missing -y /linux-libc-dev_5.4.0-186.206_amd64.deb


#RUN echo "$PASSWD" | sudo -S apt-get --allow-downgrades install --fix-missing -y /uuid-dev_2.34-0.1ubuntu9.6_amd64.deb
#RUN echo "$PASSWD" | sudo -S apt-get --allow-downgrades install --fix-missing -y /libblkid-dev_2.34-0.1ubuntu9.3_amd64.deb
#RUN echo "$PASSWD" | sudo -S apt-get --allow-downgrades install --fix-missing -y /libmount-dev_2.34-0.1ubuntu9.3_amd64.deb
#RUN echo "$PASSWD" | sudo -S apt-get install --fix-missing -y /liblocale-gettext-perl_1.07-5_amd64.deb
#RUN echo "$PASSWD" | sudo -S apt-get install --fix-missing -y /libcurl4-gnutls-dev_7.68.0-1ubuntu2.21_amd64.deb
#RUN echo "$PASSWD" | sudo -S apt-get install --fix-missing -y /curl_7.68.0-1ubuntu2.21_amd64.deb

#RUN apt-get update
#RUN apt-get install apt-utils


#RUN echo "$PASSWD" | sudo -S apt-get install --fix-missing -y libterm-readkey-perl cpio wget

#RUN wget http://archive.ubuntu.com/ubuntu/pool/main/e/expat/libexpat1_2.2.9-1build1_amd64.deb && dpkg -i libexpat1_2.2.9-1build1_amd64.deb && rm libexpat1_2.2.9-1build1_amd64.deb

#RUN echo "$PASSWD" | sudo -S apt-get --allow-downgrades install --fix-missing -y git build-essential python3 python3-distutils python3-setuptools autoconf libtool vim tmux curl libssl-dev libuuid1=2.34-0.1ubuntu9.3 libblkid1=2.34-0.1ubuntu9.3 uuid-dev libmount1=2.34-0.1ubuntu9.3 libblkid-dev libmount-dev libglib2.0-dev libpulse-dev libsystemd0=245.4-4ubuntu3.20

#RUN echo "$PASSWD" | sudo -S apt-get --allow-downgrades install --fix-missing -y git build-essential python3 python3-distutils python3-setuptools autoconf libtool vim tmux libssl-dev libglib2.0-dev libpulse-dev libsystemd0=245.4-4ubuntu3.20

RUN echo "$PASSWD" | sudo -S apt-get --allow-downgrades install --fix-missing -y git build-essential python3 python3-distutils python3-setuptools autoconf libtool vim tmux libssl-dev libglib2.0-dev libpulse-dev libsystemd0=245.4-4ubuntu3.20

RUN echo "$PASSWD" | sudo -S apt-get install --fix-missing -y git libsdl1.2-dev \
                        texinfo \
                        gawk \
                        tree \
                        autoconf-archive \
                        chrpath \
                        diffstat\
                        libpixman-1-dev \
                        libreadline-dev \
                        libsystemd-dev \
                        mingw-w64 \
                        libncurses-dev \
                        rpm2cpio \
                        iputils-ping \
                        net-tools \
                        openssh-server \
                        ninja-build \
                        unzip \
                        gcc \
                        g++ \
                        make \
                        file \
                        bzip2 \
                        rsync

RUN echo "$PASSWD" | sudo -S apt-get -y install nghttp2 libnghttp2-dev libssl-dev software-properties-common librtmp-dev libexpat1-dev tcl tk gettext
RUN echo "$PASSWD" | sudo -S apt-get -y install zstd lz4 sqlite3 libsqlite3-dev
RUN echo "$PASSWD" | sudo -S apt-get -y install apache2
RUN echo "$PASSWD" | sudo -S apt-get -y install libarchive-zip-perl
RUN echo "$PASSWD" | sudo -S apt-get --fix-missing -y install ntp
RUN echo "$PASSWD" | sudo -S service ntp restart
#RUN sudo apt-get install -y ssh
#RUN ln -s /usr/bin/python3.8 /usr/bin/python3


RUN echo "$PASSWD" | sudo -S git clone https://github.com/mesonbuild/meson.git
#RUN cd meson && python3.8 setup.py install && cd .. && rm -rf meson

#RUN git clone --depth 1 --branch 0.60.3 https://github.com/mesonbuild/meson.git
ADD meson /meson
RUN cd /meson && echo "$PASSWD" | sudo -S python3 setup.py install && cd .. && echo "$PASSWD" | sudo -S rm -rf /meson

#COPY oecore-x86_64-armv7a-toolchain-nodistro.0.sh /
#RUN /oecore-x86_64-armv7a-toolchain-nodistro.0.sh -y


# Add user to sudoers
#USER ${user}

# Enable ssh port
#RUN echo 'root:iecroot' | sudo chpasswd

RUN echo "$PASSWD" | sudo -S apt-get install -y ssh
RUN echo "$PASSWD" | sudo -S sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
# Configure SSHD.
# SSH login fix. Otherwise user is kicked off after login
RUN echo "$PASSWD" | sudo -S sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
#RUN sudo mkdir /var/run/sshd
RUN echo "$PASSWD" | sudo -S bash -c 'install -m755 <(printf "#!/bin/sh\nexit 0") /usr/sbin/policy-rc.d'
RUN echo "$PASSWD" | sudo -S ex +'%s/^#\zeListenAddress/\1/g' -scwq /etc/ssh/sshd_config
RUN echo "$PASSWD" | sudo -S ex +'%s/^#\zeHostKey .*ssh_host_.*_key/\1/g' -scwq /etc/ssh/sshd_config
RUN echo "$PASSWD" | sudo -S RUNLEVEL=1 dpkg-reconfigure openssh-server
RUN ssh-keygen -A -v
RUN echo "$PASSWD" | sudo -S update-rc.d ssh defaults

# Configure sudo.
RUN echo "$PASSWD" | sudo -S ex +"%s/^%sudo.*$/%sudo ALL=(ALL:ALL) NOPASSWD:ALL/g" -scwq! /etc/sudoers

# Generate and configure user keys.
#USER ubuntu
USER $ACCOUNT
RUN ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 
#COPY --chown=ubuntu:root "./files/authorized_keys" /home/ubuntu/.ssh/authorized_keys

# Setup default command and/or parameters.
EXPOSE 22
#CMD ["/usr/bin/sudo", "/usr/sbin/sshd", "-D", "-o", "ListenAddress=0.0.0.0"]

#Enable HTTP / HTTPS
EXPOSE 80 443

RUN echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal main restricted universe multiverse" | sudo tee /etc/apt/sources.list

#RUN echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-updates main restricted universe multiverse" | sudo tee -a /etc/apt/sources.list

RUN echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-backports main restricted universe multiverse" | sudo tee -a /etc/apt/sources.list

RUN echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-security main restricted universe multiverse" | sudo tee -a /etc/apt/sources.list

#RUN echo "deb http://security.ubuntu.com/ubuntu/ focal-security main restricted universe multiverse" | sudo tee -a /etc/apt/sources.list

RUN sudo apt-get update
RUN sudo apt-get upgrade -y

CMD ["/bin/bash"]
#ENTRYPOINT service ssh restart

#RUN echo "$PASSWD" | sudo -S rm -rf /var/lib/apt/lists/*

#Mike Add EXPOSE 3389 for XFCE remote desktop
COPY entrypoint.sh /usr/bin/entrypoint
EXPOSE 3389/tcp

#RUN groupadd -g $guid $user \
#    && useradd --shell /bin/bash --uid $guid --gid $guid --password "$(openssl passwd -1 PASSWD)" 

#CMD ["sudo service xrdp start"]

#CMD ["/usr/bin/sudo", "/usr/sbin/sshd", "-D", "-o", "ListenAddress=0.0.0.0", "&&", "sudo service xrdp start"]

ENTRYPOINT ["/usr/bin/entrypoint"]



