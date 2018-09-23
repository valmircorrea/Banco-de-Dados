## Exercicio 2

Dada a relação abaixo, faça a normalização da 1FN até a 3FN, indicando cada passo.

Pesquisador (codPesquisador, nomePesquisador, (codArtigo, tituloArtigo, paginaInicial,
                paginaFinal, codPeriodico, nomePeriodico))

--------------------------------------------------------------------------------------------

**1º FN:**

Pesquisador = {codPesquisador, nomePesquisador}

Artigo = {codPesquisador, codArtigo, tituloArtigo, paginaInicial, paginaFinal, codPeriodico, nomePeriodico}

--------------------------------------------------------------------------------------------

**2º FN:**

Pesquisador = {codPesquisador, nomePesquisador}

Publicações = {codPesquisador, codArtigo}

Artigo = {codArtigo, tituloArtigo, paginaInicial, paginaFinal, codPeriodico, nomePeriodico}

--------------------------------------------------------------------------------------------

**3º FN:**

Pesquisador = {codPesquisador, nomePesquisador}

Publicações = {codPesquisador, codTipo}

Tipo = {codTipo, codArtigo, codPeriodico}

Artigo = {codArtigo, tituloArtigo, paginaInicial, paginaFinal}

Periodico = {codPeriodico, nomePeriodico}
