library(testthat)
library(f1pits)
library(readr)
library(dplyr)
library(ggplot2)

# --- Datos de prueba ---
data_file <- testthat::test_path("testdata", "1aus.csv")

example_csv <- read_delim(data_file,
                          delim = "\t",
                          show_col_types = FALSE, trim_ws = TRUE)

if (!"Team" %in% colnames(example_csv)) example_csv$Team <- "Ferrari"
if (!"Driver" %in% colnames(example_csv)) example_csv$Driver <- "Driver1"

# --- Tests ---
test_that("pitplot returns ggplot object for type 1, 2, 3", {
  p1 <- pitplot(example_csv, type = 1)
  p2 <- pitplot(example_csv, type = 2)
  p3 <- pitplot(example_csv, type = 3)

  expect_s3_class(p1, "ggplot")
  expect_s3_class(p2, "ggplot")
  expect_s3_class(p3, "ggplot")
})

test_that("pitplot errors for invalid type", {
  expect_error(pitplot(example_csv, type = 99),
               regexp = "type must be 1")
})

test_that("pitplot errors for non-tibble input", {
  df <- as.data.frame(example_csv)
  expect_error(pitplot(df, type = 1),
               regexp = "pits_data object MUST BE tibble")
})

test_that("pitplot message appears when type missing", {
  expect_message(pitplot(example_csv),
                 regexp = "No type argument provided. Defaulting to type = 3")
})
