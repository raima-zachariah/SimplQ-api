FROM alpine:3.7

ENV ALPINE_VERSION=3.7

ENV PACKAGES="python3 ca-certificates uwsgi-python3 gcc libc-dev linux-headers python3-dev bash"
ENV FLASK_APP="simpleq"
ENV PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
ENV simpleq_SETTINGS="settings.cfg"
RUN echo "http://dl-cdn.alpinelinux.org/alpine/v$ALPINE_VERSION/testing" > /etc/apk/repositories \
  && echo "http://dl-cdn.alpinelinux.org/alpine/v$ALPINE_VERSION/community" >> /etc/apk/repositories \
  && echo "http://dl-cdn.alpinelinux.org/alpine/v$ALPINE_VERSION/main" >> /etc/apk/repositories \
  && apk add --no-cache $PACKAGES || \
    (sed -i -e 's/dl-cdn/dl-4/g' /etc/apk/repositories && apk add --update --no-cache $PACKAGES) \
  && echo "http://dl-cdn.alpinelinux.org/alpine/v$ALPINE_VERSION/main/" > /etc/apk/repositories \
  && if [[ ! -e /usr/bin/python ]];        then ln -sf /usr/bin/python3 /usr/bin/python; fi \
  && if [[ ! -e /usr/bin/python-config ]]; then ln -sf /usr/bin/python-config3 /usr/bin/python-config; fi \
  && if [[ ! -e /usr/bin/idle ]];          then ln -sf /usr/bin/idle3 /usr/bin/idle; fi \
  && if [[ ! -e /usr/bin/pydoc ]];         then ln -sf /usr/bin/pydoc3 /usr/bin/pydoc; fi \
  && if [[ ! -e /usr/bin/easy_install ]];  then ln -sf $(ls /usr/bin/easy_install*) /usr/bin/easy_install; fi \
  && easy_install pip \
  && pip install --upgrade pip \
  && if [[ ! -e /usr/bin/pip ]]; then ln -sf /usr/bin/pip3 /usr/bin/pip; fi \
  && pip install pipenv

COPY dist/simpleq/ /app

WORKDIR /app

RUN pipenv --three --bare install -e .

CMD ["pipenv", "run", "uwsgi", "--http-socket", "0.0.0.0:3040", "--plugins", "python3", "--module", "simpleq:application"]
