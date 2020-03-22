FROM java:openjdk-8-jdk

ARG KAFKA_VERSION=2.4.1 
ARG KAFKA_DIST=kafka_2.12-2.4.1
ARG BUILD_TIME="-"
ARG REVISION="-"

ENV DEBIAN_FRONTEND=noninteractive \
	KAFKA_HOME=/opt/kafka \
	KAFKA_RUNTIME_HOME=/var/kafka

ENV PATH=${PATH}:${KAFKA_HOME}/bin

LABEL org.opencontainers.image.created=$BUILD_TIME \
	  org.opencontainers.image.url="https://github.com/FelixGSE/kafka-playground" \
	  org.opencontainers.image.source="https://github.com/FelixGSE/kafka-playground" \
	  org.opencontainers.image.version="MAJOR.MINOR.PATCH" \
	  org.opencontainers.image.revision="$REVISION" \
	  org.opencontainers.image.vendor="-" \
	  org.opencontainers.image.title="Apache-Kafka" \
	  org.opencontainers.image.description="Minimal docker image to run Apache-Kafka" \
	  org.opencontainers.image.documentation="https://github.com/FelixGSE/kafka-playground/README.md" \
	  org.opencontainers.image.authors="FelixGSE" \
	  org.opencontainers.image.licenses="Apache-2.0" \
	  org.opencontainers.image.ref.name="-"

RUN wget https://www.apache.org/dist/kafka/KEYS \
&&  wget https://www.apache.org/dist/kafka/$KAFKA_VERSION/$KAFKA_DIST.tgz \
&&  wget https://www.apache.org/dist/kafka/$KAFKA_VERSION/$KAFKA_DIST.tgz.asc \
&&	gpg --import KEYS \
&&	gpg --verify $KAFKA_DIST.tgz.asc \
&&  tar -xzf $KAFKA_DIST.tgz \
&&  mv $KAFKA_DIST $KAFKA_HOME \
&&	mkdir -p $KAFKA_RUNTIME_HOME \
&&  cp -a $KAFKA_HOME/config/. $KAFKA_RUNTIME_HOME/config/ \
&&  rm KEYS \
    $KAFKA_DIST.tgz \
    $KAFKA_DIST.tgz.asc \
&&  adduser --system \
			--group \
			--no-create-home \
			--home $KAFKA_RUNTIME_HOME \
			--shell /usr/sbin/nologin \
			--disabled-password \
			kafka \
&&  chown -R kafka:kafka $KAFKA_RUNTIME_HOME

USER kafka

WORKDIR $KAFKA_RUNTIME_HOME

COPY entrypoint.sh entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]