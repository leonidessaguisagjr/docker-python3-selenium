FROM python:3.7.4
LABEL maintainer="Leonides T. Saguisag Jr. <leonidessaguisagjr@gmail.com>"

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get clean

RUN apt-get update \
    && apt-get clean \
    && apt-get install -qy firefox-esr

RUN echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list \
    && curl -fsSL https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && apt-get update \
    && apt-get install -qy google-chrome-stable

WORKDIR /tmp/

RUN pip3 install --upgrade pip setuptools

RUN pip3 install --no-cache-dir selenium \
    && python3 -m venv .venv \
    && /bin/bash -c "source .venv/bin/activate \
    && pip3 install --upgrade pip setuptools \
    && pip3 install --no-cache-dir webdriverdownloader \
    && webdriverdownloader chrome firefox \
    && deactivate \
    && rm -rf .venv/" \
    && apt autoclean \
    && apt-get clean \
    && apt autoremove

RUN useradd -ms /bin/bash tester

USER tester

WORKDIR /home/tester

CMD [ "/bin/bash" ]
