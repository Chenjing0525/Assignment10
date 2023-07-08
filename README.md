# Assignment10

## installation

### Requirements

first install python and postgres

then run the command:

```sh
sudo -u postgres psql
```

```sql
create the USER and the database:
CREATE USER dbs_user WITH PASSWORD 'password' CREATEDB;
CREATE DATABASE dbs_project;
CREATE SCHEMA "dbs_schema";
\q
```
then you only have to launch the makefile:
```sh
make all
```
