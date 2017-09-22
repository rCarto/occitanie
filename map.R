# load library
library(cartography)
library(linemap)

# load data
load("data/Occ.RData")
data("occitanie")

# create a pdf
pdf(file = "img/occitanie.pdf", width = 11.69, height = 8.27, pointsize = 15)
# or a png...
# png(filename = "img/occitanie.png", width = 1600, height = 1150, res = 180)

# values usefull to plot text and polygons
bbr <- st_bbox(region)
px <-  (bbr[3] - bbr[1]) / 25
py <-  (bbr[4] - bbr[2]) / 35
bbr2 <- c(bbr[1] - px, bbr[2] - py, bbr[3] + px, bbr[4] + py)

# set figure margins and map background color
opar <- par(mar=c(0,0,0,0), bg = "aliceblue")

# plot countries
plot(st_geometry(pays), col = "ivory2", border = NA, 
     xlim = bbr[c(1,3)], ylim = bbr[c(2,4)])

# plot borders
plot(st_geometry(frontiere), col = "white", add=T, lwd = 2)

# plot a shadow under region
plot(st_geometry(region) + c(-2500,2000), col = "ivory3", 
     border = NA,  add=T)

# plot region
plot(st_geometry(region), col="ivory1", border = NA, add=T)

# plot population lines
linemap(x = popOcc, var = "pop", k = 2.5, threshold = 50,
        col = "ivory1", border = "ivory4", lwd = 0.6, add = TRUE)

# plot label for prefectures
labelLayer(x = prefecture, txt = "NOM_COM", col = "ivory4",
           halo = TRUE, bg = "ivory1")

# add a title
text(x = bbr[1] - 10000, y = bbr[4], 
     labels = "Répartition de la\npopulation\nen Occitanie",  
      col = "ivory4", font = 4,  cex = 1.8, adj = c(0,1) )

# add sources
mapsources <-
"R 3.4.1, cartography 2.0.0, linemap 0.1.0
Données carroyées à 1 kilomètre, INSEE 2010"
text(x = bbr2[3], y = bbr2[2],labels = mapsources,  
     col = "ivory4", font = 3, adj = c(1,0), cex = 0.6 )

# add a block of text
maptxt <- 
"Il est possible de reproduire cette carte
entièrement réalisée avec le logiciel R en 
utilisant les données et scripts disponibles 
ici : https://github.com/rCarto/occitanie."
text(x = bbr[1] - 10000, y = bbr2[2], labels = maptxt,
     adj = c(0,0), cex = .9, col = "ivory4")

# add a north arrow
north(col = 'ivory1')

# add R logo
logo1 <- png::readPNG("img/Rlogogrey.png")
pp <- dim(logo1)[2:1] * 75
yref <- 2220000
rasterImage(logo1, bbr[1] - 10000, yref - pp[2], bbr[1] + pp[1] - 10000, yref) 

# add riate logo
logo2 <- png::readPNG("img/riate_grew_high.png")
pp <- dim(logo2)[2:1] * 50
yref <- 2170000
rasterImage(logo2, bbr2[3] - pp[1], yref, bbr2[3], yref + pp[2]) 

# add creative commons
logo3 <- png::readPNG("img/by-nc-sa.png")
pp <- dim(logo3)[2:1] * 110
yref <- yref + 5000 + pp[2]
rasterImage(logo3, bbr2[3], yref, bbr2[3] + pp[1], yref + pp[2], angle = 90) 

# add author
text(x = bbr2[3], y = yref + pp[1], labels = "Timothée Giraud",srt = 90,
     cex = 0.5, col = "ivory4", adj = c(-0.05,-0.2))

dev.off()

