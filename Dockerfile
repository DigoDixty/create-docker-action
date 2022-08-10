FROM python:3.10.5-slim-buster
WORKDIR /usr/app

RUN apt-get update \
  && apt-get install -y --no-install-recommends git \
  && apt-get purge -y --auto-remove \
  && rm -rf /var/lib/apt/lists/*

ENV \
  DBT_PROFILES_DIR=/usr/app/.dbt/profiles \
  DBT_MODULES_DIR=/usr/app/.dbt/modules

COPY \
  ./Pipfile \
  ./Pipfile.lock \
  ./

RUN \
  pip install --upgrade pip pipenv && \
  pipenv install --dev --system --deploy

COPY ./profiles.yml ${DBT_PROFILES_DIR}/profiles.yml

COPY \
  ./dbt_project.yml \
  ./packages.yml \
  ./

COPY . ./

RUN ls -la

#RUN cat ${DBT_PROFILES_DIR}/profiles.yml
#RUN dbt deps
#RUN dbt debug --config-dir
#RUN dbt seed

#RUN dbt run
#CMD ["dbt", "run"]

