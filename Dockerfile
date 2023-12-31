# https://github.com/salesforcecli/cli/blob/64788175c5af5c35fa46c7b64d1ddf4c8b077bf9/dockerfiles/Dockerfile_full

FROM heroku/heroku:22

ENV DEBIAN_FRONTEND=noninteractive

# this will typically be nightly
ARG SF_CLI_VERSION=nightly

RUN echo 'b298a73a9fc07badfa9e4a2e86ed48824fc9201327cdc43e3f3f58b273c535e7  ./nodejs.tar.gz' > node-file-lock.sha \
    && curl -s -o nodejs.tar.gz https://nodejs.org/dist/v18.15.0/node-v18.15.0-linux-x64.tar.gz \
    && shasum --check node-file-lock.sha
RUN mkdir /usr/local/lib/nodejs \
    && tar xf nodejs.tar.gz -C /usr/local/lib/nodejs/ --strip-components 1 \
    && rm nodejs.tar.gz node-file-lock.sha

ENV PATH=/usr/local/lib/nodejs/bin:$PATH
RUN npm install --global @salesforce/cli@${SF_CLI_VERSION}

RUN apt-get update && apt-get install --assume-yes openjdk-11-jdk-headless jq
RUN apt-get autoremove --assume-yes \
    && apt-get clean --assume-yes \
    && rm -rf /var/lib/apt/lists/*

ENV SF_CONTAINER_MODE true
ENV SFDX_CONTAINER_MODE true
ENV DEBIAN_FRONTEND=dialog
ENV SHELL /bin/bash
