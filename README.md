
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

- LaTeX (`tinytex::install_tinytex()` should be enough)

- The following R package from Github :

``` r
remotes::install_github("rstudio/sass")
```

- The following R packages from CRAN :

``` r
dplyr::filter(rsconnect::appDependencies(), source == "CRAN")
```
