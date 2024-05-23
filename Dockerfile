FROM quay.io/keycloak/keycloak:latest as builder

ENV KC_HEALTH_ENABLED=true
ENV KC_METRICS_ENABLED=true
ENV KC_HTTP_ENABLED=true
ENV KC_HTTP_PORT=${{PORT}}
ENV KC_HOSTNAME_STRICT=true
ENV KC_HOSTNAME_STRICT_BACKCHANNEL=true
ENV KC_HOSTNAME=${{RAILWAY_PUBLIC_DOMAIN}}

WORKDIR /opt/keycloak

# Build the Keycloak server
RUN /opt/keycloak/bin/kc.sh build

FROM quay.io/keycloak/keycloak:latest
COPY --from=builder /opt/keycloak/ /opt/keycloak/

# Entry point
ENTRYPOINT ["/opt/keycloak/bin/kc.sh"]