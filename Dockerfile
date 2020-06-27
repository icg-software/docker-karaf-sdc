FROM spalarus/karaf-base:latest

MAINTAINER spalarus <s.palarus@googlemail.com>

ARG SDC_DIST_VERSION=0.6.2

ADD ./initkarafcustom /opt/karaf/bin/initkarafcustom
ADD ./build.commands /tmp/build.commands

RUN chown karaf.karaf /opt/karaf/bin/initkarafcustom && \
    chown karaf.karaf /tmp/build.commands && \
    chmod u+x /opt/karaf/bin/initkarafcustom

WORKDIR ${KARAF_HOME}
USER karaf

RUN wget https://repo1.maven.org/maven2/org/sodeac/org.sodeac.karaf.assembly/${SDC_DIST_VERSION}/org.sodeac.karaf.assembly-${SDC_DIST_VERSION}.tar.gz && \
    tar --strip-components=1 -C /opt/karaf -xzf org.sodeac.karaf.assembly-${SDC_DIST_VERSION}.tar.gz && \
    /tmp/installer.sh org.sodeac.karaf.assembly-${SDC_DIST_VERSION}.tar.gz && \
    rm /tmp/karaf.valid

ENV JAVA_OPTS=-Xmx1g
ENV LINK_VOL_MSG_BROKER=true

EXPOSE 1099 8101 8181 44444 10636 61617
