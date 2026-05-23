library(testthat)
library(f1pits)
library(readr)
library(dplyr)

test_that("pitelo returns a valid ELO tibble calc correctly", {

  # Cargar CSV de prueba

  data_file <- testthat::test_path("testdata", "1aus.csv")

  example_csv <- readr::read_delim(
    data_file,
    delim = "\t",
    show_col_types = FALSE,
    trim_ws = TRUE
  )

  # --- Basic execution (DEFAULT FUNCTION) ---
  result <- pitelo(example_csv)

  # 1. Output type
  expect_s3_class(result, "data.frame")

  # 2. Required columns exist
  expect_true(all(c("Team", "Rating") %in% names(result)))

  # 3. Number of teams equal?
  expect_equal(nrow(result), length(unique(example_csv$Team)))
})


test_that("pitelo works with different stat_fun values", {

  data_file <- testthat::test_path("testdata", "1aus.csv")

  example_csv <- readr::read_delim(
    data_file,
    delim = "\t",
    show_col_types = FALSE,
    trim_ws = TRUE
  )

  res_mean <- pitelo(example_csv, stat_fun = 2)
  res_min  <- pitelo(example_csv, stat_fun = 3)

  expect_s3_class(res_mean, "data.frame")
  expect_s3_class(res_min, "data.frame")
  expect_equal(nrow(res_mean), nrow(res_min))
})

test_that("pitelo identify invalid stat_fun argument", {

  data_file <- testthat::test_path("testdata", "1aus.csv")

  example_csv <- readr::read_delim(
    data_file,
    delim = "\t",
    show_col_types = FALSE,
    trim_ws = TRUE
  )

  expect_error(pitelo(example_csv, stat_fun = 0))
})


test_that("pitelo fml argument (family mode) works", {

  data_file <- testthat::test_path("testdata", "1aus.csv")

  example_csv <- readr::read_delim(
    data_file,
    delim = "\t",
    show_col_types = FALSE,
    trim_ws = TRUE
  )

  res_fml_true  <- pitelo(example_csv, fml = TRUE)
  res_fml_false <- pitelo(example_csv, fml = FALSE)

  expect_s3_class(res_fml_true, "data.frame")
  expect_s3_class(res_fml_false, "data.frame")

  expect_equal(nrow(res_fml_true), nrow(res_fml_false))
})
