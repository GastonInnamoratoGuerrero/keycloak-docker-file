FROM quay.io/keycloak/keycloak:latest as builder

# Enable health and metrics support
ENV KC_HEALTH_ENABLED=true
ENV KC_METRICS_ENABLED=true

WORKDIR /opt/keycloak

# Build the Keycloak server
RUN /opt/keycloak/bin/kc.sh build

FROM quay.io/keycloak/keycloak:latest

COPY --from=builder /opt/keycloak/ /opt/keycloak/

# Set environment variables for H2 database
# ENV KC_DB=h2

# H2 does not require database connection settings, so these can be omitted

# Set the hostname to 0.0.0.0 to listen on all network interfaces
ENV KC_HOSTNAME=0.0.0.0

# Set Keycloak to listen on the Railway-provided port
ENV PORT=$PORT

# Entry point
ENTRYPOINT ["/opt/keycloak/bin/kc.sh", "-b", "0.0.0.0"]