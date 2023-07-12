.DEFAULT := help
.PHONY := help all db-clean db-build

USER=dbs_user
DATABASE=dbs_project
SCHEMA=dbs_schema
PG_CONFIG=host=localhost user=$(USER) dbname=$(DATABASE) 
PG_CONFIG_SCHEMA=$(PG_CONFIG) options=--search_path=$(SCHEMA)


all: downloader correction db-clean db-build deps-install launch ## Execute db-clean and db-build


downloader: ## Download all csv files
	echo "Set up download environment :"
	rm -rf download/*
	echo "Download lor_planungsraueme_2021.csv"
	wget --no-check-certificate 'https://tsb-opendata.s3.eu-central-1.amazonaws.com/lor_planungsgraeume_2021/lor_planungsraeume_2021.csv' -P download/
	echo "Download bezirksgrenzen.csv"
	wget --no-check-certificate 'https://tsb-opendata.s3.eu-central-1.amazonaws.com/bezirksgrenzen/bezirksgrenzen.csv' -P download/
	echo "Download Fahrraddiebstahl.csv"
	wget --no-check-certificate 'https://www.polizei-berlin.eu/Fahrraddiebstahl/Fahrraddiebstahl.csv' -P download/

correction: 
	LC_CTYPE=C sed -ni '' 's/\(.*\),\(.*\),\(.*\),\(.*\),\(.*\),\(.*\),\(.*\),\(.*\),\(.*\),\(.*\),\(.*\)/\1,\2,\3:00:00,\4,\5:00:00,\6,\7,\8,\9,\10,\11/p' ./download/Fahrraddiebstahl.csv 
	LC_CTYPE=C sed -i '' 's/\r$///' ./download/Fahrraddiebstahl.csv

db-clean: ## Remove all previous installation
	psql "$(PG_CONFIG_SCHEMA)" -c "DROP TABLE IF EXISTS Fahrraddiebstahl;"
	psql "$(PG_CONFIG_SCHEMA)" -c "DROP TABLE IF EXISTS bezirksgrenzen;"
	psql "$(PG_CONFIG_SCHEMA)" -c "DROP TABLE IF EXISTS lor_planungsraueme_2021;"

db-build: ## Build from scratch the database
	psql "$(PG_CONFIG)" -c 'DROP SCHEMA IF EXISTS "$(SCHEMA)" CASCADE;'
	psql "$(PG_CONFIG)" -c 'CREATE SCHEMA "$(SCHEMA)";'
	psql "$(PG_CONFIG_SCHEMA)" -f "create-table.sql"
	psql "$(PG_CONFIG_SCHEMA)" -f "load-data.sql"

deps-install: ## Install dependencies
	pip install -r requirements.txt

deps-uninstall: ## Uninstall dependencies
	pip uninstall -y -r requirements.txt
launch:
	streamlit run FahrraddiebstahlVisualization.py
