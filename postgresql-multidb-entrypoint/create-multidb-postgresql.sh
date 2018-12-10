#!/bin/bash

set -o errexit

VAR_DB_NAME_REGEX="DB$"

DATABASES=()
REQUIRED_ENV_VARS=($POSTGRES_USER)

for POSTGRES_MULTIDB_ENV_VAR in `echo ${!POSTGRES_MULTIDB_*}`
do
    if [[ "$POSTGRES_MULTIDB_ENV_VAR" =~ $VAR_DB_NAME_REGEX ]]
        then
        DATABASES+=(${!POSTGRES_MULTIDB_ENV_VAR})
    fi
done

readonly REQUIRED_ENV_VARS=(
    "POSTGRES_USER"
)

check_env_vars_set() {
    for required_env_var in ${REQUIRED_ENV_VARS[@]}
    do
        if [[ -z "${!required_env_var}" ]];
            then
            echo "Error:
Environment variable '$required_env_var' not set.
Make sure you have the following environment variables set:
${REQUIRED_ENV_VARS[@]}
Aborting."
            exit 1
        fi
    done
}

init_user_and_db() {
    for DATABASE in `echo ${DATABASES[@]}`
    do
        DB_NAME=$(echo "POSTGRES_MULTIDB_${DATABASE}_DB" | tr '[:lower:]' '[:upper:]')
        DB_USER=$(echo "POSTGRES_MULTIDB_${DATABASE}_USERNAME" | tr '[:lower:]' '[:upper:]')
        DB_PASS=$(echo "POSTGRES_MULTIDB_${DATABASE}_PASSWORD" | tr '[:lower:]' '[:upper:]')
        psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
CREATE USER ${!DB_USER} WITH PASSWORD '${!DB_PASS:=123456}';
CREATE DATABASE ${!DB_NAME};
GRANT ALL PRIVILEGES ON DATABASE ${!DB_NAME} TO ${!DB_USER};
EOSQL
    done
}

main() {
  check_env_vars_set
  init_user_and_db
}

main "$@"
