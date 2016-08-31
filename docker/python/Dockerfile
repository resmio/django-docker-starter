FROM python:3.6
MAINTAINER niels.busch@gmail.com

COPY requirements.txt /tmp/requirements.txt

# Install requirements.txt
RUN pip install -r /tmp/requirements.txt --src .

EXPOSE 8000

VOLUME ["/src"]
WORKDIR /src
