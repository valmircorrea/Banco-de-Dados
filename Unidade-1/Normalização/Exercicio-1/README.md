## Exercicio 1

Dada a relação abaixo, faça a normalização da 1FN até a 3FN, indicando cada passo.

Projetos    ( codProjeto, tipo, descrição,
             (codEmpregado, nome, categoria, salário),
             (dataInício, tempoAlocação) )

-----------------------------------------------------------------------------------------------

**1º FN:**

   Projetos = {codProjeto, tipo, descrição}

   Alocações = {codProjeto, codEmpregado, nome, categoria, salário, dataInício, tempoAlocação}
   
**2º FN:**

   Projetos = {codProjeto, tipo, descrição}

   Alocações = {codProjeto, codEmpregado, dataInício, tempoAlocação}

   Empregado = {codEmpregado, nome, categoria, salário}

**3º FN:**

   Projetos = {codProjeto, tipo, descrição}

   Alocações = {codProjeto, codEmpregado, dataInício, tempoAlocação}

   Empregado = {codEmpregado, nome, codCategoria}

   Categoria = {codCategoria, categoria, salário}