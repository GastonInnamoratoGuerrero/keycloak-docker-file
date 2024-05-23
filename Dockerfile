FROM quay.io/keycloak/keycloak:latest as builder

WORKDIR /opt/keycloak

# Build the Keycloak server
RUN /opt/keycloak/bin/kc.sh build

FROM quay.io/keycloak/keycloak:latest
COPY --from=builder /opt/keycloak/ /opt/keycloak/

# Entry point
ENTRYPOINT ["/opt/keycloak/bin/kc.sh"]