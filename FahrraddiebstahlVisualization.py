import streamlit as st
from streamlit_folium import st_folium
import folium
import pandas as pd
import geopandas as gpd
import json
import psycopg2
from psycopg2 import sql
from pyproj import CRS
import matplotlib.pyplot as plt
conn = psycopg2.connect(
    host="localhost",
    database="DBSProject",
    user="postgres",
    password="123456"
)


st.header("Fahrraddiebstähle in Berlin visualisiert")

visualization = st.radio(
    "Die Auswahl der Beobachtungseinheit: ",
    ('Gemeinde', 'Raumhierarchie im RBS'))
def display_map(data,id,value,key,locations,type):
    geodata = gpd.read_file("C:/Users/Jutta/Downloads/Assignment10/lor_planungsraeume_2021.gml")
    crs = CRS.from_epsg(4326)  
    geodata = geodata.to_crs(crs)
    map = folium.Map(location=[52.520008, 13.404954], zoom_start=10, tiles='CartoDB positron')
    choropleth = folium.Choropleth(
        geo_data = geodata,
        name="choropleth",
        data = data,
        columns = [id, value],
        key_on = key,
        fill_color='YlGn',
        fill_opacity=0.7,
        line_opacity=0.8,
        legend_name='Fahrraddiebstahlanzahl',
        highlight=True,
    )
    choropleth.geojson.add_to(map)
    data = data.set_index(id)
    for feature in choropleth.geojson.data['features']:
        location = feature['properties'][locations]
        feature['properties']['Fahrraddiebstahlanzahl'] = ' :' + str(data.loc[location,'fahrraddiebstahlanzahl'] if location in list(data.index) else 'NOT AVILABLE')
        feature['properties']['Total_Schadenshoehe'] = ' :' + str(data.loc[location,'total_schadenshoehe'] if location in list(data.index) else 'NOT AVILABLE')
        if type == 'Gemeinde':
            feature['properties']['Gml_id'] = ' :' + str(data.loc[location,'gml_id'] if location in list(data.index) else 'NOT AVILABLE')
            feature['properties']['Gemeinde_name'] = ' :' + str(data.loc[location,'gemeinde_name'] if location in list(data.index) else 'NOT AVILABLE')
            


    if type == 'Gemeinde':
        choropleth.geojson.add_child(
        folium.features.GeoJsonTooltip(['BEZ','Fahrraddiebstahlanzahl','Total_Schadenshoehe','Gml_id','Gemeinde_name'])
        )
    else:
        choropleth.geojson.add_child(
        folium.features.GeoJsonTooltip(['PLR_ID','PLR_NAME','BEZ','GROESSE_M2','Fahrraddiebstahlanzahl','Total_Schadenshoehe'])
        )
    
    
    st_folium(map, width=700,height=450)


if visualization == 'Gemeinde':
    cursor = conn.cursor()
    query = "SELECT SUM(f.schadenshoehe) AS Total_Schadenshoehe, COUNT(*) AS Fahrraddiebstahlanzahl, l.bez, b.gemeinde_name, b.gml_id FROM fahrraddiebstahl f INNER JOIN lor_planungsraeume_2021 l ON f.lor = l.plr_id Inner Join bezirksgrenzen b ON l.bez = b.gemeinde_schluessel GROUP BY l.bez, b.gemeinde_name, b.gml_id "
    data_bez = pd.read_sql(query, conn)
    cursor.close()
    conn.close()
    display_map(data_bez,'bez','fahrraddiebstahlanzahl','feature.properties.BEZ','BEZ','Gemeinde')
else:
    cursor = conn.cursor()
    query = "SELECT SUM(f.schadenshoehe) AS Total_Schadenshoehe, COUNT(*) AS Fahrraddiebstahlanzahl, l.plr_id, l.plr_name, l.bez, l.groesse_m2 FROM fahrraddiebstahl f INNER JOIN lor_planungsraeume_2021 l ON f.lor = l.plr_id GROUP BY l.plr_id "
    data_plr = pd.read_sql(query, conn)
    cursor.close()
    conn.close()
    display_map(data_plr,'plr_id','fahrraddiebstahlanzahl','feature.properties.PLR_ID','PLR_ID','Raumhierarchie im RBS')
    
    




















