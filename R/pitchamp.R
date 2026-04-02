#' @title Pit stop standings by season
#' @description Pit stop official standings by season (since 2015)
#' @param year Season pit stop standings (integer). 2015 or higher
#' @return A tibble containing the pit stop season standings points (or wins in 2015 and 2016)
#' @examples
#' \donttest{
#' pitchamp(2015)
#' }
#' @importFrom readr read_delim
#' @importFrom httr GET content
#' @importFrom jsonlite fromJSON
#' @importFrom dplyr bind_rows
#' @importFrom tibble tibble as_tibble
#' @export
pitchamp <- function(year) {

  # Llamada a la API de GitHub para listar ficheros del año
  api_url <- paste0("https://api.github.com/repos/Jordan-Soria/PitStops/contents/champ?ref=main")

  resp <- GET(api_url)
  if (resp$status_code != 200) {
    stop(paste0("Error when listing files on GitHub. HTTP status: ", resp$status_code))
  }

  files_info <- fromJSON(content(resp, "text", encoding = "UTF-8"))

  # Solo los archivos CSV que hay:
  seasons_files <- files_info$name[grepl("\\.csv$", files_info$name)]

  # Extraer años del campeonato de cada fichero
  seasons_available <- as.integer(sub("^(\\d+).*", "\\1", seasons_files))

  # Determinar qué temporadas cargar, ahora con "all"
  if (identical(year, "all")) {
    seasons_to_use <- seq_along(seasons_files)
  } else {
    seasons_to_use <- which(seasons_available %in% year)
    if (length(seasons_to_use) == 0) {
      stop(paste0("No CSV found for season ", year, ".\nCheck the seasons availables (2015 or higher, EXCLUDING actual season)."))
    }
  }

  # Mensajes por cada temporada que se descargará
  for (id in seasons_to_use) {
    season_year <- seasons_available[id]
    message(paste0("Season standing ", season_year))
  }


  # Función interna para cargar una sola temporada
  get_single_season <- function(idx, seasons_files, seasons_available) {
    file_name <- seasons_files[idx]
    season_year <- seasons_available[idx]

    url <- paste0(
      "https://raw.githubusercontent.com/Jordan-Soria/PitStops/main/champ/",
      file_name
    )

    dat <- read_delim(url, delim = "\t", show_col_types = FALSE, trim_ws = TRUE)
    dat <- as_tibble(dat)
    dat$Year <- season_year
    return(dat)
  }

  # Combinar todas las temporadas seleccionadas
  result <- bind_rows(
    lapply(seasons_to_use, get_single_season,
           seasons_files = seasons_files,
           seasons_available = seasons_available)
  )

  rm(list = c("files_info", "seasons_files", "seasons_available", "seasons_to_use", "get_single_season"), envir = environment())

  return(result)
}
