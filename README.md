# Validação de empenhos na plataforma SIGA

Coletamos os dados de empenhos do [Portal da Transparência](https://portaldatransparencia.gov.br/download-de-dados/despesas) e comparamos a agregação dos valores empenhados por ano com os mesmos dados consultados na plataforma [SIGA](https://www12.senado.leg.br/orcamento/sigabrasil). Temos dúvidas se a plataforma SIGA considera anulações de empenhos na demonstração de valores agregados a partir de 2021, pois o campo `especie_empenho` está marcado como `"Não aplicável"`.

O campo `especie_empenho` é definido no [dicionário de dados do Portal da Transparência como](https://portaldatransparencia.gov.br/pagina-interna/605513-dicionario-de-dados-empenho):

> Campo existente até 2020 indicando se o Empenho era de Reforço, Cancelamento, Estorno, Anulação ou Original. A partir de 2021, as alterações no Empenho são registradas em histórico do próprio Empenho original (planilha AAAAMMDD_Despesas_ItemEmpenhoHistorico.csv).

A documentação desta análise pode ser consultada [NESTE RELATÓRIO](transparencia-brasil.github.io\docs\01-validacao-empenhos.html)
