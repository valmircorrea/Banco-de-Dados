## Exercicio 4

Dada a relação abaixo, faça a normalização da 1FN até a 3FN, indicando cada passo.

Paciente NN (codPaciente, nomePaciente, dtNasc, genero, convenio, estadoCivil, rg, telefone,
            endereco, (codConsulta, data, medico, diagnostico, (exame, data)))

--------------------------------------------------------------------------------------------

**1º FN:**

Paciente = {codPaciente, nomePaciente, dtNasc, genero, convenio, estadoCivil, rg, endereco}

Endereco = {codPaciente, logradouro, numero, bairro, cidade, estado}

Telefone = {codPaciente, numeroTelefone}

Consulta = {codConsulta, data, medico, diagnostico}

Exame = {codPaciente, codConsulta, codExame, tipo, data}

--------------------------------------------------------------------------------------------

**2º FN:**

Paciente = {codPaciente, nomePaciente, dtNasc, genero, estadoCivil, rg}

Endereco = {codPaciente, logradouro, numero, bairro, cidade, estado}

Telefone = {codPaciente, numeroTelefone}

Convenio = {codConvenio, nomeConvenio}

Paciente_Convenio = {codPaciente, codConvenio}

Consulta = {codConsulta, codPaciente, codMedico, data, diagnostico}

Exame = {codConsulta, codExame, nomeExame}

Medico = {codMedico, nomeMedico, crm}

--------------------------------------------------------------------------------------------

**3º FN:**

Paciente = {codPaciente, nomePaciente, dtNasc, genero, estadoCivil, rg}

Endereco = {codPaciente, logradouro, numero, bairro, cidade, estado}

Telefone = {codPaciente, numeroTelefone}

Convenio = {codConvenio, nomeConvenio}

Paciente_Convenio = {codPaciente, codConvenio}

Consulta = {codConsulta, codMedico, data, diagnostico}

Consulta_Exame = {codConsulta, codExame, dataExame}

Exame = {codExame, nomeExame}

Medico = {codMedico, nomeMedico, crm}