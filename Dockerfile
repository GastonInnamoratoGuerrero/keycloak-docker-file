FROM quay.io/keycloak/keycloak:latest as builder

ARG HOSTNAME
ARG PORT
ENV KC_FEATURES=token-exchange

WORKDIR /opt/keycloak

# Build the Keycloak server
RUN /opt/keycloak/bin/kc.sh build

ENV PORT $PORT
ENV HOSTNAME $HOSTNAME

ENV KEYCLOAK_ADMIN=admin
ENV KEYCLOAK_ADMIN_PASSWORD=admin
ENV KC_HTTP_PORT=${PORT}
ENV KC_HTTP_HOST=0.0.0.0
ENV KC_PROXY=edge
ENV KC_HOSTNAME=${HOSTNAME}

EXPOSE $PORT
RUN echo "PORT: [$PORT]"

FROM quay.io/keycloak/keycloak:latest
COPY --from=builder /opt/keycloak/ /opt/keycloak/

# Entry point
ENTRYPOINT ["/opt/keycloak/bin/kc.sh"]