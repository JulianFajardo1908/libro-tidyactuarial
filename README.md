# Matemática Actuarial con R y tidyactuarial

**Autor:** Julián Mauricio Fajardo.

Libro de matemática actuarial desarrollado en Quarto, con demostraciones, problemas resueltos y auditorías computacionales utilizando [`tidyactuarial`](https://julianfajardo1908.github.io/tidyactuarial/).

**Dirección prevista (no verificada como sitio publicado):** https://julianfajardo1908.github.io/libro-tidyactuarial/

## Contenido de esta edición

- Capítulo 1: Tasas de interés y valor del dinero.
- Capítulo 2: Ecuaciones de valor (fuente integrada en la versión de trabajo).

## Libro y paquete

- [Documentación de tidyactuarial](https://julianfajardo1908.github.io/tidyactuarial/)
- [Código fuente del paquete](https://github.com/JulianFajardo1908/tidyactuarial)
- [Versión estable en CRAN](https://cran.r-project.org/package=tidyactuarial)

El libro desarrolla la matemática; el paquete proporciona funciones para comprobar y reproducir cálculos. Las versiones de ambos proyectos se gestionan de manera independiente.

## Reproducción local

Instale [Quarto](https://quarto.org/) y R (4.1 o posterior). Dentro de R:

```r
install.packages(c("tidyactuarial", "tidyverse", "knitr", "rmarkdown", "lubridate"),
                 repos = "https://cloud.r-project.org")
```

Después, desde la raíz del proyecto:

```bash
quarto render --to html
quarto preview
```

`R/configuracion-libro.R` carga las dependencias y define las tablas auxiliares usadas en los capítulos. La primera compilación debe comprobarse con el paquete instalado. **La ejecución de R y Quarto todavía no se ha verificado en esta entrega.**

## GitHub Pages

Este proyecto está configurado para publicarse **desde un repositorio público independiente**, propuesto como `JulianFajardo1908/libro-tidyactuarial`, en la rama `main`. Su flujo de trabajo renderiza el libro mediante GitHub Actions y despliega el contenido de `_book` en la rama `gh-pages`.

Para activarlo: cree el repositorio público, copie únicamente los archivos de la carpeta `publicacion-capitulo-01`, compruebe la ejecución en **Actions**, habilite la publicación desde **Settings → Pages → Deploy from a branch → gh-pages / (root)** y verifique la dirección publicada.

La rama `master` y el repositorio privado `LibroTidyactuarial` existente no deben cambiar su visibilidad para realizar esta publicación. **No suba al repositorio público capítulos pendientes ni libros de referencia de terceros.**

## Integración recíproca (tras comprobar el despliegue)

Una vez activa la web, añada el enlace al libro en el README y la navegación de pkgdown de `tidyactuarial`. Evite mostrarlo como un enlace operativo mientras la dirección no esté publicada.

## Reporte de errores

Use la pestaña *Issues* del repositorio público, una vez creado.
