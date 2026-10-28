# Configuración compartida del Volumen I
# Matemática Actuarial con R y tidyactuarial

suppressPackageStartupMessages({
  library(tidyactuarial)
  library(dplyr)
  library(tidyr)
  library(tibble)
  library(purrr)
  library(knitr)
  library(ggplot2)
  library(scales)
})

if (utils::packageVersion("tidyactuarial") < "0.1.6") {
  stop("Este libro requiere tidyactuarial 0.1.6 o posterior.")
}

knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  message = FALSE,
  warning = FALSE,
  fig.width = 6,
  fig.height = 3.5,
  fig.align = "center",
  out.width = "82%",
  dpi = 300
)

options(
  width = 90,
  pillar.width = 90,
  tibble.print_max = 12,
  tibble.print_min = 8,
  scipen = 999,
  digits = 6,
  libro_digits_numero = 6,
  libro_digits_tabla = 6,
  libro_digits_comparacion = 10,
  libro_max_cols = Inf
)

formatear_numero <- function(
    x,
    digits = getOption("libro_digits_numero", 6)) {
  if (length(digits) == 1L) {
    digits <- rep(digits, length(x))
  }
  
  purrr::map2_chr(
    x,
    digits,
    ~ if (is.na(.x)) {
      NA_character_
    } else {
      formatC(
        .x,
        format = "f",
        digits = .y,
        big.mark = "",
        decimal.mark = "."
      )
    }
  )
}

salida_kable <- function(tabla) {
  knitr::asis_output(
    paste0(
      "\n\n",
      paste(as.character(tabla), collapse = "\n"),
      "\n\n"
    )
  )
}

tabla_resultado <- function(
    datos,
    titulo = NULL,
    digits = getOption("libro_digits_tabla", 6),
    align = NULL,
    max_cols = getOption("libro_max_cols", Inf)) {
  datos_base <- datos |>
    tibble::as_tibble()
  
  if (is.finite(max_cols) && ncol(datos_base) > max_cols) {
    datos_base <- datos_base |>
      dplyr::select(seq_len(max_cols))
  }
  
  if (!is.null(align)) {
    align <- align[seq_len(min(length(align), ncol(datos_base)))]
  }
  
  datos_formateados <- datos_base |>
    dplyr::mutate(
      dplyr::across(
        .cols = where(is.numeric),
        .fns = ~ formatC(
          .x,
          format = "f",
          digits = digits,
          big.mark = "",
          decimal.mark = "."
        )
      )
    )
  
  tabla <- datos_formateados |>
    knitr::kable(
      caption = titulo,
      align = align
    )
  
  salida_kable(tabla)
}

error_relativo <- function(analitico, computacional) {
  error_abs <- abs(analitico - computacional)
  
  dplyr::if_else(
    abs(analitico) > sqrt(.Machine$double.eps),
    error_abs / abs(analitico),
    NA_real_
  )
}

# Admite tanto tres vectores como una tibble con columnas
# magnitud, analitico y tidyactuarial.
tabla_comparacion <- function(
    magnitud,
    analitico = NULL,
    paquete = NULL,
    digits = getOption("libro_digits_comparacion", 6),
    titulo = "Auditoría manual vs. tidyactuarial") {
  if (inherits(magnitud, "data.frame")) {
    datos_entrada <- tibble::as_tibble(magnitud)
    
    columnas_requeridas <- c("magnitud", "analitico", "tidyactuarial")
    faltantes <- setdiff(columnas_requeridas, names(datos_entrada))
    
    if (length(faltantes) > 0L) {
      stop(
        "La tabla de auditoría no contiene las columnas requeridas: ",
        paste(faltantes, collapse = ", ")
      )
    }
    
    magnitud <- datos_entrada$magnitud
    analitico <- datos_entrada$analitico
    paquete <- datos_entrada$tidyactuarial
  }
  
  if (is.null(analitico) || is.null(paquete)) {
    stop("Deben suministrarse los resultados analítico y computacional.")
  }
  
  analitico_num <- as.numeric(analitico)
  paquete_num <- as.numeric(paquete)
  diferencia <- abs(analitico_num - paquete_num)
  
  n_filas <- length(analitico_num)
  
  if (!(length(digits) %in% c(1L, n_filas))) {
    stop(
      "`digits` debe tener longitud 1 o una entrada por fila de la auditoría."
    )
  }
  
  datos <- tibble::tibble(
    Magnitud = as.character(magnitud),
    `Resultado analítico` = formatear_numero(analitico_num, digits),
    `tidyactuarial` = formatear_numero(paquete_num, digits),
    `Diferencia absoluta` = formatear_numero(diferencia, digits)
  )
  
  tabla <- datos |>
    knitr::kable(
      caption = titulo,
      align = c("l", "r", "r", "r")
    )
  
  salida_kable(tabla)
}