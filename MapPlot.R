
rm(list = ls())

# install.packages("mapproj")
library(ggplot2)
library(dplyr)
library(maps)
library(mapproj)

#############
## Helpers ##
#############
## Percent Function
percent <- function(x, digits = 2, format = "f", ...) {
  paste0(formatC(100 * x, format = format, digits = digits, ...), "%")
}


####################
## Data Wrangling ##
####################
## Provider Level Data
providers <- read.csv("SNF_Population.csv", stringsAsFactors = F)

## Get state data
states <- map_data("state")
states$state_abb <- state.abb[match(states$region, tolower(state.name))]

## Rank Order
Rank <- aggregate(PctRankUltraHi ~ States, data = providers, FUN = mean)
Rank$pct <- percent(Rank$PctRankUltraHi)
map.df <- merge(states, Rank, by.x = "state_abb", by.y = "States", all.x = T)
map.df <- map.df[order(map.df$order), ]


#######################
## Prep Map Building ##
#######################
## Create label centroids
label_long <- aggregate(long ~ state_abb, data = map.df, FUN = mean)
label_lat <- aggregate (lat ~ state_abb, data = map.df, FUN = mean)
labelCentroids <- merge(label_long, label_lat, by = "state_abb")
labels <- merge(Rank, labelCentroids, by.x = "States", by.y = "state_abb")
rm(label_long, label_lat, labelCentroids)
labels <- subset(labels, labels$PctRankUltraHi > 0.7)

## Adjust label positions
labels[which(labels$States == "CA"), 4] <- labels[which(labels$States == "CA"), 4] + 1.5
labels[which(labels$States == "FL"), 4] <- labels[which(labels$States == "FL"), 4] + -2.5
labels[which(labels$States == "NJ"), 4] <- labels[which(labels$States == "NJ"), 4] + 2
labels[which(labels$States == "NJ"), 5] <- labels[which(labels$States == "NJ"), 5] + -1
labels[which(labels$States == "RI"), 4] <- labels[which(labels$States == "RI"), 4] + 2
labels[which(labels$States == "NH"), 5] <- labels[which(labels$States == "NH"), 5] + 3
labels[which(labels$States == "NH"), 4] <- labels[which(labels$States == "NH"), 4] + -1


##############
## Plot Map ##
##############
RankMap <- ggplot(map.df, aes(x = long, y = lat, group = group)) +
  geom_polygon(aes(fill = PctRankUltraHi)) +
  geom_path() +
  scale_fill_gradient(name = "Rank"
                      , labels = c("20%","40%", "60%")
                      , breaks = c(0.20, 0.40, 0.60)
                      , low = "#863198", high = "#FF661B") +
  geom_text(  data = labels
            , aes(x = long, y = lat, group = NA
                  , label = paste(labels$States, labels$pct, sep = "\n"))
            , size = 3.5, color = "white") +
  coord_map() +
  ggtitle(bquote(atop(.("Average Provider Rank by State")
                      , atop(italic(.("Ultra High Therapy")), "")))) + 
  theme(  axis.title = element_blank()
        , axis.text = element_blank()
        , axis.ticks = element_blank()
        , panel.border = element_blank()
        , panel.grid.major = element_blank()
        , panel.grid.minor = element_blank()
        , panel.background = element_rect(fill = "#003763", color = "#003763")
        , plot.title = element_text(size = rel(1.25))
        , legend.background = element_rect(fill = "#003763", color = "#003763")
        , legend.justification = c(1,0)
        , legend.position = c(1, 0)
        , legend.title = element_text(color = "white")
        , legend.text = element_text(color = "white"))
RankMap
ggsave("RankMap.png", RankMap, width = 12, height = 8, units = "in")


#############################
## Provider Count by State ##
#############################
# SNF <- as.data.frame(matrix(table(providers$States)))
# SNF$state_abb <- unique(providers$States)
# names(SNF)[1] <- "SNFcount"
# 
# map.df <- merge(states, SNF, by = "state_abb", all.x = T)
# map.df <- map.df[order(map.df$order), ]
# 
# SNFmap <- ggplot(map.df, aes(x = long, y = lat, group = group)) +
#   geom_polygon(aes(fill = SNFcount)) +
#   geom_path() +
#   scale_fill_gradient(low = "#863198", high = "#FF661B") +
#   # scale_fill_gradientn(colors = rev(heat.colors(10))) +
#   coord_map()
# SNFmap

