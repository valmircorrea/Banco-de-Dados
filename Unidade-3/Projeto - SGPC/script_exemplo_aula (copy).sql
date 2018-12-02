﻿﻿﻿/* $$$$$$$$$$$$$$$$$$ CRIAÇÃO DAS TABELAS E INDICES $$$$$$$$$$$$$$$$$$ */
/* Criação da Tabela Endereco */
CREATE TABLE Endereco (
  idEndereco serial NOT NULL UNIQUE,
  logradouro VARCHAR(20) NULL,
  cep CHAR(8) NULL,
  numero INTEGER NULL,
  complemento VARCHAR(25) NULL,
  cidade VARCHAR(20) NULL,
  bairro VARCHAR(20) NULL,
  estado CHAR(2) NULL,
  PRIMARY KEY(idEndereco)
);

INSERT INTO Endereco(logradouro, cep, numero, complemento, cidade, bairro, estado) 
VALUES ('rua 1', '59000000', 20, 'proximo a ufrn', 'natal', 'lagoa nova', 'rn');
INSERT INTO Endereco(logradouro, cep, numero, cidade, bairro, estado) 
VALUES ('rua joao castro', '59063000', 1024, 'natal', 'candelaria', 'rn');
INSERT INTO Endereco(logradouro, numero, complemento, cidade, bairro, estado) 
VALUES ('avenida berlim', 502, 'apto 300', 'parnamirim', 'rosa dos ventos', 'rn');

/* Criação da Tabela Pessoa */
CREATE TABLE Pessoa (
  idPessoa serial NOT NULL UNIQUE,
  idEndereco INTEGER NOT NULL REFERENCES Endereco ON DELETE RESTRICT,
  nome VARCHAR(50) NULL,
  email VARCHAR(25) NULL,
  PRIMARY KEY(idPessoa)
);

SET enable_seqscan To OFF;
CREATE UNIQUE INDEX pessoa_endereco_idx ON Pessoa (idEndereco);

INSERT INTO Pessoa(idEndereco, nome, email) VALUES (1, 'Empresa 1', 'empresa1@email.com'); 
INSERT INTO Pessoa(idEndereco, nome, email) VALUES (2, 'Cliente 1', 'cliente1@email.com');
INSERT INTO Pessoa(idEndereco, nome, email) VALUES (3, 'Funcionario 1', 'funcionario1@email.com');
INSERT INTO Pessoa(nome, email) VALUES ('Teste 1', 'teste1@email.com'); -- Dará erro
INSERT INTO Pessoa(idEndereco, nome, email) VALUES (3, 'Teste 1', 'teste1@email.com'); -- Dará erro

--DELETE FROM Endereco WHERE idEndereco = 1; 

Select * from Pessoa;

/* Criação da Tabela Telefone */
CREATE TABLE Telefone (
  idTelefone serial NOT NULL UNIQUE,
  idPessoa INTEGER NOT NULL REFERENCES Pessoa ON DELETE RESTRICT,
  ddd CHAR(2) NULL,
  numero VARCHAR(9) NULL,
  tipo VARCHAR NOT NULL CHECK (tipo = 'RESIDENCIAL' or tipo = 'COMERCIAL' or tipo = 'MOVEL'),
  PRIMARY KEY(idTelefone)
);

INSERT INTO Telefone(idPessoa, ddd, numero, tipo) VALUES (1, '84', '30024922', 'COMERCIAL');
INSERT INTO Telefone(idPessoa, ddd, numero, tipo) VALUES (2, '84', '30045922', 'RESIDENCIAL');
INSERT INTO Telefone(idPessoa, ddd, numero, tipo) VALUES (3, '84', '998430765', 'MOVEL');
INSERT INTO Telefone(ddd, numero, tipo) VALUES ('84', '998430765', 'MOVEL'); -- Dará erro
INSERT INTO Telefone(idPessoa, ddd, numero, tipo) VALUES (3, '84', '998430765', 'TESTE'); -- Dará erro

/* Criação da Tabela Empresa */
CREATE TABLE Empresa (
  idEmpresa serial NOT NULL UNIQUE,
  idPessoa INTEGER NOT NULL REFERENCES Pessoa ON DELETE RESTRICT,
  razaoSocial VARCHAR(30) NULL,
  cnpj CHAR(14) NULL,
  PRIMARY KEY(idEmpresa)
);

CREATE UNIQUE INDEX empresa_pessoa_idx ON Empresa (idPessoa);

INSERT INTO Empresa(idPessoa, razaoSocial, cnpj) VALUES (1, 'Empresa 1 ME', '12345678910111');

/* Criação da Tabela Cliente */
CREATE TABLE Cliente (
  idCliente serial NOT NULL UNIQUE,
  idPessoa INTEGER NOT NULL REFERENCES Pessoa ON DELETE RESTRICT,
  idEmpresa INTEGER NOT NULL REFERENCES Empresa ON DELETE RESTRICT,
  cpf CHAR(11) NULL,
  PRIMARY KEY(idCliente)
);

CREATE UNIQUE INDEX cliente_pessoa_idx ON Cliente (idPessoa);
CREATE UNIQUE INDEX cliente_empresa_idx ON Cliente USING BTREE (idCliente, idEmpresa);

INSERT INTO Cliente(idPessoa, idEmpresa, cpf) VALUES (2, 1, '01234567891');
INSERT INTO Cliente(idPessoa, idEmpresa, cpf) VALUES (2, 1, '01234567891'); -- Dará erro
INSERT INTO Cliente(idPessoa, cpf) VALUES (2, '01234567891'); -- Dará erro

select * from Cliente;
--delete from Cliente;

/* Criação da Tabela Funcionario */
CREATE TABLE Funcionario (
  idFuncionario serial NOT NULL UNIQUE,
  idPessoa INTEGER NOT NULL REFERENCES Pessoa,
  idEmpresa INTEGER NOT NULL REFERENCES Empresa,
  cpf CHAR(11) NULL,
  cargo VARCHAR(15) NULL,
  salario FLOAT NULL,
  NIS CHAR(11) NULL,
  PRIMARY KEY(idFuncionario)
);

CREATE UNIQUE INDEX funcionario_pessoa_idx ON Funcionario (idPessoa);
CREATE UNIQUE INDEX funcionario_empresa_idx ON Funcionario USING BTREE (idFuncionario, idEmpresa);

INSERT INTO Funcionario(idPessoa, idEmpresa, cpf, cargo, salario, NIS)
VALUES (3, 1, '12345678910', 'tecnico', 954, '11111111111');

/* Criação da Tabela Equipamento */
CREATE TABLE Equipamento (
  idEquipamento serial NOT NULL UNIQUE,
  idCliente INTEGER NOT NULL REFERENCES Cliente ON DELETE RESTRICT,
  modelo VARCHAR(15) NULL,
  estadoConservacao VARCHAR NOT NULL CHECK (
	estadoConservacao = 'RUIM' or
	estadoConservacao = 'BOM' or
	estadoConservacao = 'OTIMO'
  ),
  defeito VARCHAR(50) NULL,
  acessorios VARCHAR(30) NULL,
  tipo VARCHAR NOT NULL CHECK (
	tipo = 'SMARTPHONE' or
	tipo = 'TABLET'
  ),
  observacoes VARCHAR(50) NULL,
  PRIMARY KEY(idEquipamento)
);

CREATE UNIQUE INDEX equipamento_cliente_idx ON Equipamento USING BTREE (idEquipamento, idCliente);

INSERT INTO Equipamento(idCliente, modelo, estadoConservacao, defeito, acessorios, tipo, observacoes)
VALUES (1, 'galaxy s6', 'BOM', 'tela não funciona', 'chip', 'SMARTPHONE', 'tampa traseira trincada');
INSERT INTO Equipamento(idCliente, modelo, estadoConservacao, defeito, acessorios, tipo, observacoes)
VALUES (1, 'galaxy s7', 'RUIM', 'Sem sinal de chip', 'nenhum', 'SMARTPHONE', 'aparelho muito arranhado');
INSERT INTO Equipamento(idCliente, modelo, estadoConservacao, defeito, tipo)
VALUES (1, 'LG TAB G', 'OTIMO', 'conector de carga ruim', 'TABLET');
INSERT INTO Equipamento(idCliente, modelo, estadoConservacao, defeito, tipo)
VALUES (1, 'Iphone Xs Max', 'OTIMO', 'Camera embaçada', 'SMARTPHONE');

/* Criação da Tabela Serviço */
CREATE TABLE Servico (
  idServico serial NOT NULL UNIQUE,
  idFuncionario INTEGER NOT NULL REFERENCES Funcionario ON DELETE RESTRICT,
  servicoFeito VARCHAR(50) NULL,
  analise VARCHAR(100) NULL,
  PRIMARY KEY(idServico)
);

CREATE UNIQUE INDEX servico_funcionario_idx ON Servico USING BTREE (idServico, idFuncionario);

INSERT INTO Servico (idFuncionario, servicoFeito, analise) 
VALUES (1, 'troca do display', 'o display do aparelho não estava funcionando mais, devido a uma queda');

/* Criação da Tabela Garantia */
CREATE TABLE Garantia (
  idGarantia serial NOT NULL UNIQUE,
  tempoGarantia INTEGER NULL,
  dataInicio DATE NULL,
  PRIMARY KEY(idGarantia)
);

INSERT INTO Garantia(tempoGarantia, dataInicio) VALUES (90, now());

/* Criação da Tabela OrdemServico */
CREATE TABLE OrdemServico (
  idOrdemServico serial NOT NULL UNIQUE,
  idEquipamento INTEGER NOT NULL REFERENCES Equipamento ON DELETE RESTRICT,
  idServico INTEGER NULL REFERENCES Servico ON DELETE RESTRICT,
  idGarantia INTEGER NULL REFERENCES Garantia ON DELETE RESTRICT,
  dataEntrada DATE NULL,
  situacao VARCHAR NOT NULL CHECK ( situacao = 'ORCAMENTO' or situacao = 'AGUARDANDO' or situacao = 'APROVADO' or situacao = 'FINALIZADO'),
  valor FLOAT NULL,
  pago CHAR(1) NOT NULL CHECK (pago = 'S' or pago = 'N'),
  dataSaida DATE NULL,
  PRIMARY KEY(idOrdemServico)
);

CREATE UNIQUE INDEX os_equipamento_idx ON OrdemServico (idEquipamento);
CREATE UNIQUE INDEX os_servico_idx ON OrdemServico (idServico);
CREATE UNIQUE INDEX os_garantia_idx ON OrdemServico (idGarantia);

INSERT INTO OrdemServico (idEquipamento, idServico, idGarantia, dataEntrada, situacao, valor, pago, dataSaida)
VALUES (1, 1, 1, now(), 'FINALIZADO', 252, 'S', now());
INSERT INTO OrdemServico (idEquipamento, dataEntrada, situacao, valor, pago, dataSaida)
VALUES (2, now(), 'FINALIZADO', 252, 'S', now());

select * from OrdemServico;
--delete from OrdemServico where idOrdemServico = 2;

/* $$$$$$$$$$$$$$$$$$ FUNÇÕES E TRIGGERS $$$$$$$$$$$$$$$$$$ */
/* Proibindo nome nulo em update e insert de Pessoa */
CREATE FUNCTION pessoa_gatilho() RETURNS TRIGGER AS $pessoa_gatilho$
BEGIN
	IF NEW.nome IS null THEN
		RAISE EXCEPTION 'A pessoa não pode ter nome nulo';
	END IF;
RETURN NEW;
END;
$pessoa_gatilho$ LANGUAGE plpgsql;

CREATE TRIGGER pessoa_insert BEFORE INSERT OR UPDATE
ON Pessoa
FOR EACH ROW EXECUTE
PROCEDURE pessoa_gatilho();

INSERT INTO Pessoa(idEndereco, email) VALUES (1, 'empresa1@email.com');

/* Função para regras de negocio de Endereco */
CREATE FUNCTION endereco_gatilho() RETURNS TRIGGER AS $endereco_gatilho$
BEGIN
	IF NEW.logradouro IS NULL THEN 
		RAISE EXCEPTION 'O logradouro do endereço não pode ser nulo';
	END IF;
	IF NEW.numero IS NULL THEN 
		RAISE EXCEPTION 'O numero do endereço não pode ser nulo';
	END IF;
	IF NEW.cidade IS NULL THEN 
		RAISE EXCEPTION 'A cidade do endereço não pode ser nulo';
	END IF;
	IF NEW.bairro IS NULL THEN 
		RAISE EXCEPTION 'O bairro do endereço não pode ser nulo';
	END IF;
	IF NEW.estado IS NULL THEN
		RAISE EXCEPTION 'O estado do endereço não pode ser nulo';
	END IF;
RETURN NEW;
END;
$endereco_gatilho$ LANGUAGE plpgsql;

CREATE TRIGGER endereco_insert BEFORE INSERT OR UPDATE
ON Endereco
FOR EACH ROW EXECUTE
PROCEDURE endereco_gatilho();

INSERT INTO Endereco(cep, numero, complemento, cidade, bairro, estado) 
VALUES ('59000000', 20, 'proximo a ufrn', 'natal', 'lagoa nova', 'rn');
INSERT INTO Endereco(logradouro, cep, complemento, cidade, bairro, estado) 
VALUES ('rua 1', '59000000','proximo a ufrn', 'natal', 'lagoa nova', 'rn');
INSERT INTO Endereco(logradouro, cep, numero, complemento, bairro, estado) 
VALUES ('rua 1', '59000000', 20, 'proximo a ufrn', 'lagoa nova', 'rn');
INSERT INTO Endereco(logradouro, cep, numero, complemento, cidade,  estado) 
VALUES ('rua 1', '59000000', 20, 'proximo a ufrn', 'natal', 'rn');
INSERT INTO Endereco(logradouro, cep, numero, complemento, cidade, bairro) 
VALUES ('rua 1', '59000000', 20, 'proximo a ufrn', 'natal', 'lagoa nova');

/* Função para regras de negocio de Telefone */
CREATE FUNCTION telefone_gatilho() RETURNS TRIGGER AS $telefone_gatilho$
BEGIN
	IF NEW.ddd IS NULL THEN 
		RAISE EXCEPTION 'O DDD do telefone não pode ser nulo';
	END IF;
	IF NEW.numero IS NULL THEN 
		RAISE EXCEPTION 'O numero do telefone não pode ser nulo';
	END IF;
	IF NEW.tipo IS NULL THEN 
		RAISE EXCEPTION 'O tipo do telefone não pode ser nulo';
	END IF;
RETURN NEW;
END;
$telefone_gatilho$ LANGUAGE plpgsql;

CREATE TRIGGER telefone_insert BEFORE INSERT OR UPDATE
ON Telefone
FOR EACH ROW EXECUTE
PROCEDURE telefone_gatilho();

INSERT INTO Telefone(idPessoa, numero, tipo) VALUES (1, '30024922', 'COMERCIAL');
INSERT INTO Telefone(idPessoa, ddd, tipo) VALUES (1, '84', 'COMERCIAL');
INSERT INTO Telefone(idPessoa, ddd, numero) VALUES (1, '84', '30024922');

/* Função para regras de negocio de cliente */
CREATE FUNCTION cliente_gatilho() RETURNS TRIGGER AS $cliente_gatilho$
BEGIN
	IF NEW.cpf IS NULL THEN 
		RAISE EXCEPTION 'O CPF do Cliente não pode ser nulo';
	END IF;
RETURN NEW;
END;
$cliente_gatilho$ LANGUAGE plpgsql;

CREATE TRIGGER cliente_insert BEFORE INSERT OR UPDATE
ON Cliente
FOR EACH ROW EXECUTE
PROCEDURE cliente_gatilho();

INSERT INTO Cliente(idPessoa, idEmpresa) VALUES (2, 1);

/* Função para regras de negocio de Empresa */
CREATE FUNCTION empresa_gatilho() RETURNS TRIGGER AS $empresa_gatilho$
BEGIN
	IF NEW.razaoSocial IS NULL THEN 
		RAISE EXCEPTION 'A razão social da Empresa não pode ser nula';
	END IF;
	IF NEW.cnpj IS NULL THEN 
		RAISE EXCEPTION 'O CNPJ da Empresa não pode ser nulo';
	END IF;
RETURN NEW;
END;
$empresa_gatilho$ LANGUAGE plpgsql;

CREATE TRIGGER empresa_insert BEFORE INSERT OR UPDATE
ON Empresa
FOR EACH ROW EXECUTE
PROCEDURE empresa_gatilho();

INSERT INTO Empresa(idPessoa, cnpj) VALUES (1, '12345678910111');
INSERT INTO Empresa(idPessoa, razaoSocial) VALUES (1, 'Empresa 1 ME');

/* Função para regras de negocio do Funcionário */
CREATE FUNCTION funcionario_gatilho() RETURNS TRIGGER AS $funcionario_gatilho$
BEGIN
	IF NEW.cpf IS NULL THEN 
		RAISE EXCEPTION 'O CPF do Funcionário não pode ser nulo';
	END IF;
	IF NEW.cargo IS NULL THEN 
		RAISE EXCEPTION 'O cargo do Funcionário não pode ser nulo';
	END IF;
	IF NEW.salario IS NULL THEN 
		RAISE EXCEPTION 'O salário do Funcionário não pode ser nulo';
	END IF;
	IF NEW.salario <= 0 THEN 
		RAISE EXCEPTION 'O salário do Funcionário deve ser maior que 0';
	END IF;
	IF NEW.NIS IS NULL THEN 
		RAISE EXCEPTION 'O NIS do Funcionário não pode ser nulo';
	END IF;
RETURN NEW;
END;
$funcionario_gatilho$ LANGUAGE plpgsql;

CREATE TRIGGER funcionario_insert BEFORE INSERT OR UPDATE
ON Funcionario
FOR EACH ROW EXECUTE
PROCEDURE funcionario_gatilho();

INSERT INTO Funcionario(idPessoa, idEmpresa, cargo, salario, NIS)
VALUES (3, 1, 'tecnico', 954, '11111111111');
INSERT INTO Funcionario(idPessoa, idEmpresa, cpf, salario, NIS)
VALUES (3, 1, '12345678910', 954, '11111111111');
INSERT INTO Funcionario(idPessoa, idEmpresa, cpf, cargo, NIS)
VALUES (3, 1, '12345678910', 'tecnico', '11111111111');
INSERT INTO Funcionario(idPessoa, idEmpresa, cpf, cargo, salario, NIS)
VALUES (3, 1, '12345678910', 'tecnico', 0, '11111111111');
INSERT INTO Funcionario(idPessoa, idEmpresa, cpf, cargo, salario, NIS)
VALUES (3, 1, '12345678910', 'tecnico', -5, '11111111111');
INSERT INTO Funcionario(idPessoa, idEmpresa, cpf, cargo, salario)
VALUES (3, 1, '12345678910', 'tecnico', 954);

/* Função para regras de negocio do Equipamento */
CREATE FUNCTION equipamento_gatilho() RETURNS TRIGGER AS $equipamento_gatilho$
BEGIN
	IF NEW.modelo IS NULL THEN 
		RAISE EXCEPTION 'O modelo do Equipamento não pode ser nulo';
	END IF;
	IF NEW.defeito IS NULL THEN 
		RAISE EXCEPTION 'O defeito do Equipamento não pode ser nulo';
	END IF;
	IF NEW.estadoConservacao IS NULL THEN 
		RAISE EXCEPTION 'O estado de conservação do Equipamento não pode ser nulo';
	END IF;
	IF NEW.tipo IS NULL THEN 
		RAISE EXCEPTION 'O tipo do Equipamento não pode ser nulo';
	END IF;
RETURN NEW;
END;
$equipamento_gatilho$ LANGUAGE plpgsql;

CREATE TRIGGER equipamento_insert BEFORE INSERT OR UPDATE
ON Equipamento
FOR EACH ROW EXECUTE
PROCEDURE equipamento_gatilho();

INSERT INTO Equipamento(idCliente, estadoConservacao, defeito, acessorios, tipo, observacoes)
VALUES (1, 'BOM', 'tela não funciona', 'chip', 'SMARTPHONE', 'tampa traseira trincada');
INSERT INTO Equipamento(idCliente, modelo, defeito, acessorios, tipo, observacoes)
VALUES (1, 'galaxy s6', 'tela não funciona', 'chip', 'SMARTPHONE', 'tampa traseira trincada');
INSERT INTO Equipamento(idCliente, modelo, estadoConservacao, acessorios, tipo, observacoes)
VALUES (1, 'galaxy s6', 'BOM', 'chip', 'SMARTPHONE', 'tampa traseira trincada');
INSERT INTO Equipamento(idCliente, modelo, estadoConservacao, defeito, acessorios, observacoes)
VALUES (1, 'galaxy s6', 'BOM', 'tela não funciona', 'chip', 'tampa traseira trincada');

/* Função para regras de negocio da Ordem se serviço na inserção */
CREATE FUNCTION os_gatilho() RETURNS TRIGGER AS $os_gatilho$
DECLARE
	id_garantia INTEGER;
BEGIN
	IF (TG_OP = 'INSERT') THEN
		NEW.dataEntrada := now();
		IF NEW.situacao IS NULL THEN
			NEW.situacao = 'ORCAMENTO';
		END IF;
		IF (NEW.pago = 'S' and NEW.valor IS NULL) THEN
			RAISE EXCEPTION 'Para ser pago, o valor deve está definido';
		END IF;	
	END IF;
	IF (TG_OP = 'UPDATE') THEN
		IF (NEW.pago = 'S' and (NEW.valor IS NULL or OLD.valor IS NULL)) THEN
			RAISE EXCEPTION 'Para ser pago, o valor deve está definido';
		END IF;
	END IF;	
	IF NEW.valor <= 0 THEN
		RAISE EXCEPTION 'O valor do serviço deve ser maior que 0';
	END IF;
	IF NEW.dataSaida IS NOT NULL AND NEW.idGarantia IS NULL THEN
		NEW.dataSaida := now();
		INSERT INTO Garantia(dataInicio) VALUES (NEW.dataSaida) RETURNING idGarantia INTO id_garantia;
		NEW.idGarantia := id_garantia;
	END IF;
RETURN NEW;
END;
$os_gatilho$ LANGUAGE plpgsql;

CREATE TRIGGER os_insert BEFORE INSERT OR UPDATE
ON OrdemServico
FOR EACH ROW EXECUTE
PROCEDURE os_gatilho();

INSERT INTO OrdemServico (idEquipamento, dataEntrada, situacao, valor, pago, dataSaida)
VALUES (3, '2017-11-10', 'FINALIZADO', 252, 'S', now());
INSERT INTO OrdemServico (idEquipamento, dataEntrada, situacao, valor, pago, dataSaida)
VALUES (1, '2017-11-10', 'FINALIZADO', 0, 'S', now());
INSERT INTO OrdemServico (idEquipamento, dataEntrada, situacao, pago, dataSaida)
VALUES (4, '2017-11-10', 'FINALIZADO', 'S', now());
INSERT INTO OrdemServico (idEquipamento, dataEntrada, valor, pago, dataSaida)
VALUES (4, '2017-11-10', 10, 'S', now());

--UPDATE OrdemServico SET valor = null, pago = 'N' where idOrdemServico = 6;
--UPDATE OrdemServico SET pago = 'S' where idOrdemServico = 6;

select * from OrdemServico;
select * from Garantia;
select * from Equipamento;

/* Função para regras de negocio da Garantia na inserção */
CREATE FUNCTION garantia_gatilho() RETURNS TRIGGER AS $garantia_gatilho$
BEGIN
	IF NEW.tempoGarantia IS NULL THEN
		NEW.tempoGarantia := 90;
	END IF;
	IF NEW.dataInicio IS NULL THEN
		RAISE EXCEPTION 'Data de garantia da Garantia no pode ser nula';
	END IF;
RETURN NEW;
END;
$garantia_gatilho$ LANGUAGE plpgsql;

CREATE TRIGGER garantia_insert BEFORE INSERT OR UPDATE
ON Garantia
FOR EACH ROW EXECUTE
PROCEDURE garantia_gatilho();

INSERT INTO Garantia(dataInicio) VALUES ('2018-10-11');
--UPDATE Garantia SET tempoGarantia = 120 Where idGarantia = 4;

/* Função para regras de negocio do Servico */
CREATE FUNCTION servico_gatilho() RETURNS TRIGGER AS $servico_gatilho$
BEGIN
	IF NEW.analise IS NULL THEN
		RAISE EXCEPTION 'A análise feita sobre o defeito não pode ser nula';
	END IF;
RETURN NEW;
END;
$servico_gatilho$ LANGUAGE plpgsql;

CREATE TRIGGER servico_insert BEFORE INSERT OR UPDATE
ON Servico
FOR EACH ROW EXECUTE
PROCEDURE servico_gatilho();

INSERT INTO Servico (idFuncionario, servicoFeito) 
VALUES (1, 'troca do display');

/* $$$$$$$$$$$$$$$$$$ Views $$$$$$$$$$$$$$$$$$ */
/* View para visualizar todos os dados da empresa */
CREATE VIEW empresas_dados AS
SELECT p.nome, p.email, emp.razaoSocial, emp.cnpj, 
e.cep, e.logradouro, e.numero as "Numero da casa", e.complemento, e.bairro, e.cidade, e.estado, 
t.ddd, t.numero, t.tipo
FROM Empresa emp
JOIN Pessoa p on emp.idPessoa = p.idPessoa
JOIN Endereco e on p.idEndereco = e.idEndereco
JOIN Telefone t on emp.idPessoa = t.idPessoa
ORDER BY p.nome;

select * from empresas_dados;

/* View para visualizar todos os dados do cliente */
CREATE VIEW cliente_dados AS
SELECT p.nome, p.email, c.cpf,
e.cep, e.logradouro, e.numero, e.complemento, e.bairro, e.cidade, e.estado, 
t.ddd, t.numero as "numero de telefone", t.tipo,
emp.cnpj
FROM Cliente c
JOIN Pessoa p on c.idPessoa = p.idPessoa
JOIN Endereco e on p.idEndereco = e.idEndereco
JOIN Telefone t on c.idPessoa = t.idPessoa
JOIN Empresa emp on c.idEmpresa = emp.idEmpresa
ORDER BY p.nome;

select * from cliente_dados;

/* View para visualizar todos os dados do funcionario */
CREATE VIEW funcionario_dados AS
SELECT p.nome, p.email, f.cpf, f.cargo, f.salario, f.NIS,
e.cep, e.logradouro, e.numero, e.complemento, e.bairro, e.cidade, e.estado, 
t.ddd, t.numero as "numero de telefone", t.tipo,
emp.cnpj
FROM Funcionario f
JOIN Pessoa p on f.idPessoa = p.idPessoa
JOIN Endereco e on p.idEndereco = e.idEndereco
JOIN Telefone t on f.idPessoa = t.idPessoa
JOIN Empresa emp on f.idEmpresa = emp.idEmpresa
ORDER BY p.nome;

select * from funcionario_dados;

/* View para visualizar todos os clientes com seus equipamentos */
CREATE VIEW equipamento_cliente AS
SELECT p.nome, e.modelo, e.estadoConservacao, e.defeito, e.acessorios, e.tipo, e.observacoes
FROM Equipamento e
JOIN Cliente c on e.idCliente = c.idCliente
JOIN Pessoa p on c.idPessoa = p.idPessoa
ORDER BY p.nome;

select * from equipamento_cliente;

/* View para visualizar o equipamento e sua garantia */
CREATE VIEW garantia_equipamento AS
SELECT e.modelo, e.tipo, g.dataInicio, g.tempoGarantia
FROM Garantia g
JOIN OrdemServico os on g.idGarantia = os.idGarantia
JOIN Equipamento e on os.idEquipamento = e.idEquipamento
ORDER BY e.modelo;

select * from garantia_equipamento;

select * from OrdemServico;

/* View para visualizar o funcionario e seus serviços */
CREATE VIEW servico_funcionario AS
SELECT p.nome, f.NIS, s.servicoFeito, s.analise
FROM Servico s
JOIN Funcionario f on s.idFuncionario = f.idFuncionario
JOIN Pessoa p on f.idPessoa = p.idPessoa
ORDER BY p.nome;

select * from servico_funcionario;

/* View para visualizar todos os dados da ordem de servico */
CREATE VIEW os_dados AS
SELECT os.dataEntrada, os.situacao, os.valor, os.pago, os.dataSaida,
s.servicoFeito, s.analise, g.dataInicio, g.tempoGarantia
FROM OrdemServico os
JOIN Servico s on os.idServico = s.idServico
JOIN Garantia g on os.idGarantia = g.idGarantia
ORDER BY os.dataEntrada;

select * from os_dados;