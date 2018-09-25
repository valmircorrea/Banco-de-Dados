# Exercicio 1

**Esquema relacional:**

* Funcionario = (matricula, nome, dtNasc, genero, rg, endereco)

* Telefone = {idTelefone, numeroTelefone, matricula}

* Cargo = {idCargo, nomeCargo}

* Funcionario_Cargo = {matricula, cargo, dtInicioCargo, dtFimCargo}

* Dependente = {codDependente, nomeDependente, dtNascDependente, matricula}

**Resolva usando Algebra Relacional:**

1 - Mostrar o nome do dependente e a data de nascimento, assim como o nome de todos os funcionários que tenham dependentes;
* **π**NomeDependente, dataNascDependente, nome(Funcionários **|><|** Dependentes)

2 - Mostrar o nome de todos os funcionários que não tenham dependentes.
* **π**Nome(Funcionarios) - **π**Nome(Funcionarios **|><|** Dependentes)