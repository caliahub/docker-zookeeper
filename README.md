#### zookeeper版本：3.5.7

#### docker镜像环境变量

|参数名称|默认值|说明|
|:---|:---|:---|
|ZOO_TICK_TIME|2000|tickTime|
|ZOO_INIT_LIMIT|5|initLimit|
|ZOO_SYNC_LIMIT|2|syncLimit|
|ZOO_AUTOPURGE_PURGEINTERVAL|0|autoPurge.purgeInterval|
|ZOO_AUTOPURGE_SNAPRETAINCOUNT|3|autoPurge.snapRetainCount|
|ZOO_MAX_CLIENT_CNXNS|60|maxClientCnxns|
|ZOO_STANDALONE_ENABLED|true|standaloneEnabled|
|ZOO_ADMINSERVER_ENABLED|true|admin.enableServer|
|ZOO_4LW_COMMANDS_WHITELIST||4lw.commands.whitelisti，默认不配置|
|ZOO_SERVERS||集群地址，默认不配置|
|ZOO_MY_ID||myid，默认不配置|


#### docker启动示例：
```
docker run -d -p 2181:2181 --restart=always caliahub/zookeeper:3.5.7
```

#### docker-compose启动示例：
```
version: '3'
services:
  zoo1:
    image: caliahub/zookeeper:3.5.7
    restart: always
    hostname: zoo1
    ports:
      - 2181:2181
    environment:
      ZOO_MY_ID: 1
      ZOO_SERVERS: server.1=0.0.0.0:2888:3888;2181 server.2=zoo2:2888:3888;2181 server.3=zoo3:2888:3888;2181

  zoo2:
    image: caliahub/zookeeper:3.5.7
    restart: always
    hostname: zoo2
    ports:
      - 2182:2181
    environment:
      ZOO_MY_ID: 2
      ZOO_SERVERS: server.1=zoo1:2888:3888;2181 server.2=0.0.0.0:2888:3888;2181 server.3=zoo3:2888:3888;2181

  zoo3:
    image: caliahub/zookeeper:3.5.7
    restart: always
    hostname: zoo3
    ports:
      - 2183:2181
    environment:
      ZOO_MY_ID: 3
      ZOO_SERVERS: server.1=zoo1:2888:3888;2181 server.2=zoo2:2888:3888;2181 server.3=0.0.0.0:2888:3888;2181
```
