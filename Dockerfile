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
