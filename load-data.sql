SET datestyle = 'ISO, DMY';

/************************

CREATE the fahrraddiebstahl table

************************/

TRUNCATE TABLE tmp_fd;

TRUNCATE TABLE fahrraddiebstahl CASCADE;
DROP INDEX IF EXISTS idx_fahrraddiebstahl;

\copy tmp_fd FROM 'download/Fahrraddiebstahl.csv' WITH (DELIMITER ',', FORMAT csv, HEADER, ENCODING 'latin1');

INSERT INTO fahrraddiebstahl (ANGELEGT_AM, TATZEIT_ANFANG_DATUM, TATZEIT_ANFANG_STUNDE, TATZEIT_ENDE_DATUM, TATZEIT_ENDE_STUNDE, LOR, SCHADENSHOEHE, VERSUCH, ART_DES_FAHRRADS,	DELIKT,	ERFASSUNGSGRUND) SELECT col_a, col_b, col_c, col_d, col_e, col_f, col_g, col_h, col_i, col_j, col_k FROM tmp_fd;


/************************

CREATE the bezirksgrenzen table

************************/

TRUNCATE TABLE tmp_bg;


TRUNCATE TABLE bezirksgrenzen CASCADE;
DROP INDEX IF EXISTS idx_bezirksgrenzen;

\copy tmp_bg FROM 'download/bezirksgrenzen.csv' WITH DELIMITER ',' CSV HEADER ENCODING 'latin1';

INSERT INTO bezirksgrenzen (gml_id, gemeinde_name, gemeinde_schluessel) SELECT col_a, col_b, col_c FROM tmp_bg;

/************************

Create the lor_planungsraeume_2021 table

************************/

TRUNCATE TABLE lor_planungsraeume_2021 CASCADE;
DROP INDEX IF EXISTS idx_lor_planungsraeume_2021;

TRUNCATE TABLE tmp_lor CASCADE;

\copy tmp_lor FROM './download/lor_planungsraeume_2021.csv' WITH (DELIMITER ',', FORMAT csv, HEADER, ENCODING 'latin1');

INSERT INTO lor_planungsraeume_2021 (PLR_ID, PLR_NAME, BEZ, GROESSE_M2) SELECT col_l, col_m, col_n, col_p FROM tmp_lor;


/************************

Erase temporary tables

************************/

DROP TABLE tmp_lor;
DROP TABLE tmp_fd;
DROP TABLE tmp_bg;

/************************

Create Index

************************/
CREATE INDEX idx_lor_planungsraeume_2021  ON  lor_planungsraeume_2021 (PLR_ID ASC);
CLUSTER lor_planungsraeume_2021 USING idx_lor_planungsraeume_2021;

/* CREATE INDEX  idx_fahrraddiebstahl ON fahrraddiebstahl ( ASC);
CLUSTER fahrraddiebstahl USING idx_fahrraddiebstahl;
*/
/*CREATE INDEX  idx_bezirksgrenzen ON bezirksgrenzen (gemeinde_schuessel ASC);
CLUSTER bezirksgrenzen USING idx_bezirksgrenzen;
*/
