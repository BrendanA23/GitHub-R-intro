
source("setup.R")

counties <- counties(state = "CO")
road <- roads(state = "CO", county = "Larimer")
tmap_mode("view")

tm_shape(counties)+
  qtm(road)+
tm_shape(road)+
  tm_lines()

# points 
poudre_points <- data.frame(name = c("Mishawaka", "Rustic", "Blue Lake Trailhead"),
                            long = c(-105.35634, -105.58159, -105.85563),
                            lat = c(40.68752, 40.69687, 40.57960))
#convert spatial
poudre_points_sf <- st_as_sf(poudre_points, coords = c("long", "lat"), crs = 4326); class(poudre_points_sf)
counties

#check projection 
st_crs(counties)
crs(counties) == crs(poudre_points_sf) #not same type
poudre_points_prj <- st_transform(poudre_points_sf, st_crs(counties))
#do they they match, yes
st_crs(poudre_points_prj) == st_crs(counties)


poudre_hwy <- road %>%
  dplyr::filter(FULLNAME == "Poudre Canyon Hwy")

road %>%
  filter(grepl('Poudre',.$FULLNAME))
####raster data
elevation <- get_elev_raster(counties, z = 7)
qtm(elevation)
tm_shape(elevation)+
  tm_raster(style = "cont", title = "Elevation (m)")
elevation

#terra package 4 raster 
elevation <- rast(elevation)
names(elevation) <- "Elevation"
#crop to 
elevation_crop <- crop(elevation, ext(road))
tm_shape(elevation_crop)+
  tm_raster(style = "cont")

tm_shape(elevation, bbox = st_bbox(poudre_hwy))+
  tm_raster(style = "cont", title = "Elevation (m)")+
  tm_shape(poudre_hwy)+
  tm_lines()+
  tm_shape(poudre_points_prj)+
  tm_dots(size = 0.2)

#project elevation to counties
elevation_proj <- terra::project(elevation, counties)


#crop to counties 
elevation_crop <- crop(elevation, ext(counties))
qtm(elevation_crop)

## read / write spatial data
#save sf/vector data
write_sf(counties, "data/counties.shp")

#save raster 
writeRaster(elevation_crop, "data/elevation.tif")

#save.RData
save(counties, road, file = "data/spatial_objects.RData")

# 4. Exercises
# Filter out the counties data set to only include Larimer, Denver, and Pueblo counties.
counties <- county_subdivisions(state = "CO", county = c("Larimer", "Denver","Pueblo"))
# Make a map of the counties data colored by county area. Make a second map of counties colored by their total area of water.
tmap_mode("view")
qtm(counties)+
  tm_polygons(c("Larimer", "Denver","Pueblo"))
      
# Make a barplot comparing the elevation of your 3 points in the Poudre Canyon (note: explore the extract() function in the terra package).
bplot <- extract(poudre_hwy, y = elevation)
# Why are there 4 features in our Poudre Canyon Highway variable instead of 1?
#     
  
