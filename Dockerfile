FROM registry.redhat.io/ubi8/ubi

USER root

ADD files/files-rhel8.tgz /

# remove procps-ng iputils iproute for production images
RUN sed -i".ori" -e 's/^enabled=1/enabled=0/' /etc/yum/pluginconf.d/subscription-manager.conf && \
    dnf -y --nodocs update && \
    dnf -y --nodocs install ddclient procps-ng iputils iproute && \
    dnf -y clean all && \
    cp /etc/ddclient.conf /etc/ddclient.conf.ori && \
    cp /etc/ddclient.conf.new /etc/ddclient.conf && \
    rm -f /etc/ddclient.conf.new && \
    rm -rf /etc/pki/entitlement/* && \
    chgrp -R 0 /etc/ddclient.conf /var/run/ddclient /var/cache/ddclient && \
    chmod -R g=u /etc/ddclient.conf* /var/run/ddclient /var/cache/ddclient

CMD ["/usr/sbin/ddclient","-foreground","-verbose","-debug"]

USER 1001
