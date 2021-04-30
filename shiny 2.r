library(leaflet)
library(leafem)
library(mapview)

#create the map

my_map <- leaflet() %>%
  addTiles() %>%  # Add default OpenStreetMap map tiles
  addMarkers(lng=-1.6178, lat=54.9783, popup="World's most important city!")

my_map  # Display the map in Viewer window

#multiple backdrop maps

#this will show the satellite map overlain with the main rods and the names of the main roads
leaflet() %>% 
  addTiles() %>%  
  addCircleMarkers(lng=-1.6178, lat=54.9783,
                   popup="The world's most important city!",
                   radius = 10, color = "red") %>% 
  addProviderTiles(providers$Esri.WorldImagery) %>% 
  addProviderTiles(providers$Stamen.TonerLines,
                   options = providerTileOptions(opacity = 0.5)) %>%
  addProviderTiles(providers$Stamen.TonerLabels) 


#changing marker symbols
leaflet() %>%
  addTiles() %>%  
  addCircleMarkers(lng=-1.6178, lat=54.9783,
                   popup="The world's most important city!",
                   radius = 5, color = "red")


#optional tasks to produce markers for london and newcastle proportional size

#newcastle
leaflet() %>%
  addTiles() %>%  
  addCircleMarkers(lng=-1.6178, lat=54.9783,
                   popup="Newcastle",
                   radius = , color = "red", fillColor = "yellow", opacity = 1)

#london
leaflet() %>%
  addTiles() %>%  
  addCircleMarkers(lng=0.1278, lat=51.5074,
                   popup="London",
                   radius = 80, color = "red", fillColor = "yellow", opacity = 1)

#make labels and popups which are displayed when hovered and not just clicked

addCircleMarkers(lng=-1.6178, lat=54.9783,
                 popup="Newcastle population 270k",
                 labelOptions = labelOptions(textsize = "15px")


                 
                 
                 %>%
                   addTiles() %>%  
                   addCircleMarkers(lng=-1.6178, lat=54.9783, 
                                    label="Newcastle",
                                    labelOptions = labelOptions(textsize ="15:px") %>% 
                                      labelOptions = labelOptions(noHide ="FALSE"),
                                    radius = "10", color = "red", fillColor = "yellow", opacity = 1)
                 
                 ?labelOptions()
                 
                 leaflet() %>%
                   addTiles() %>% 
                   addCircleMarkers(lng=-1.6178, lat=54.9783,
                                    label ="Newcastle population 270k",
                                    labelOptions = labelOptions(noHide = FALSE))
                 
                 
                 
                 
                 
#vector maps and leaflet

library(sf)        
                 
#reading in the nafferton data

nafferton_fields <- st_read("www/naff_fields/naff_fields.shp")                
                 
st_crs(nafferton_fields)                                                                    
#first reset nafferton fields to 0S 27700 depending on the source of your data

#you may not always need this first step

nafferton_fields <- nafferton_fields %>% 
  st_set_crs(27700) %>% 
  st_transform(27700)

#transform to latitude and longitude
nafferton_fields_ll <- st_transform(nafferton_fields, 4326) # Lat-Lon

plot(nafferton_fields_ll)

leaflet() %>% 
  addProviderTiles(providers$Esri.WorldImagery) %>% 
  addFeatures(nafferton_fields_ll)

#displaying sub sets of vector data
nafferton_fields_ll[nafferton_fields_ll$Farm_Meth=="Organic",]
leaflet() %>% 
  addProviderTiles(providers$Esri.WorldImagery) %>% 
  addFeatures(nafferton_fields_ll[nafferton_fields_ll$Farm_Meth=="Organic",],
              fillColor="green",
              color="white",
              opacity =0.7,
              fillOpacity=1) %>% 
  addFeatures(nafferton_fields_ll[nafferton_fields_ll$Farm_Meth=="Conventional",],
              fillColor="red",
              color="yellow", 
              fillOpacity=1)



#continuous colour options

# Set the bins to divide up your areas
bins <- c(0, 25000, 50000, 75000, 100000, 125000, 150000, 175000, 200000, 225000)

# Decide on the colour palatte
pal <- colorBin(palette = "Blues", domain = bins)

# Create the map
leaflet() %>% 
  addProviderTiles(providers$Esri.WorldImagery) %>% 
  addFeatures(nafferton_fields_ll,
              fillColor = ~pal(nafferton_fields_ll$Area_m),
              fillOpacity = 1)



#add legend
pal <- colorNumeric(palette = "Blues", domain = bins)

# Now leaflet is called with nafferton_fields_ll
leaflet(nafferton_fields_ll) %>% 
  addProviderTiles(providers$Esri.WorldImagery) %>% 
  addFeatures(fillColor = ~pal(Area_m),
              fillOpacity = 1) %>% 
  addLegend("bottomright",
            pal = pal,
            values = ~Area_m,
            title = "Field area",
            labFormat = labelFormat(suffix = " m^2"),
            opacity = 1)

#higlights and popups
#adding in highlightOptions = highlightOptions(color = "yellow", weight = 5, bringToFront = TRUE) to above code

leaflet(nafferton_fields_ll) %>% 
  addProviderTiles(providers$Esri.WorldImagery) %>% 
  addFeatures(fillColor = ~pal(Area_m),
              fillOpacity = 1, 
              highlightOptions = highlightOptions(
                color = "yellow",
                weight = 5,
                bringToFront = TRUE)) %>% 
  addLegend("topright",
            pal = pal,
            values = ~Area_m,
            title = "Field area",
            labFormat = labelFormat(suffix = " m^2"),
            opacity = 1)

field_info <- paste("Method: ", nafferton_fields_ll$Farm_Meth,
                    "<br>",
                    "Crop: ", nafferton_fields_ll$Crop_2010)


leaflet(nafferton_fields_ll) %>% 
  addProviderTiles(providers$Esri.WorldImagery) %>% 
  addFeatures(nafferton_fields_ll,
              fillColor = ~pal(Area_m),
              fillOpacity = 1,
              highlightOptions = highlightOptions(color = "yellow", weight = 5,
                                                  bringToFront = TRUE),
              popup = field_info) %>% 
  addLegend("bottomright", pal = pal,
            values = ~Area_m,
            title = "Field area",
            labFormat = labelFormat(suffix = " m^2"),
            opacity = 1)

#interactive control of foreground and background maps

leaflet() %>% 
  addTiles(group = "OSM (default)") %>% 
  addProviderTiles(providers$Esri.WorldImagery,
                   group = "Satellite") %>% 
  addLayersControl(
    baseGroups = c("OSM (default)", "Satellite")
  ) %>% 
  setView(lat = 54.9857, lng=-1.8990, zoom=10)


#overlay of nafferton farm
leaflet() %>% 
  addTiles(group = "OSM (default)") %>% 
  addProviderTiles(providers$Esri.WorldImagery, group = "Satellite") %>% 
  addFeatures(nafferton_fields_ll, group = "Nafferton Farm") %>% 
  addLayersControl(
    baseGroups = c("OSM (default)", "Satellite"), 
    overlayGroups = "Nafferton Farm",
    options = layersControlOptions(collapsed = FALSE)
  )

#adding conventional or organic areas to the farm
leaflet() %>%
  addTiles(group = "OSM (default)") %>% 
  addProviderTiles(providers$Esri.WorldImagery, group = "Satellite") %>% 
  addFeatures(nafferton_fields_ll[nafferton_fields_ll$Farm_Meth=="Organic",],
              fillColor="green",
              color="white",
              opacity =0.7,
              fillOpacity=1,
              group = "Organic") %>% 
  addFeatures(nafferton_fields_ll[nafferton_fields_ll$Farm_Meth=="Conventional",],
              fillColor="red",
              color="yellow", 
              fillOpacity=1,
              group = "Conventional") %>% 
  addLayersControl(
    baseGroups = c("OSM (default)", "Satellite"), 
    overlayGroups = c("Organic", "Conventional"),
    options = layersControlOptions(collapsed = TRUE)
  )




#integration with shiny...
