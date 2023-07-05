import streamlit as st
from streamlit_folium import folium_static
import folium
import pandas as pd
import requests
import json

st.header("Fahrraddiebstähle in Berlin visualisiert")
bezirksgrenzen = pd.read_csv('C:/Users/Jutta/Downloads/Assignment10/bezirksgrenzen.csv')
Fahrraddiebstahl=pd.read_csv('C:/Users/Jutta/Downloads/Assignment10/Fahrraddiebstahl.csv',encoding='latin-1')
lor_planungsraeume_2021=pd.read_csv('C:/Users/Jutta/Downloads/Assignment10/lor_planungsraeume_2021.csv',encoding='utf-8')
lor_planungsraeume_2021 = lor_planungsraeume_2021.drop(columns=['Name', 'description', 'timestamp','begin','end','altitudeMode','drawOrder','icon'])
count_df = Fahrraddiebstahl.groupby('LOR').size().reset_index(name='Fahrraddiebstahlanzahl')
merged_df = lor_planungsraeume_2021.merge(count_df, left_on='PLR_ID', right_on='LOR', how='inner')
merged_df = merged_df.drop(columns=['LOR'])
merged_df_new = merged_df
merged_df_new['Fahrraddiebstahlanzahl'] = merged_df_new.groupby('BEZ')['Fahrraddiebstahlanzahl'].transform('sum')
merged_df_new['GROESSE_M2'] = merged_df_new.groupby('BEZ')['GROESSE_M2'].transform('sum')
merged_df_new_bez = merged_df_new.merge(bezirksgrenzen, left_on='BEZ', right_on='Gemeinde_schluessel', how='inner')
merged_df_new_bez = merged_df_new_bez.drop(columns=['BEZ'])

visualization = st.radio(
    "Die Auswahl der Beobachtungseinheit: ",
    ('Gemeinde', 'Raumhierarchie im RBS'))

with open ('C:/Users/Jutta/Downloads/lor_planungsraeume_2021.geojson', 'r') as jsonFile:
    geo_data = json.load(jsonFile)

if visualization == 'Gemeinde':
    map = folium.Map(location=[52.520008, 13.404954], zoom_start=10)
    choropleth = folium.Choropleth(
        geo_data = folium.GeoJson("https://tsb-opendata.s3.eu-central-1.amazonaws.com/lor_planungsgraeume_2021/lor_planungsraeume_2021.geojson"),
        name="choropleth",
        data = merged_df_new_bez,
        columns = ['Gemeinde_schluessel', 'Fahrraddiebstahlanzahl'],
        key_on ='feature.properties.BEZ',
        fill_color='YlOrRd',
        fill_opacity=0.7,
        line_opacity=0.2,
        legend_name='Fahrraddiebstahlanzahl', 
        highlight=True,
    ).add_to(map)

    choropleth.geojson.add_child(
        folium.features.GeoJsonTooltip(fields=['BEZ'])
    )
    
    folium_static(map)
else:
    map = folium.Map(location=[52.520008, 13.404954], zoom_start=10)
    choropleth = folium.Choropleth(
        geo_data = geo_data,
        name="choropleth",
        data = merged_df,
        columns = ['PLR_ID', 'Fahrraddiebstahlanzahl'],
        key_on ='feature.properties.PLR_ID',
        fill_color='YlGn',
        fill_opacity=0.7,
        line_opacity=0.2,
        legend_name='Fahrraddiebstahlanzahl',
        highlight=True,
    ).add_to(map)
    folium_static(map)
















