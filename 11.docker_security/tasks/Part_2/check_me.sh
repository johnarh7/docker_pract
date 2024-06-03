#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

yum install libcap-ng-utils -y > /dev/null

echo "Проверяем..."

# Проверяем запущен ли контейнер nginx-uncap
echo "проверяем запущен ли контейнер с cadvisor"
    if curl localhost:80 && docker container ls |grep nginx-uncap; then
        echo -e "${GREEN}Контейнер nginx-uncap запущен и отвечает."
    else
        echo -e "${RED}Контейнер nginx-uncap НЕ запущен или НЕ отвечает по порту 80."
    fi

# Проверяем capabilities контейнера nginx-cap
echo "Проверяем capabilities контейнера nginx-cap"
    if pscap |grep $(docker inspect -f '{{.State.Pid}}' nginx-cap) | grep "chown, setgid, setuid, net_bind_service" |grep -v "dac_override\|kill\|net_raw\|setfcap" > /dev/null ; then
        echo -e "${GREEN}Контейнер nginx-cap имеет только нужные capabilities: chown, setgid, setuid, net_bind_service"
    else
        echo -e "${RED}Контейнер nginx-cap имеет избыточные capabilities, либо не запущен"
    fi
echo "-----------------------------------------------------"
# Проверяем запущен ли контейнер nginx-rootless
echo "проверяем запущен ли контейнер с cadvisor"
    if curl localhost:8080 && docker container ls |grep nginx-uncap; then
        echo -e "${GREEN}Контейнер nginx-rootless запущен и отвечает."
    else
        echo -e "${RED}Контейнер nginx-rootless НЕ запущен или НЕ отвечает по порту 8080."

# Проверяем пользователя в контейнере nginx-rootless
echo "Проверяем пользователя в контейнере nginx-rootless"
    if docker exec nginx-rootless whoami |grep nginx ; then
        echo -e "${GREEN}Контейнер nginx-rootless запущен использует пользователя nginx"
    else
        echo -e "${RED}Контейнер nginx-cap использует пользователя, отличного от nginx, либо не запущен"
    fi
echo "-----------------------------------------------------"

# Проверяем запущен ли контейнер nginx-rootless-uncap
echo "Проверяем запущен ли контейнер nginx-rootless-uncap"
    if curl localhost:8081 && docker container ls |grep nginx-rootless-uncap; then
        echo -e "${GREEN}Контейнер nginx-rootless-uncap запущен и отвечает."
    else
        echo -e "${RED}Контейнер nginx-rootless-uncap НЕ запущен или НЕ отвечает по порту 8081."
    fi

# Проверяем capabilities контейнера nginx-cap
echo "Проверяем capabilities контейнера nginx-rootless-uncap"
    if test $(cat /proc/$(docker inspect -f '{{.State.Pid}}' nginx-rootless-uncap)/status  |grep Cap |grep 0000000000000000| wc -l) -eq 5; then
        echo -e "${GREEN}Контейнер nginx-rootless-uncap имеет только нужные capabilities, то есть никаких."
    else
        echo -e "${RED}Контейнер nginx-rootless-uncap имеет избыточные capabilities, либо не запущен"
    fi