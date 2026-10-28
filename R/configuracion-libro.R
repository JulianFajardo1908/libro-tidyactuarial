# Configuracion comun del libro (Quarto/R)
# Esta fuente se carga desde cada capitulo y no se presenta al lector.

suppressPackageStartupMessages({
  library(tidyactuarial)
  library(tidyverse)
  library(knitr)
  library(lubridate)
})

if (utils::packageVersion("tidyactuarial") < "0.2.0") {
  stop("Los ejemplos requieren tidyactuarial 0.2.0 o posterior.")
}

knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.align = "center",
  fig.width = 6,
  fig.height = 3.5,
  dpi = 300,
  warning = FALSE,
  message = FALSE
)

# El parametro digits admite: un valor comun para toda la tabla;
# un valor por fila (para comparar tasas y cuantias); o un valor por columna.
# El redondeo se aplica solo al mostrar los datos, no a los calculos.
formatear_tabla <- function(datos, digits = 2) {
  if (!is.data.frame(datos)) {
    stop("Se espera un data.frame o tibble.")
  }
  n <- nrow(datos)
  p <- ncol(datos)
  if (length(digits) == 1L) {
    digitos <- matrix(as.integer(digits), nrow = n, ncol = p)
  } else if (length(digits) == n) {
    digitos <- matrix(rep(as.integer(digits), p), nrow = n, ncol = p)
  } else if (length(digits) == p) {
    digitos <- matrix(rep(as.integer(digits), each = n), nrow = n, ncol = p)
  } else {
    stop("digits debe tener longitud 1, nrow(datos) o ncol(datos).")
  }
  resultado <- as.data.frame(datos, check.names = FALSE)
  for (j in seq_len(p)) {
    if (is.numeric(resultado[[j]])) {
      resultado[[j]] <- vapply(seq_len(n), function(i) {
        x <- resultado[[j]][i]
        if (is.na(x)) return(NA_character_)
        formatC(
          x,
          digits = digitos[i, j],
          format = "f",
          big.mark = " ",
          decimal.mark = "."
        )
      }, character(1))
    }
  }
  resultado
}

tabla_resultado <- function(datos, titulo = NULL, digits = 2, align = NULL) {
  vista <- formatear_tabla(datos, digits = digits)
  knitr::kable(
    vista,
    format = "pipe",
    caption = titulo,
    align = align,
    row.names = FALSE
  )
}

tabla_comparacion <- function(datos, titulo = NULL, digits = 2, align = NULL) {
  tabla_resultado(datos, titulo = titulo, digits = digits, align = align)
}
