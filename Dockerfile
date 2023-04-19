FROM rocker/verse:4.2.1
RUN apt-get update && apt-get install -y  cmake imagemagick libcurl4-openssl-dev libicu-dev libmagic-dev libmagick++-dev libpng-dev libpoppler-cpp-dev libssl-dev libxml2-dev make pandoc zlib1g-dev && rm -rf /var/lib/apt/lists/*
RUN mkdir -p /usr/local/lib/R/etc/ /usr/lib/R/etc/
RUN echo "options(repos = c(CRAN = 'https://cran.rstudio.com/'), download.file.method = 'libcurl', Ncpus = 4)" | tee /usr/local/lib/R/etc/Rprofile.site | tee /usr/lib/R/etc/Rprofile.site
RUN R -e 'install.packages("remotes")'
RUN Rscript -e 'remotes::install_version("magrittr",upgrade="never", version = "2.0.3")'
RUN Rscript -e 'remotes::install_version("htmltools",upgrade="never", version = "0.5.5")'
RUN Rscript -e 'remotes::install_version("IDEATools",upgrade="never", version = "3.4.1")'
RUN Rscript -e 'remotes::install_version("dplyr",upgrade="never", version = "1.1.1")'
RUN Rscript -e 'remotes::install_version("ggplot2",upgrade="never", version = "3.4.2")'
RUN Rscript -e 'remotes::install_version("tidyr",upgrade="never", version = "1.3.0")'
RUN Rscript -e 'remotes::install_version("shiny",upgrade="never", version = "1.7.4")'
RUN Rscript -e 'remotes::install_version("DBI",upgrade="never", version = "1.1.3")'
RUN Rscript -e 'remotes::install_version("data.table",upgrade="never", version = "1.14.8")'
RUN Rscript -e 'remotes::install_version("config",upgrade="never", version = "0.3.1")'
RUN Rscript -e 'remotes::install_version("shinyWidgets",upgrade="never", version = "0.7.6")'
RUN Rscript -e 'remotes::install_version("shinyjs",upgrade="never", version = "2.1.0")'
RUN Rscript -e 'remotes::install_version("RSQLite",upgrade="never", version = "2.2.20")'
RUN Rscript -e 'remotes::install_version("plotly",upgrade="never", version = "4.10.1")'
RUN Rscript -e 'remotes::install_version("golem",upgrade="never", version = "0.3.5")'
RUN Rscript -e 'remotes::install_version("DT",upgrade="never", version = "0.26")'
RUN Rscript -e 'remotes::install_version("bs4Dash",upgrade="never", version = "2.2.1")'
RUN Rscript -e 'remotes::install_version("tinytex",upgrade="never", version = "0.45")'
RUN Rscript -e 'remotes::install_github("rstudio/sass@2f1f152d84c162ccb9aba1c056e3548079d669d9")'
RUN mkdir /build_zone
ADD . /build_zone
WORKDIR /build_zone
RUN R -e 'remotes::install_local(upgrade="never")'
RUN rm -rf /build_zone
EXPOSE 3838
CMD R -e "options('shiny.port'=3838,shiny.host='0.0.0.0');ShinyIDEA::run_app()"
