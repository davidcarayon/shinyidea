
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ShinyIDEA

<!-- badges: start -->

[![Lifecycle:experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![packageversion](https://img.shields.io/badge/Package%20version-0.1.0-orange?style=flat-square)](commits/master)
[![Licence](https://img.shields.io/badge/licence-GPL--3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0.en.html)

<!-- badges: end -->

This repository contains the source code for ShinyIDEA.

ShinyIDEA is a web app aimed at making the tools developed in
[{IDEATools}](https://github.com/davidcarayon/IDEATools) available to
any user.

The app has been developed following the
[{golem}](https://github.com/ThinkR-open/golem) and
[ShinyModules](https://shiny.rstudio.com/articles/modules.html)
frameworks and has been designed using the
[{bs4Dash}](https://rinterface.github.io/bs4Dash/) package.

# Prerequisite

The hosting server should have installed :

-   LaTeX (`tinytex::install_tinytex()` should be enough)

-   The following R package from Github :

``` r
remotes::install_github("davidcarayon/IDEATools")
remotes::install_github("rstudio/sass")
```

-   The following R packages from CRAN :

``` r
dplyr::filter(rsconnect::appDependencies(), source == "CRAN")
#>             package    version source
#> 1                DT       0.22   CRAN
#> 2              MASS     7.3-54   CRAN
#> 3            Matrix      1.3-4   CRAN
#> 4      MatrixModels      0.5-0   CRAN
#> 5                R6      2.5.1   CRAN
#> 6      RColorBrewer      1.1-3   CRAN
#> 7             RCurl   1.98-1.6   CRAN
#> 8              Rcpp    1.0.8.3   CRAN
#> 9         RcppEigen  0.3.3.9.2   CRAN
#> 10          SparseM       1.81   CRAN
#> 11            abind      1.4-5   CRAN
#> 12          askpass        1.1   CRAN
#> 13          attempt      0.3.1   CRAN
#> 14        backports      1.4.1   CRAN
#> 15        base64enc      0.1-3   CRAN
#> 16              bit      4.0.4   CRAN
#> 17            bit64      4.0.5   CRAN
#> 18           bitops      1.0-7   CRAN
#> 19             boot     1.3-28   CRAN
#> 20             brew      1.0-7   CRAN
#> 21             brio      1.1.3   CRAN
#> 22            broom      0.8.0   CRAN
#> 23          bs4Dash      2.1.0   CRAN
#> 24            bslib      0.3.1   CRAN
#> 25           cachem      1.0.6   CRAN
#> 26            callr      3.7.0   CRAN
#> 27              car     3.0-13   CRAN
#> 28          carData      3.0-5   CRAN
#> 29       cellranger      1.1.0   CRAN
#> 30              cli      3.3.0   CRAN
#> 31            clipr      0.8.0   CRAN
#> 32       colorspace      2.0-3   CRAN
#> 33       commonmark      1.8.0   CRAN
#> 34           config      0.3.1   CRAN
#> 35         corrplot       0.92   CRAN
#> 36          cowplot      1.1.1   CRAN
#> 37            cpp11      0.4.2   CRAN
#> 38           crayon      1.5.1   CRAN
#> 39      credentials      1.3.2   CRAN
#> 40        crosstalk      1.2.0   CRAN
#> 41             curl      4.3.2   CRAN
#> 42             desc      1.4.1   CRAN
#> 43          diffobj      0.3.5   CRAN
#> 44           digest     0.6.29   CRAN
#> 45            dplyr      1.0.9   CRAN
#> 46         ellipsis      0.3.2   CRAN
#> 47         evaluate       0.15   CRAN
#> 48            fansi      1.0.3   CRAN
#> 49           farver      2.1.0   CRAN
#> 50          fastmap      1.1.0   CRAN
#> 51      fontawesome      0.2.2   CRAN
#> 52          foreign     0.8-81   CRAN
#> 53            fresh      0.2.0   CRAN
#> 54               fs      1.5.2   CRAN
#> 55          gdtools      0.2.4   CRAN
#> 56         generics      0.1.2   CRAN
#> 57             gert      1.6.0   CRAN
#> 58            ggfun      0.0.6   CRAN
#> 59          ggimage      0.3.1   CRAN
#> 60          ggplot2      3.3.6   CRAN
#> 61        ggplotify      0.1.0   CRAN
#> 62           ggpubr      0.4.0   CRAN
#> 63          ggrepel      0.9.1   CRAN
#> 64            ggsci        2.9   CRAN
#> 65         ggsignif      0.6.3   CRAN
#> 66           ggtext      0.1.1   CRAN
#> 67               gh      1.3.0   CRAN
#> 68         gitcreds      0.1.1   CRAN
#> 69             glue      1.6.2   CRAN
#> 70            golem      0.3.2   CRAN
#> 71        gridExtra        2.3   CRAN
#> 72     gridGraphics      0.5-1   CRAN
#> 73         gridtext      0.1.4   CRAN
#> 74           gtable      0.3.0   CRAN
#> 75             here      1.0.1   CRAN
#> 76            highr        0.9   CRAN
#> 77              hms      1.1.1   CRAN
#> 78        htmltools      0.5.2   CRAN
#> 79      htmlwidgets      1.5.4   CRAN
#> 80           httpuv      1.6.5   CRAN
#> 81             httr      1.4.3   CRAN
#> 82         hunspell      3.0.1   CRAN
#> 83              ini      0.3.1   CRAN
#> 84          isoband      0.2.5   CRAN
#> 85          janitor      2.1.0   CRAN
#> 86             jpeg      0.1-9   CRAN
#> 87        jquerylib      0.1.4   CRAN
#> 88         jsonlite      1.8.0   CRAN
#> 89            knitr       1.39   CRAN
#> 90         labeling      0.4.2   CRAN
#> 91            later      1.3.0   CRAN
#> 92          lattice    0.20-45   CRAN
#> 93         lazyeval      0.2.2   CRAN
#> 94        lifecycle      1.0.1   CRAN
#> 95             lme4     1.1-29   CRAN
#> 96        lubridate      1.8.0   CRAN
#> 97           magick      2.7.3   CRAN
#> 98         magrittr      2.0.3   CRAN
#> 99         maptools      1.1-4   CRAN
#> 100        markdown        1.1   CRAN
#> 101         memoise      2.0.1   CRAN
#> 102            mgcv     1.8-38   CRAN
#> 103            mime       0.12   CRAN
#> 104           minqa      1.2.4   CRAN
#> 105         munsell      0.5.0   CRAN
#> 106            nlme    3.1-153   CRAN
#> 107          nloptr      2.0.0   CRAN
#> 108            nnet     7.3-16   CRAN
#> 109        numDeriv 2016.8-1.1   CRAN
#> 110      officedown      0.2.4   CRAN
#> 111         officer      0.4.2   CRAN
#> 112         openssl      2.0.0   CRAN
#> 113        openxlsx      4.2.5   CRAN
#> 114        pbkrtest      0.5.1   CRAN
#> 115        pdftools      3.2.0   CRAN
#> 116          pillar      1.7.0   CRAN
#> 117       pkgconfig      2.0.3   CRAN
#> 118         pkgload      1.2.4   CRAN
#> 119             png      0.1-7   CRAN
#> 120         polynom      1.4-1   CRAN
#> 121          praise      1.0.0   CRAN
#> 122     prettyunits      1.1.1   CRAN
#> 123        processx      3.5.3   CRAN
#> 124        progress      1.2.2   CRAN
#> 125        promises    1.2.0.1   CRAN
#> 126              ps      1.7.0   CRAN
#> 127           purrr      0.3.4   CRAN
#> 128            qpdf        1.1   CRAN
#> 129        quantreg       5.93   CRAN
#> 130        rappdirs      0.3.3   CRAN
#> 131           readr      2.1.2   CRAN
#> 132          readxl      1.4.0   CRAN
#> 133         rematch      1.0.1   CRAN
#> 134        rematch2      2.1.2   CRAN
#> 135           rlang      1.0.2   CRAN
#> 136       rmarkdown       2.14   CRAN
#> 137        roxygen2      7.1.2   CRAN
#> 138       rprojroot      2.0.3   CRAN
#> 139         rstatix      0.7.0   CRAN
#> 140      rstudioapi       0.13   CRAN
#> 141             rvg      0.2.5   CRAN
#> 142          scales      1.2.0   CRAN
#> 143           shiny      1.7.1   CRAN
#> 144    shinyWidgets      0.6.4   CRAN
#> 145 shinycssloaders      1.0.0   CRAN
#> 146       snakecase     0.11.0   CRAN
#> 147     sourcetools      0.1.7   CRAN
#> 148              sp      1.4-7   CRAN
#> 149        spelling        2.2   CRAN
#> 150         stringi      1.7.6   CRAN
#> 151         stringr      1.4.0   CRAN
#> 152        survival     3.2-13   CRAN
#> 153             sys        3.4   CRAN
#> 154     systemfonts      1.0.4   CRAN
#> 155        testthat      3.1.4   CRAN
#> 156          tibble      3.1.7   CRAN
#> 157           tidyr      1.2.0   CRAN
#> 158      tidyselect      1.1.2   CRAN
#> 159         tinytex       0.38   CRAN
#> 160            tzdb      0.3.0   CRAN
#> 161         usethis      2.1.5   CRAN
#> 162            utf8      1.2.2   CRAN
#> 163            uuid      1.1-0   CRAN
#> 164           vctrs      0.4.1   CRAN
#> 165     viridisLite      0.4.0   CRAN
#> 166           vroom      1.5.7   CRAN
#> 167          waiter      0.2.5   CRAN
#> 168           waldo      0.4.0   CRAN
#> 169         whisker        0.4   CRAN
#> 170           withr      2.5.0   CRAN
#> 171            xfun       0.31   CRAN
#> 172            xml2      1.3.3   CRAN
#> 173          xtable      1.8-4   CRAN
#> 174            yaml      2.3.5   CRAN
#> 175     yulab.utils      0.0.4   CRAN
#> 176             zip      2.2.0   CRAN
```
