DROP TABLE IF EXISTS tmp_bg;
CREATE TABLE tmp_bg (
	col_a TEXT,
	col_b TEXT,
	col_c INT,
	col_d TEXT,
	col_e TEXT,
	col_f TEXT
);

DROP TABLE IF EXISTS bezirksgrenzen;
CREATE TABLE bezirksgrenzen (
	gml_id TEXT NULL
	, gemeinde_name TEXT NOT NULL
	, gemeinde_schluessel INT NOT NULL
);

DROP TABLE IF EXISTS tmp_lor;
CREATE TABLE tmp_lor (
	col_a TEXT,
	col_b TEXT,
	col_c TEXT,
	col_d TEXT,
	col_e TEXT,
	col_f TEXT,
	col_g TEXT,
	col_h TEXT,
	col_i TEXT,
	col_j TEXT,
	col_k TEXT,
	col_l INT,
	col_m TEXT,
	col_n INT,
	col_o TEXT,
	col_p FLOAT
);

DROP TABLE IF EXISTS lor_planungsraeume_2021;

CREATE TABLE lor_planungsraeume_2021 (
	PLR_ID INT NOT NULL PRIMARY KEY
	, PLR_NAME TEXT NOT NULL
	, BEZ INT NOT NULL
	, GROESSE_M2 FLOAT NOT NULL
);

DROP TABLE IF EXISTS tmp_fd;

CREATE TABLE tmp_fd (
	col_a DATE,
	col_b DATE,
	col_c TIME,
	col_d DATE,
	col_e TIME,
	col_f INT,
	col_g INT,
	col_h TEXT,
	col_i TEXT,
	col_j TEXT,
	col_k TEXT
);
DROP TABLE IF EXISTS fahrraddiebstahl;

CREATE TABLE fahrraddiebstahl (
	ANGELEGT_AM DATE NOT NULL
	, TATZEIT_ANFANG_DATUM DATE NOT NULL
	, TATZEIT_ANFANG_STUNDE	TIME NOT NULL
	, TATZEIT_ENDE_DATUM DATE NOT NULL
	, TATZEIT_ENDE_STUNDE TIME NOT NULL
	, LOR INT NOT NULL
	, SCHADENSHOEHE INT NULL
	, VERSUCH TEXT NULL
	, ART_DES_FAHRRADS TEXT NULL
	, DELIKT TEXT NULL
	, ERFASSUNGSGRUND TEXT NULL
);

