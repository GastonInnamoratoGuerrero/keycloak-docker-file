FROM quay.io/keycloak/keycloak:latest as builder

# Enable health and metrics support
ENV KC_HEALTH_ENABLED=true
ENV KC_METRICS_ENABLED=true

WORKDIR /opt/keycloak

# Configure a database vendor
ENV KC_DB=h2

# Build the Keycloak server
RUN /opt/keycloak/bin/kc.sh build

FROM quay.io/keycloak/keycloak:latest

COPY --from=builder /opt/keycloak/ /opt/keycloak/

# Set environment variables for H2 database
ENV KC_DB=h2

# H2 does not require database connection settings, so these can be omitted

# Set the hostname to localhost
ENV KC_HOSTNAME=localhost

# Set Keycloak to listen on the Railway-provided port
ENV PORT=$PORT
ENV BIND=0.0.0.0

# Entry point
ENTRYPOINT ["/opt/keycloak/bin/kc.sh", "-b", "0.0.0.0"]