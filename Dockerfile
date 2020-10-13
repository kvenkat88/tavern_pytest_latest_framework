ARG PYTHON_BASE_IMAGE="python:3.8-alpine"
FROM ${PYTHON_BASE_IMAGE}
MAINTAINER HPS Cloud Services

ARG TESTFLOW_USER_HOME=/usr/local/testflow
ARG TESTFLOW_GROUP="testflow"
ARG TESTFLOW_USER="testflow"

RUN addgroup -S ${TESTFLOW_GROUP} \
        && adduser -S -G ${TESTFLOW_GROUP} ${TESTFLOW_USER} -s "/bin/bash"

# https://vsupalov.com/build-docker-image-clone-private-repo-ssh-key/
# https://stackoverflow.com/questions/23391839/clone-private-git-repo-with-dockerfile

# HOST_IP value should be like http://0.0.0.0:5003 or http://localhost:5003 when ENV_TYPE == local
# HOST_IP value should be like https://0.0.0.0:5003 or https://assd.domain.com when ENV_TYPE == api_gateway
# ENV EXEC_FOR=${EXEC_FOR:-all} - set a default in case the ARG isn't passed
# ENV TEST_TYPE=${TEST_TYPE:-bulk} - set a default in case the ARG isn't passed and this will run all web services categories available and we can provide specific web service category also.
# Other ENV_TYPE possible value is api_gateway. If we want to invoke api_gateway URL tests, then this argument is mandatory.

ENV TESTFLOW_HOME=${TESTFLOW_USER_HOME} \
    TESTFLOW_USER=${TESTFLOW_USER} \
    TESTFLOW_GROUP=${TESTFLOW_GROUP} \
    PYTHONDONTWRITEBYTECODE=true

RUN set -ex \
    apk update && apk upgrade -f \
    && apk add --no-cache \
    curl \
    git \
    bash \
    tini \
    && python -m pip install --no-cache --upgrade pip setuptools wheel \
    && rm -rf \
       /var/cache/apk/* \
       /tmp/* \
       /var/tmp/* \
       /usr/share/man \
       /usr/share/doc

WORKDIR ${TESTFLOW_HOME}
COPY . ${TESTFLOW_HOME}

# Ensure our user has ownership to TESTFLOW_HOME
RUN chown -R ${TESTFLOW_USER}:${TESTFLOW_GROUP} ${TESTFLOW_HOME}
RUN python -m pip install --upgrade --no-cache -r requirements.txt \
    && chmod +x ./generalized_runner.sh

# https://phoenixnap.com/kb/docker-cmd-vs-entrypoint
# ENTRYPOINT will automatically pass the commandline args or parameters to generalized_runner.sh
ENTRYPOINT ["tini","--","./generalized_runner.sh"]
#CMD ["${EXEC_FOR}", "${TEST_TYPE}","${ENV_TYPE}"]
