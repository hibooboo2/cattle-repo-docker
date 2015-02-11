FROM rancher/docker-dind-base:latest

MAINTAINER Bill Maxwell "<bill@rancher.com>"

COPY ./scripts /opt/cattle/scripts
RUN /opt/cattle/scripts/bootstrap
RUN /opt/cattle/scripts/git-manager

VOLUME /opt/cattle

WORKDIR /opt/cattle

EXPOSE 8080
ENV CATTLE_IDEMPOTENT_CHECKS false

CMD [ "/opt/cattle/scripts/run" ]
