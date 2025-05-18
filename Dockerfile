FROM ubuntu:14.04

ENV DEBIAN_FRONTEND=noninteractive \
    HPGCC3=/hpgcc3 \
    PATH=$PATH:/hpgcc3/bin

RUN apt-get update && apt-get -y upgrade && apt-get clean
RUN apt-get install -y --force-yes \
    build-essential \
    gcc-arm-none-eabi \
    libelf-dev \
    make \
    python \
    python-pip \
    python-dev \
    runit \
    unzip \
    wget \
    curl &&\
    apt-get clean

COPY deps /tmp/deps
RUN pip install /tmp/deps/MarkupSafe*.tar.gz && \
    pip install /tmp/deps/Jinja2*.tar.gz

COPY amake.sh conf.py entrypoint.sh hpgcc.sh install_hpgcc.sh makefile /hpgcc3/
COPY subdir.tmpl /hpgcc3/templates/

RUN bash /hpgcc3/install_hpgcc.sh && mkdir /work

WORKDIR /work
ENTRYPOINT ["/hpgcc3/entrypoint.sh"]
