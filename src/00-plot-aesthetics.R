#' Paleta de cores Achados e pedidos
cores_aep <- c(
  laranja = "#fcaa27",
  rosa = "#D81755",
  cinza = "#969696",
  marrom = "#B27D5C"
)

#' Paleta de cores Transparência Brasil
cores_tb <- c(
  laranja = "#F6A323",
  cinza_escuro = "#1d1d1b",
  cinza_claro = "#6f7171",
  cinza_quase_branco = "#ececec",
  azul = "#41ACBD"
)

# cores despesas
cores_despesas <- c(
  empenhos_item = cores_aep[["marrom"]],
  empenhos = cores_aep[["rosa"]],
  liquidacao_empenhos_impactados = cores_aep[["laranja"]],
  liquidacao = cores_tb[["azul"]]
)

# cores para especies de empenho
cores_especie_empenhos_raw <- c(
  "REFORÇO" = cores_tb[["laranja"]],
  "ORIGINAL" = cores_tb[["azul"]],
  "ANULAÇÃO" = cores_aep[["cinza"]],
  "CANCELAMENTO" = cores_tb[["cinza_quase_branco"]],
  "ESTORNO" = "white",
  "Inválido" = "white",
  "Não se aplica" = cores_aep[["rosa"]]
)

# ores para especies de empenho
cores_especie_empenhos <- c(
  "REFORÇO" = cores_tb[["laranja"]],
  "ORIGINAL" = cores_tb[["azul"]],
  "ANULAÇÃO" = cores_aep[["cinza"]],
  "CANCELAMENTO" = cores_tb[["cinza_quase_branco"]],
  "ESTORNO" = "white",
  "Não se aplica" = cores_aep[["rosa"]]
)

cores_fase_operacao_2019_2020 <- c(
  "Empenho ORIGINAL" = cores_tb[["azul"]],
  "Empenho REFORÇO" = cores_aep[["laranja"]],
  "Empenho ANULAÇÃO" = cores_aep[["rosa"]],
  "Empenho CANCELAMENTO" = cores_tb[["cinza_quase_branco"]],
  "Liquidação" = cores_aep[["marrom"]]
)

cores_fase_operacao_2021_2022 <- c(
  "Empenho - Anulação" = cores_aep[["rosa"]],
  "Empenho - Reforço" = cores_aep[["laranja"]],
  "Empenho - Inclusão" = cores_tb[["azul"]],
  "Liquidação" = cores_aep
)

# uso de fontes e plot-aesthetics
library(ggplot2)
hrbrthemes::import_roboto_condensed()
extrafont::loadfonts()
ggplot2::theme_set(hrbrthemes::theme_ipsum_rc())

# theme_set(theme_minimal())

theme_update(
  panel.grid.minor = element_blank(),
  panel.background = element_rect(fill = "gray97", color = "transparent"),
  axis.line.y = element_blank(),
  axis.line.x = element_line(color = "gray30"),
  text = element_text(family = "Roboto Condensed"),
  panel.grid.major.x = element_blank(),
  panel.grid.major.y = element_line(color = "gray60")
)

reais <- function(x) scales::dollar(x, prefix = "R$ ", accuracy = 1.0, big.mark = ".", decimal.mark = ",")

reais_milhoes <- function(x) {
  scales::number(
    x / 1e6,
    prefix = "R$ ",
    big.mark = ".",
    decimal.mark = ",",
    suffix = "Mi",
    accuracy = 0.100
  )
}
hrbrthemes::update_geom_font_defaults(
  color = "gray30",
  family = "Roboto Condensed"
)
