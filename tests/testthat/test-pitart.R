# tests/testthat/test-pitart.R

library(testthat)

# Basical test: retorna un string
test_that("pitart() returns a string", {
  result <- pitart(1)
  expect_type(result, "character")
})

# Test: if n okay, returns string (1 to 4)
test_that("pitart() returns correct ASCII for n = 1:4", {
  for (i in 1:4) {
    ascii <- pitart(i)
    expect_true(nchar(ascii) > 0)  # debe contener texto
  }
})

# Test: n fuera de rango da error
test_that("pitart() stops if n is not 1:4", {
  expect_error(pitart(0), "n must be an integer from 1 to 4")
  expect_error(pitart(5), "n must be an integer from 1 to 4")
})

# Test: missing n se maneja correctamente (mensaje) y retorna ASCII art
test_that("pitart() works when n is missing", {
  expect_message(result <- pitart(), "No n argument provided")
  expect_type(result, "character")
})

# Test: output contiene ciertos caracteres clave (opcional)
test_that("ASCII output contains expected characters", {
  ascii <- pitart(3)
  expect_true(grepl("_____", ascii))
  expect_true(grepl("/|\\\\", ascii))
})
