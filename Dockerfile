FROM google/cloud-sdk:latest

RUN apt-get update -y && apt-get upgrade -y && \
	apt-get install -y openssh-server jq mysql-client unzip && \
	mkdir /var/run/sshd && \
	sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin wihtout-password/' /etc/ssh/sshd_config

ADD init.sh /
RUN chmod +x /init.sh

# Clean up
RUN apt-get autoremove -y && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 22
CMD ["/init.sh"]
