FROM openjdk:8u212-jdk-alpine

LABEL org.opencontainers.image.authors="Nikita Kovalev" \
      org.opencontainers.image.source="https://github.com/maizy/actions-sbt-setup" \
      org.opencontainers.image.version="v1"

ARG SBT_VERSION
ENV SBT_VERSION ${SBT_VERSION:-1.2.8}
ENV SBT_HOME /usr/local/sbt

RUN apk --no-cache --update add bash wget git

RUN mkdir -p "$SBT_HOME" && \
    wget -qO - "https://github.com/sbt/sbt/releases/download/v${SBT_VERSION}/sbt-${SBT_VERSION}.tgz" | tar xz -C "${SBT_HOME}" --strip-components=1

ARG SCALA_VERSION
ENV SCALA_VERSION ${SCALA_VERSION:-2.12.9}
ENV SCALA_HOME /usr/local/scala
ENV PATH ${PATH}:${SBT_HOME}/bin:${SCALA_HOME}/bin

RUN mkdir -p /tmp/sbt-project/project && \
    mkdir -p "$SCALA_HOME" && \
    wget -qO - "https://downloads.typesafe.com/scala/$SCALA_VERSION/scala-${SCALA_VERSION}.tgz" | tar xz -C "${SCALA_HOME}" --strip-components=1 && \
    echo "scalaVersion := \"${SCALA_VERSION}\"" > /tmp/sbt-project/build.sbt && \
    echo "sbt.version=${SBT_VERSION}" > /tmp/sbt-project/project/build.properties && \
    echo "case object App" > /tmp/sbt-project/App.scala && \
    cd /tmp/sbt-project && \
    sbt sbtVersion compile && \
    cd /root && \
    rm -rf /tmp/sbt-project

WORKDIR /root
ENTRYPOINT ["bash"]
