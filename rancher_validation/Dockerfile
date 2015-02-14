FROM rancher/dind:v0.1.0
COPY ./ /source/
RUN git clone https://github.com/rancherio/build-master-scripts.git
ENTRYPOINT ["/source/rancher_validation/build_env.sh"]