## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.width = 5,       # ancho en pulgadas
  fig.height = 2.5,       # alto en pulgadas
  dpi = 120             # resolution
)

## ----setup--------------------------------------------------------------------
library(f1pits)

## ----message=TRUE, warning=TRUE-----------------------------------------------
# Accessing the data, for example, round 1, Australian GP 2026:

pits(1, 2026) -> pitdata

pitdata

## ----message=TRUE, warning=TRUE-----------------------------------------------
pitelo(pitdata)

## ----message=TRUE, warning=TRUE-----------------------------------------------
pitelo(pitdata, stat_fun = 3, calc = 2, k = 40, c = 20, d = 1000)

## ----message=TRUE, warning=TRUE-----------------------------------------------
pits(1, 2024) -> pitdata24

pits(1, 2025) -> pitdata25

# Join datasets:
pitdata_multiple <- dplyr::bind_rows(pitdata, pitdata24, pitdata25)

# Show all teams in dataset:
unique(pitdata_multiple$Team)

pitelo(pitdata_multiple, fml = TRUE)

pitelo(pitdata_multiple, fml = FALSE)

## ----message=TRUE, warning=TRUE-----------------------------------------------
# Create an ELO tibble with a starting value of 1000 for all teams, except Cadillac.
# As a new team it will be slightly penalized 
# because its team structure is completely new.

elo_data <- tibble::tibble(
    Team = c("Ferrari", "Red Bull", "Mercedes", "Racing Bulls", "McLaren",
             "Haas", "Alpine", "Williams", "Audi", "Aston Martin", "Cadillac"),
    Rating = c(1000, 1000, 1000, 1000, 1000,
               1000, 1000, 1000, 1000, 1000, 950))

elo_data

str(elo_data)

pitelo(pitdata, elo = elo_data)

## ----message=TRUE, warning=TRUE-----------------------------------------------
# Plotting the data:

pitplot(pitdata, 2) -> pitplot_pitdata

pitplot_pitdata

## ----message=TRUE, warning=TRUE, fig.height=4---------------------------------

pitplot(pitdata, 2, title_text = paste0(pitart(3), "    Pit Stop data")) -> pitplot_pitdata_title_edit

pitplot_pitdata_title_edit

