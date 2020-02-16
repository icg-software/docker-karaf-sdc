FROM centos:7

MAINTAINER spalarus <s.palarus@googlemail.com>

ARG SDC_DIST_VERSION=0.6.0
ENV KARAF_HOME=/opt/karaf
ENV KARAF_BASE=/opt/karaf
ENV HOME=/opt/karaf
ENV JAVA_HOME=/etc/alternatives/jre_11_openjdk
ENV JRE_HOME=/etc/alternatives/jre_11_openjdk

ADD ./entrypoint.sh /entrypoint.sh
ADD ./initkaraf /opt/karaf/bin/initkaraf
ADD ./varinitrunner /opt/karaf/bin/varinitrunner
ADD ./fileinitrunner /opt/karaf/bin/fileinitrunner
ADD ./checkvoletc /opt/karaf/bin/checkvoletc
ADD ./touchvoletc /opt/karaf/bin/touchvoletc

RUN yum update -y && \
    yum install -y wget curl zip unzip vim sudo && \
    yum install -y java-11-openjdk && \
    groupadd -r karaf -g 1777 && \
    useradd -u 1777 -r -g karaf -m -d /opt/karaf -s /sbin/nologin -c "Karaf user" karaf && \
    chmod 755 /opt/karaf && \
    wget https://repo1.maven.org/maven2/org/sodeac/org.sodeac.karaf.assembly/${SDC_DIST_VERSION}/org.sodeac.karaf.assembly-${SDC_DIST_VERSION}.tar.gz && \
    tar --strip-components=1 -C /opt/karaf -xzf org.sodeac.karaf.assembly-${SDC_DIST_VERSION}.tar.gz && \
    rm org.sodeac.karaf.assembly-${SDC_DIST_VERSION}.tar.gz && \
    touch /opt/karaf/firstboot && \
    mkdir /opt/karaf/vol && \
    chown -R karaf.karaf /opt/karaf && \
    chmod u+x /entrypoint.sh && \
    chmod u+x /opt/karaf/bin/checkvoletc && \
    chmod u+x /opt/karaf/bin/touchvoletc && \
    chmod u+x /opt/karaf/bin/varinitrunner && \
    chmod u+x /opt/karaf/bin/fileinitrunner && \
    chmod u+x /opt/karaf/bin/initkaraf && \
    yum clean all && \
    rm -rf /var/cache/yum
    
ADD ./buildboot.sh /tmp/buildboot.sh
ADD ./build.commands /tmp/build.commands
    
RUN sudo -E -u karaf bash /tmp/buildboot.sh && \
    rm /tmp/buildboot.sh && \
    rm /tmp/build.commands && \
    rm /opt/karaf/etc/host.key && \
    rm /opt/karaf/etc/host.key.pub && \
    tar --directory /opt/karaf/etc -czvf /opt/karaf/etc_original.tgz . && \
    chown karaf.karaf /opt/karaf/etc_original.tgz
    
USER karaf
WORKDIR ${KARAF_HOME}

ENV JAVA_OPTS=
ENV FETCH_CUSTOM_URL=NONE
ENV KARAF_INIT_COMMANDS=NONE
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8
ENV CLEAN_CACHE=false
ENV LINK_VOL_DEPLOY=true
ENV LINK_VOL_LOG=true
ENV LINK_VOL_MSG_BROKER=true
ENV LINK_VOL_TMP=true
ENV INIT_SCRIPT_USER=karaf
ENV INIT_SCRIPT_PWD=karaf

VOLUME ["/opt/karaf/vol"]
EXPOSE 1099 8101 8181 44444 10636 61617
ENTRYPOINT ["/entrypoint.sh"]

# Define default command.
CMD ["/opt/karaf/bin/karaf", "run"] 
