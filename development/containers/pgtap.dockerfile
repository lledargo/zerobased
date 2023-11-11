FROM docker.io/library/postgres:16

RUN apt-get update && \
  apt-get install postgresql-16-pgtap -y && \
  apt-get clean