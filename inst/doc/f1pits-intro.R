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
# Accessing the data, for example, round 1, Australian GP 2025:

pits(1,2025) -> pitdata

pitdata

## ----message=TRUE, warning=TRUE-----------------------------------------------
# Plotting the data:

pitplot(pitdata,1) -> pitplot_pitdata

pitplot_pitdata

