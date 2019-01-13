FROM kalilinux/kali-linux-docker:latest

MAINTAINER Xavi Torelló <info@xaviertorello.cat>

ENV DEBIAN_FRONTEND noninteractive
ENV TERM xterm-256color

RUN rm -fR /var/lib/apt/
RUN apt-get clean
RUN apt-get update -y
RUN apt-get install -y software-properties-common && apt-get update -y
RUN apt-get install -y kali-linux-full --fix-missing
RUN apt-get install -y git colordiff colortail unzip vim tmux xterm zsh curl telnet strace ltrace tmate less build-essential wget python3-setuptools python3-pip tor proxychains
RUN git clone https://github.com/danielmiessler/SecLists /usr/share/seclists
RUN updatedb

# ngrok
RUN curl https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip | gunzip - > /usr/bin/ngrok
RUN chmod +x /usr/bin/ngrok

# virtualenv config
RUN pip install virtualenvwrapper
ENV WORKON_HOME $HOME/.virtualenvs
ENV PROJECT_HOME $HOME/projects
RUN mkdir $HOME/projects
ENV VIRTUALENVWRAPPER_SCRIPT /usr/local/bin/virtualenvwrapper.sh
RUN bash /usr/local/bin/virtualenvwrapper.sh
RUN echo "source /usr/local/bin/virtualenvwrapper.sh > /dev/null" >> /etc/profile

# Tor refresh every 5 requests
RUN echo MaxCircuitDirtiness 10 >> /etc/tor/torrc
# Tor start at init
RUN update-rc.d tor enable

# Welcome message
RUN echo "echo 'Kali full container!\n\n- If you need proxychains over Tor just activate tor service with:\n$ service tor start\n'" >> /etc/profile

CMD ["/bin/bash", "--init-file", "/etc/profile"]
