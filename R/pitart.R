#' @title F1 pitstop ASCII art
#' @description Funny ASCII F1 pitstop for title_text argument in pitplot() function
#' @format ASCII string
#' @param n Integer. ASCII pit stop to generate. From 1 (by default) to 5
#' @return A string containing the ASCII art of a F1 pit stop
#' @examples
#' pitart(1)
#' pitart(2)
#' pitart(3)
#' pitart(5)
#' @export
pitart <- function(n=1){

  if (missing(n)) {
    message("No n argument provided. Defaulting to n = 1 ASCII F1 pit stop")
    }

  if (!n %in% 1:5) {
    stop("n must be an integer from 1 to 5")
  }

  arts <- list("  0     _____    0\n /|\\>_\\=.....=/_</|\\_ \n / \\ |_|--// \\\\--|_|/ \\ ",
               "  0     _____    0\n /|\\>_\\=..|..=/_</|\\_ \n / \\ |_|--// \\\\--|_|/ \\ ",
               "   ----ooooo----  \n  0     _____    0\n /|\\>_\\=.....=/_</|\\_ \n / \\ |_|--// \\\\--|_|/ \\ ",
               "   ----ooooo----  \n  0     _____    0\n /|\\>_\\=..|..=/_</|\\_ \n / \\ |_|--// \\\\--|_|/ \\ ",
               "   ----ooooo----  \n  0     _____     0\n /|\\>_\\=..\u00BA..=/_</|\\ \n / \\ |_|--// \\\\--|_| / \\ ")

  art <- arts[[n]]

  message("  O    _________    O\n/|\\>  _\\=..o..=/_  </|\\ \n / \\ |_|-// \\\\-|_| / \\ ")

  rm(list = c("arts"), envir = environment())

  return(art)
}
