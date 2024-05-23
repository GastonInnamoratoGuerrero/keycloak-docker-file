FROM quay.io/keycloak/keycloak:latest as builder

#ARG DB_URL
#ARG DB_USERNAME
#ARG DB_PASSWORD
ARG HOSTNAME
# Railway should automatically specify this port
ARG PORT

ENV KC_HEALTH_ENABLED=true
ENV KC_METRICS_ENABLED=true
ENV KC_FEATURES=token-exchange
ENV KC_DB=mysql

RUN /opt/keycloak/bin/kc.sh build --db=mysql

ENV KEYCLOAK_ADMIN=admin
ENV KEYCLOAK_ADMIN_PASSWORD=admin

ENV KC_HTTP_PORT=${PORT}
ENV KC_HTTP_HOST=0.0.0.0
ENV KC_PROXY=edge

ENV KC_DB_URL=mysql://root:aVEkQCvLGsyHdqMZHXgQLPiTkCttVYRV@monorail.proxy.rlwy.net:28728/railway
ENV KC_DB_USERNAME=root
ENV KC_DB_PASSWORD=aVEkQCvLGsyHdqMZHXgQLPiTkCttVYRV
ENV KC_HOSTNAME=${HOSTNAME}