FROM ballerina/ballerina:2201.7.4 AS ballerina-builder

# hadolint ignore=DL3002
USER root
COPY . /src
WORKDIR /src

RUN bal build

FROM adoptopenjdk/openjdk11:jre-11.0.18_10-alpine

WORKDIR /home/ballerina

LABEL maintainer="choreo.dev"

RUN addgroup troupe \
    && adduser -S -s /bin/bash -g 'ballerina' -G troupe -D ballerina \
    && apk add --update --no-cache bash=5.1.16-r0 \
    && apk add libcrypto1.1=1.1.1t-r2 libssl1.1=1.1.1t-r2 zlib=1.2.12-r3 \
    && chown -R ballerina:troupe /opt/java/openjdk/bin/java \
    && rm -rf /var/cache/apk/*

COPY --from=ballerina-builder /src/target/bin/choreo_bal_test.jar /home/ballerina
RUN chown 10001 /home/ballerina/choreo_bal_test.jar

EXPOSE 9090
USER 10001

# hadolint ignore=DL3025
CMD java -XX:InitialRAMPercentage=50.0 -XX:+UseContainerSupport -XX:MinRAMPercentage=75.0 -XX:MaxRAMPercentage=75.0 -jar choreo_bal_test.jar
