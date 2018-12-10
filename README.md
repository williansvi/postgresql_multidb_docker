# postgresql_multidb_docker
Create multiple databases in a single postgresql docker container using just environment variables. No need to build custom images, just respect semantics:

POSTGRES_MULTIDB_<db_name>_DB

POSTGRES_MULTIDB_<db_name>_USERNAME

POSTGRES_MULTIDB_<db_name>_PASSWORD

Inspired by:
- https://github.com/mrts/docker-postgresql-multiple-databases
- https://medium.com/@beld_pro/quick-tip-creating-a-postgresql-container-with-default-user-and-password-8bb2adb82342
