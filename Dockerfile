FROM quay.io/keycloak/keycloak:22.0.1 AS builder

# Set your build-time arguments if needed
ARG KC_HEALTH_ENABLED
ARG KC_METRICS_ENABLED
ARG KC_FEATURES
ARG KC_DB
ARG KC_HTTP_ENABLED
ARG PROXY_ADDRESS_FORWARDING
ARG QUARKUS_TRANSACTION_MANAGER_ENABLE_RECOVERY
ARG KC_HOSTNAME
ARG KC_LOG_LEVEL
ARG KC_DB_POOL_MIN_SIZE

# Add your custom JARs and themes if needed
ADD --chown=keycloak:keycloak https://github.com/klausbetz/apple-identity-provider-keycloak/releases/download/1.7.1/apple-identity-provider-1.7.1.jar /opt/keycloak/providers/apple-identity-provider-1.7.1.jar
ADD --chown=keycloak:keycloak https://github.com/wadahiro/keycloak-discord/releases/download/v0.5.0/keycloak-discord-0.5.0.jar /opt/keycloak/providers/keycloak-discord-0.5.0.jar
COPY /theme/keywind /opt/keycloak/themes/keywind

# Run Keycloak build if necessary
RUN /opt/keycloak/bin/kc.sh build

# Install additional binaries if needed
FROM fedora AS bins
RUN curl -fsSL https://github.com/caddyserver/caddy/releases/download/v2.7.4/caddy_2.7.4_linux_amd64.tar.gz | tar -zxvf - caddy
RUN curl -fsSL https://github.com/nicolas-van/multirun/releases/download/1.1.3/multirun-x86_64-linux-gnu-1.1.3.tar.gz | tar -zxvf - multirun

# Start a new stage
FROM quay.io/keycloak/keycloak:22.0.1

# Copy any additional configuration files if needed
COPY java.config /etc/crypto-policies/back-ends/java.config

# Copy files from previous stages
COPY --from=builder /opt/keycloak/ /opt/keycloak/
COPY --from=bins --chmod=0755 /multirun /usr/bin/multirun
COPY --from=bins --chmod=0755 /caddy /usr/bin/caddy

# Set the working directory
WORKDIR /app

# Copy your Caddyfile
COPY Caddyfile ./

# Set the entrypoint
ENTRYPOINT ["multirun"]

# Modify the CMD to start Keycloak and listen on the Railway-provided port
CMD ["/opt/keycloak/bin/kc.sh", "start", "--optimized", "--import-realm", "caddy", "run", "2>&1", "-Djboss.http.port=${PORT}", "-Djboss.bind.address=0.0.0.0:${PORT}"]