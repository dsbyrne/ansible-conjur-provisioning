FROM ubuntu:14.04

RUN apt-get update
RUN apt-get install -y software-properties-common
RUN apt-add-repository -y ppa:ansible/ansible
RUN apt-get update
RUN apt-get install -y ansible supervisor openssh-server python-pip curl unzip

RUN pip install boto

# Install Summon and the Conjur provider for summon
WORKDIR /tmp
RUN curl -o summon.tgz -sSL https://github.com/conjurinc/summon/releases/download/v0.4.0/summon_v0.4.0_linux_amd64.tar.gz
RUN tar -xf summon.tgz
RUN mv summon /usr/local/bin

RUN curl -o summon-conjur.zip -sSL https://github.com/conjurinc/summon-conjur/releases/download/v0.1.4/summon-conjur_v0.1.4_linux-amd64.zip
RUN unzip summon-conjur.zip
RUN mkdir -p /usr/local/lib/summon
RUN mv summon-conjur /usr/local/lib/summon

RUN rm summon*

# Install the Conjur CLI
RUN curl -o conjur.deb -sSL https://github.com/conjurinc/cli-ruby/releases/download/v5.2.0/conjur_5.2.0-1_amd64.deb
RUN dpkg -i conjur.deb
RUN rm conjur.deb

WORKDIR /

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN mkdir -p /var/run/sshd

EXPOSE 22

CMD ["/usr/bin/supervisord"]