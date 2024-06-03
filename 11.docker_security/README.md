# Практическая работа

Переходим в каталог `docker_course/practice/11.docker_security`

## Привилегированные контейнеры

```docker run --privileged --rm -it nginx bash```
```mkdir /mnt/hdd & mount /dev/sda1 /mnt/hdd```
Видим хостовую файловую систему

## Distroless контейнеры

Проверяем наличие утилит в контейнерах

```bash
docker run --rm -it --entrypoint bash gcr.io/distroless/java-debian10 
docker run --rm -it gcr.io/distroless/java-debian10 apt install bash
docker run --rm -it gcr.io/distroless/java-debian10 ping ya.ru
```

## Собираем контейнер from:scratch

Смотрим докерфайл, демонстрирующий сборку from:scratch
```сat Dockerfile```

```ls -lrt```
смотрим размер файла hello

```bash
docker build --tag hello .
docker image ls hello - размер такой же как у бинаря
docker run --rm hello
```
