library(testthat)
library(readr)
library(dplyr)

# Cargar CSV de prueba
data_file <- testthat::test_path("testdata", "2015.csv")
example_season_csv <- read_delim(data_file,
                                 delim = "\t",
                                 show_col_types = FALSE, trim_ws = TRUE)

# Simular temporada
example_season <- tibble(
  race_name = c("Season standings 2015")
)

# --- Función auxiliar para testing ---
champ_sim <- function(year) {
  seasons_available <- 2015
  seasons_files <- list(example_season_csv)

  if (identical(year, "all")) {
    years_to_use <- seq_along(seasons_files)
  } else {
    years_to_use <- which(seasons_available %in% year)
    if (length(years_to_use) == 0) {
      stop(paste0("No CSV found for season ", year))
    }
  }

  get_single_season <- function(idx) {
    dat <- seasons_files[[idx]]
    dat$Year <- seasons_available[idx]  # asigna el año real
    dat
  }

  bind_rows(lapply(years_to_use, get_single_season))
}

# --- Tests ---
test_that("champ_sim reads CSV correctly", {
  result <- champ_sim(year = 2015)

  expect_s3_class(result, "tbl_df")
  expect_true("Year" %in% colnames(result))
  expect_equal(unique(result$Year), 2015)
})

test_that("champ_sim works with 'all' seasons", {
  result <- champ_sim(year = "all")
  expect_s3_class(result, "tbl_df")
  expect_equal(nrow(result), nrow(example_season_csv) * 1) # ONLY season 2015
})

test_that("champ_sim errors on missing season", {
  expect_error(champ_sim(year = 2014),
               regexp = "No CSV found for season")
})
