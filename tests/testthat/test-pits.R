library(testthat)
library(f1pits)
library(readr)
library(dplyr)

data_file <- testthat::test_path("testdata", "1aus.csv")

example_csv <- read_delim(data_file,
                          delim = "\t",
                          show_col_types = FALSE, trim_ws = TRUE)

# Simulate load_schedule() -testing!-
example_schedule_track <- tibble(
  race_name = c("Australian Grand Prix")
)

# --- Function aux tests ---
pits_sim <- function(round, year) {
  rounds_available <- 1
  race_files <- list(example_csv)
  schedule <- example_schedule_track

  if (identical(round, "all")) {
    rounds_to_use <- seq_along(race_files)
  } else {
    rounds_to_use <- which(rounds_available %in% round)
    if (length(rounds_to_use) == 0) {
      stop(paste0("No CSV found for round ", round, ", year ", year))
    }
  }

  get_single_round <- function(idx) {
    data <- race_files[[idx]]
    data$Round <- rounds_available[idx]
    data$Year  <- year
    data
  }

  bind_rows(lapply(rounds_to_use, get_single_round))
}

# --- Tests ---
test_that("pits_sim reads CSV correctly", {
  result <- pits_sim(round = 1, year = 2025)

  expect_s3_class(result, "tbl_df")
  expect_true(all(c("Round","Year","Driver","Lap","Time (sec)") %in% colnames(result)))
  expect_equal(unique(result$Round), 1)
  expect_equal(unique(result$Year), 2025)
})

test_that("pits_sim works with 'all' rounds", {
  result <- pits_sim(round = "all", year = 2025)
  expect_s3_class(result, "tbl_df")
  expect_equal(nrow(result), nrow(example_csv) * 1) # solo un round en este ejemplo
})

test_that("pits_sim errors on missing round", {
  expect_error(pits_sim(round = 999, year = 2025),
               regexp = "No CSV found for round")
})

