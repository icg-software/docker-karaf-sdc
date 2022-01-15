FROM ghcr.io/icg-software/karaf-base:latest

LABEL maintainer="icgsoftware <j_liepe@icg-software.de>"

ARG SDC_DIST_VERSION=0.6.9

ADD ./initkarafcustom /opt/karaf/bin/initkarafcustom
ADD ./build.commands /tmp/build.commands

RUN chown karaf.karaf /opt/karaf/bin/initkarafcustom && \
    chown karaf.karaf /tmp/build.commands && \
    chmod u+x /opt/karaf/bin/initkarafcustom

WORKDIR ${KARAF_HOME}
USER karaf

RUN \
	wget https://github.com/icg-software/karaf-sodeac-assembly/releases/download/v${SDC_DIST_VERSION}/org.sodeac.karaf.assembly-${SDC_DIST_VERSION}.tar.gz && \
    /tmp/installer.sh org.sodeac.karaf.assembly-${SDC_DIST_VERSION}.tar.gz && \
    rm /tmp/karaf.valid

ENV JAVA_OPTS=-Xmx1g
ENV LINK_VOL_MSG_BROKER=true

EXPOSE 1099 8101 8181 44444 10636 61617
