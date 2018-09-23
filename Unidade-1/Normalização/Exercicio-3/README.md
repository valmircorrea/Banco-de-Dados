## Exercicio 3

Dada a relação abaixo, faça a normalização da 1FN até a 3FN, indicando cada passo.

Funcionario NN (matricula, nome, dtNasc, genero, rg, endereco, telefone, dtAdmissao,
                (cargo, dtInicioCargo, dtFimCargo), (nomeDependente, dtNascDependente))

--------------------------------------------------------------------------------------------

**1º FN:**

Funcionario = {matricula, nome, dtNasc, genero, rg, dtAdmissao, endereço}

Telefone = {matricula, numeroTelefone}

Cargo = {matricula, cargo, dtInicioCargo, dtFimCargo, nomeDependente, dtNascDependente}

--------------------------------------------------------------------------------------------

**2º FN:**

Funcionario = {matricula, nome, dtNasc, genero, rg, dtAdmissao}

Endereco = {matricula, logradouro, numero, bairro, cidade, estado}

Telefone = {matricula, numeroTelefone}

Funcionario_Cargo = {matricula, idCargo,  dtInicioCargo, dtFimCargo, nomeDependente, dtNascDependente}

Cargo = {idCargo, NomeCargo }

--------------------------------------------------------------------------------------------

**3º FN:**

Funcionario = {matricula, nome, dtNasc, genero, rg, dtAdmissao}

Endereco = {matricula, logradouro, numero, bairro, cidade, estado}

Telefone = {matricula, numeroTelefone}

Funcionario_Cargo = {matricula, idCargo,  dtInicioCargo, dtFimCargo, nomeDependente, dtNascDependente}

Cargo = {idCargo, NomeCargo}

Funcionario_Dependente = {matricula, idDependente}

Dependente = {idDependente, nomeDependente, dtNascDependente}