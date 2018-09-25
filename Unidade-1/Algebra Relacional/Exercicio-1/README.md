# Exercicio 1

**Esquema relacional:**

* Médicos(IdMedico, CRM, RG, nome, dtNasc, cidade, especialidade).

* Pacientes (IdPaciente, RG, nome, dtNasc, cidade).

* Consultas (IdConsulta, IdMedico, IdPaciente, data, hora).

* Funcionários (IdFuncionario, RG, nome, dtNasc, cidade, salario).

**Resolva usando Algebra Relacional:**

1 - Buscar os nomes e RGs dos médicos e pacientes cadastrados no hospital:
* (**π**Nome, RG (Medicos)) U (**π**Nome, RG (Pacientes))

2 - Buscar os nomes, RGs e datas de nascimento dos médicos, pacientes e funcionários que residem em Parnamirim:
* (**π**Nome, RG, dataNasc (**σ**cidade = 'Parnamirim'(Medicos))) U
  
  (**π**Nome, RG, dataNasc (**σ**cidade = 'Parnamirim'(Pacientes))) U

  (**π**Nome, RG, dataNasc (**σ**cidade = 'Parnamirim'(Funcionários)))

3 - Buscar os nomes e RGs dos funcionários que recebem salários abaixo de R$ 800,00:
* (**π**Nome, RG(**σ**Salário < 800.00 (Funcionários)))

4 - Buscar os nomes e RGs dos funcionários que estão internados como pacientes:
* (**π**Nome, RG(**σ**Funcionario.RG = **σ**Paciente.RG) (Funcionários **X** Pacientes))

5 - Buscar o nomes e RGs dos médicos que têm consultas marcadas para 09/03/2015:
* (**π**Nome, RG (**σ**Medico.IdMedico = **σ**Consultas.IdMedico ^ Consultas.data = '09/03/2015'(Consultas **X** Médicos))