FROM quay.io/keycloak/keycloak:latest as builder

ENV KC_HEALTH_ENABLED=true
ENV KC_METRICS_ENABLED=true
ENV KC_FEATURES=token-exchange

# Configure a database vendor
ENV KC_DB=mysql

WORKDIR /opt/keycloak

# Build the Keycloak server
RUN /opt/keycloak/bin/kc.sh build

ENV KEYCLOAK_ADMIN=admin
ENV KEYCLOAK_ADMIN_PASSWORD=admin
ENV KC_HTTP_PORT=8080
ENV KC_HTTP_HOST=0.0.0.0


EXPOSE 8080

FROM quay.io/keycloak/keycloak:latest
COPY --from=builder /opt/keycloak/ /opt/keycloak/

ENV KC_DB=mysql
ENV KC_DB_URL=mysql://root:aVEkQCvLGsyHdqMZHXgQLPiTkCttVYRV@monorail.proxy.rlwy.net:28728/railway
ENV KC_DB_USERNAME=root
ENV KC_DB_PASSWORD=aVEkQCvLGsyHdqMZHXgQLPiTkCttVYRV
ENV KC_HOSTNAME=${{RAILWAY_PUBLIC_DOMAIN}}
# Entry point
ENTRYPOINT ["/opt/keycloak/bin/kc.sh"]