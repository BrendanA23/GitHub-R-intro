
source("setup.R")

counties <- counties(state = "CO")

road <- roads(state = "CO", county = "Larimer")

tmap_mode("view")

qtm(counties)+
  qtm(road)

tm_shape(road)+
  tm_polygons()

# points 
poudre_points <- data.frame(name = c("Mishawaka", "Rustic", "Blue Lake Trailhead"),
                            long = c(-105.35634, -105.58159, -105.85563),
                            lat = c(40.68752, 40.69687, 40.57960))
#convert spatial
poudre_points_sf <- st_as_sf(poudre_points, coords = c("long", "lat"), crs = 4326); class(poudre_points_sf)

#qtm(poudre_hwy)+
#  qtm(poudre_points_sf)

#raster data
elevation <- get_elev_raster(counties, z = 7)

qtm(elevation)

tm_shape(elevation)+
  tm_raster(style = "cont", title = "Elevation (m)")

#terra package
elevation <- rast(elevation)
names(elevation) <- "Elevation"

#check projection 
st_crs(counties)
crs(counties) == crs(elevation) #not same type
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


