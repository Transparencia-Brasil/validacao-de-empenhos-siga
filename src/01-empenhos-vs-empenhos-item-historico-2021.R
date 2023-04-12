library(tidyverse)
library(here)
library(glue)
library(colorspace)
source(here("src/00-plot-aesthetics.R"), encoding = "utf-8")

# Empenhos
empenhos <- "data/empenhos.rds" %>%
  here() %>%
  readRDS() %>%
  filter(year(data_emissao) == 2021)

empenhos %>%
  filter(codigo_empenho == "257052000012021NE000021") %>%
  glimpse()

"data/empenhos.rds" %>%
  here() %>%
  readRDS() %>%
    filter(codigo_empenho == "257052000012021NE000021") %>%
    glimpse()

# Empenhos itens histórico
empenhos_tens_historico <- "data/empenhos-item-historico.rds" %>%
  here() %>%
  readRDS() %>%
  filter(codigo_empenho %in% unique(empenhos$codigo_empenho))

# Quantos empenhos nós temos?
n_distinct(empenhos$codigo_empenho)

# Somando base de empenhos
soma_empenhos <- sum(empenhos$valor_do_empenho_convertido_pra_r)

# Somando itens histórico - sem tratamento nenhum
soma_empenhos_tens_historico_bruto <- sum(empenhos_tens_historico$valor_total_item)

# Somando itens histórico - somente desconta anulação
soma_empenhos_tens_historico_descontando_anulacao <- empenhos_tens_historico %>%
  mutate(valor_total_item = if_else(tipo_operacao == "ANULACAO", valor_total_item * -1, valor_total_item)) %>%
  summarise(valor_total_item = sum(valor_total_item)) %>%
  pull(valor_total_item)

# Vamos criar uma base com as agregações
comparativo <- tibble(
  base_empenho = c(
    " ",
    "Anulação não descontada",
    "Anulação descontada"
  ),
  valor = c(
    soma_empenhos,
    soma_empenhos_tens_historico_bruto,
    soma_empenhos_tens_historico_descontando_anulacao
  )
)

comparativo %>%
  add_row(
    base_empenho = "Anulação descontada\nempenhos duplicados\nproblemáticos",
    valor = valores_oks$n[1]
  ) %>%
  add_row(
    base_empenho = rep("Anulação descontada\nempenhos duplicados\nproblemáticos", 2),
    valor = valores_errados$n[2]
  ) %>%
  add_row(
    base_empenho = "Anulação descontada\ntratamento em\nempenhos duplicados",
    valor = valores_oks$n[1]
  ) %>%
  add_row(
    base_empenho = "Anulação descontada\ntratamento em\nempenhos duplicados",
    valor = valores_errados$n[2]
  ) %>%
  mutate(base_empenho = ordered(base_empenho, levels = c(
    " ",
    "Anulação não descontada",
    "Anulação descontada",
    "Anulação descontada\nempenhos duplicados\nproblemáticos",
    "Anulação descontada\ntratamento em\nempenhos duplicados"
  ))) %>%
  ggplot(aes(
    x = base_empenho,
    y = valor,
    fill = base_empenho,
    color = after_scale(colorspace::darken(fill, .7))
  )) +
  geom_col(show.legend = FALSE) +
  geom_hline(yintercept = soma_empenhos) +
  geom_text(check_overlap = TRUE, aes(
    y = soma_empenhos + 3e6,
    x = " ",
    label = "Somatória da base de empenhos"
  ), color = "black") +
  geom_text(
    data = . %>% filter(base_empenho != " "),
   size = 5,
    position = position_stack(vjust = .5),
    aes(
      label = scales::number(valor)
    )
  ) +
  geom_text(check_overlap = TRUE, aes(
    y = soma_empenhos - 3e6,
    x = " ",
    label = scales::number(valor)
  ), color = "black") +
  scale_fill_manual(values = c(
    " " = "transparent",
    "Anulação não descontada" = lighten(cores_aep[["rosa"]], .5),
    "Anulação descontada" = lighten(cores_aep[["rosa"]], .25),
    "Anulação descontada\ntratamento em\nempenhos duplicados" = lighten(cores_aep[["rosa"]], 0.125),
    "Anulação descontada\nempenhos duplicados\nproblemáticos" = cores_aep[["rosa"]]
  )) +
  scale_y_continuous(labels = scales::number)


valores_oks <- empenhos_tens_historico %>%
  mutate(valor_total_item = if_else(
    tipo_operacao == "ANULACAO", valor_total_item * -1, valor_total_item)
  ) %>%
  count(codigo_empenho, wt = valor_total_item, name = "valor_em_historico_item") %>%
  left_join(
    empenhos %>% select(codigo_empenho, valor_empenho = valor_do_empenho_convertido_pra_r)
  ) %>%
  mutate(
    compara = round(valor_em_historico_item, 2) == round(valor_empenho, 2)
  ) %>%
  filter(compara) %>%
  pivot_longer(
    -c(codigo_empenho, compara),
    names_to = "id", values_to = "vlr"
  ) %>%
  count(id, wt = vlr)

valores_errados <- empenhos_tens_historico %>%
  mutate(valor_total_item = if_else(
    tipo_operacao == "ANULACAO", valor_total_item * -1, valor_total_item)
  ) %>%
  count(codigo_empenho, wt = valor_total_item, name = "valor_em_historico_item") %>%
  left_join(
    empenhos %>% select(codigo_empenho, valor_empenho = valor_do_empenho_convertido_pra_r)
  ) %>%
  mutate(
    compara = round(valor_em_historico_item, 2) == round(valor_empenho, 2)
  ) %>%
  filter(!compara) %>%
  pivot_longer(
    -c(codigo_empenho, compara),
    names_to = "id", values_to = "vlr"
  ) %>%
  count(id, wt = vlr) %>%
    pivot_wider(names_from = id, values_from = n) %>%
    mutate(valor_em_historico_item / valor_empenho)

empenhos %>% count(wt = valor_do_empenho_convertido_pra_r)

49094863 -
  24547431

"257052000012021NE000230"