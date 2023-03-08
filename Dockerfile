ARG IMAGE
ARG TAG

FROM ${IMAGE} as parent
ENV MAVEN_CONFIG="" \
    W3SECURITY_INTEGRATION_NAME="DOCKER_W3SECURITY" \
    W3SECURITY_INTEGRATION_VERSION=${TAG} \
    W3SECURITY_CFG_DISABLESUGGESTIONS=true
WORKDIR /app
COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["w3security", "test"]


FROM ubuntu as w3security
RUN apt-get update  && apt-get install -y curl ca-certificates
RUN curl -o ./w3security-linux https://w3security.github.io/cli/latest/w3security-linux && \
    curl -o ./w3security-linux.sha256 https://w3security.github.io/cli/latest/w3security-linux.sha256 && \
    sha256sum -c w3security-linux.sha256 && \
    mv w3security-linux /usr/local/bin/w3security && \
    chmod +x /usr/local/bin/w3security

FROM alpine as w3security-alpine
RUN apk update && apk add --no-cache curl git
RUN curl -o ./w3security-alpine https://w3security.github.io/cli/latest/w3security-alpine && \
    curl -o ./w3security-alpine.sha256 https://w3security.github.io/cli/latest/w3security-alpine.sha256 && \
    sha256sum -c w3security-alpine.sha256 && \
    mv w3security-alpine /usr/local/bin/w3security && \
    chmod +x /usr/local/bin/w3security

FROM parent as alpine
RUN apk update && apk upgrade --no-cache
RUN apk add --no-cache libstdc++ git
COPY --from=w3security-alpine /usr/local/bin/w3security /usr/local/bin/w3security


FROM parent as linux
COPY --from=w3security /usr/local/bin/w3security /usr/local/bin/w3security
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y ca-certificates git
RUN apt-get auto-remove -y && apt-get clean -y && rm -rf /var/lib/apt/
