FROM caliahub/jre:1.8.0_101

MAINTAINER Calia "cnboycalia@gmail.com"

ENV ZOO_VERSION=3.5.7 \
    ZOO_DIR=/etc/zookeeper \
    ZOO_TICK_TIME=2000 \
    ZOO_INIT_LIMIT=5 \
    ZOO_SYNC_LIMIT=2 \
    ZOO_AUTOPURGE_PURGEINTERVAL=0 \
    ZOO_AUTOPURGE_SNAPRETAINCOUNT=3 \
    ZOO_MAX_CLIENT_CNXNS=60 \
    ZOO_STANDALONE_ENABLED=true \
    ZOO_ADMINSERVER_ENABLED=true

COPY docker-entrypoint.sh /usr/local/bin/

RUN set -eux; \
    cd /tmp; \
    addgroup -S zookeeper --gid=1000; \
    adduser -S -g zookeeper --uid=1000 zookeeper; \
    mkdir -p "${ZOO_DIR}/data" "${ZOO_DIR}/logs" "${ZOO_DIR}/bin"; \
    wget https://archive.apache.org/dist/zookeeper/zookeeper-${ZOO_VERSION}/apache-zookeeper-${ZOO_VERSION}-bin.tar.gz; \
    tar -zxf "apache-zookeeper-${ZOO_VERSION}-bin.tar.gz"; \
    mv "apache-zookeeper-${ZOO_VERSION}-bin/conf" "${ZOO_DIR}/"; \
    mv "apache-zookeeper-${ZOO_VERSION}-bin/lib" "${ZOO_DIR}/"; \
    mv "apache-zookeeper-${ZOO_VERSION}-bin/bin/zkServer.sh" "${ZOO_DIR}/bin/"; \
    mv "apache-zookeeper-${ZOO_VERSION}-bin/bin/zkEnv.sh" "${ZOO_DIR}/bin/"; \
    rm -rf "${ZOO_DIR}/conf/zoo_sample.cfg" "apache-zookeeper-${ZOO_VERSION}-bin"*; \
    chown -R zookeeper:zookeeper "${ZOO_DIR}";

ENV PATH=$PATH:${ZOO_DIR}/bin

WORKDIR ${ZOO_DIR}

USER zookeeper

VOLUME ${ZOO_DIR}/data

EXPOSE 2181 2888 3888

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["zkServer.sh", "start-foreground"]
