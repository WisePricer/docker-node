FROM node
MAINTAINER Steven Nemetz

###
### Example Dockerfile for CI testing
###

# Add all build commands here

ARG BUILD_DATE=2000-01-01
ARG BUILD_NUMBER=1
ARG BUILD_TAG=dev
ARG BUILD_URL=dev
ARG GIT_COMMIT=dev
ARG GIT_URL=dev
ARG JOB_NAME=dev
ARG REPOSITORY=dev/proj
ARG VERSION=0.0.1
LABEL org.label-schema.build-date="${BUILD_DATE}" \
 org.label-schema.name="${REPOSITORY}" \
 org.label-schema.description="Example NodeJS" \
 org.label-schema.vendor="devops-workflow" \
 org.label-schema.version="${VERSION}" \
 org.label-schema.vcs-ref="${GIT_COMMIT}" \
 org.label-schema.vcs-url="${GIT_URL}" \
 org.label-schema.schema-version="1.0" \
 com.corp.jenkins-job="${JOB_NAME}" \
 com.corp.jenkins-build="${BUILD_NUMBER}" \
 com.corp.jenkins-build-tag="${BUILD_TAG}" \
 com.corp.jenkins-build-url="${BUILD_URL}"

