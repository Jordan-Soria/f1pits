#' @title Pit stops of a race or set
#' @description Pit stop results of a race or set
#' @param round Number of the race (integer), set of races a:b (vector) or "all" (character)
#' @param year Year of the race (integer). 2019 or higher
#' @return A tibble containing the pit stops values of the specified race(s)
#' @examples
#' \donttest{
#' pits(10, 2025)
#' pits(1:2, 2025)
#' }
#' @importFrom f1dataR load_schedule
#' @importFrom readr read_delim
#' @importFrom httr GET content
#' @importFrom jsonlite fromJSON
#' @importFrom dplyr bind_rows
#' @importFrom tibble tibble as_tibble
#' @export
pits <- function(round, year) {

  # Llamada a la API de GitHub para listar ficheros del año
  api_url <- paste0("https://api.github.com/repos/Jordan-Soria/PitStops/contents/", year, "?ref=main")

  resp <- GET(api_url)
  if (resp$status_code != 200) {
    stop(paste0("Error when listing files on GitHub. HTTP status: ", resp$status_code))
  }

  files_info <- fromJSON(content(resp, "text", encoding = "UTF-8"))

  # Solo los archivos CSV
  race_files <- files_info$name[grepl("\\.csv$", files_info$name)]

  # Extraer número de round de cada fichero
  rounds_available <- as.integer(sub("^(\\d+).*", "\\1", race_files))

  # Ordenar archivos por round real
  ord <- order(rounds_available)
  race_files <- race_files[ord]
  rounds_available <- rounds_available[ord]

  # Determinar qué rounds cargar, ahora con "all"
  if (identical(round, "all")) {
    rounds_to_use <- seq_along(race_files)
  } else {
    rounds_to_use <- which(rounds_available %in% round)
    if (length(rounds_to_use) == 0) {
      stop(paste0("No CSV found for round ", round, ", year ", year, ".\nCheck the race(s) with f1dataR function: 'load_schedule(",year,")'"))
    }
  }

  ignored_round12 <- FALSE

  if (identical(year, 2021)) {

    removed_rounds <- rounds_available[rounds_to_use] == 12

    if (any(removed_rounds)) {
      rounds_to_use <- rounds_to_use[!removed_rounds]
      ignored_round12 <- TRUE
    }
  }

  # Mensajes por cada round usando load_schedule
  schedule <- load_schedule(season = year)
  for (idx in rounds_to_use) {
    gp_name <- schedule$race_name[idx]
    message(paste0(gp_name, " ", year, " / Round: ", rounds_available[idx]))
  }


  # Función interna para cargar un solo round
  get_single_round <- function(idx) {
    file_name <- race_files[idx]
    url <- paste0(
      "https://raw.githubusercontent.com/Jordan-Soria/PitStops/main/",
      year, "/", file_name
    )

    data <- read_delim(url, delim = "\t", show_col_types = FALSE, trim_ws = TRUE)
    data <- as_tibble(data)
    data$Round <- rounds_available[idx]
    data$Year  <- year
    return(data)
  }

  # Combinar todos los rounds solicitados
  result <- bind_rows(lapply(rounds_to_use, get_single_round))

  if (ignored_round12 == TRUE) {
    warning("\nBelgian Grand Prix 2021 / Round: 12 ignored (No pit stop data)")
  }

  rm(list = c("get_single_round", "schedule", "race_files",
              "rounds_available", "ord", "rounds_to_use"), envir = environment())

  return(result)
}
