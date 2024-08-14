FROM python:3.11-alpine3.19

LABEL maintainer='twinis'

# python 0:1 = False:True
# 컨테이너에 찍히는 로그를 볼 수 있도록 허용함
# 도커 컨테이너에서 어떤 일이 일어나고 있는지 알 수 있도록 함 -> 디버깅 가능
# 실시간으로 볼 수 있기 때문에 컨테이너 관리가 편해짐
ENV PYTHONUNBUFFERED=1

COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app

WORKDIR /app
EXPOSE 8000

ARG DEV False

RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = True ]; \
        then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    rm -rf /tmp && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user

ENV PATH="/py/bin:$PATH"
USER django-user
