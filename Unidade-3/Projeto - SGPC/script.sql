/* Tabela Endereco */
CREATE TABLE Endereco (
  idEndereco serial NOT NULL UNIQUE,
  logradouro VARCHAR NULL,
  cep CHAR(8) NULL,
  numero INTEGER NULL,
  complemento VARCHAR NULL,
  bairro VARCHAR NULL,
  cidade VARCHAR NULL,
  estado VARCHAR(2) NULL,
  PRIMARY KEY(idEndereco)
);

/* Dados para a Tabela Endereco */
INSERT INTO Endereco(logradouro, cep, numero, complemento, bairro, cidade, estado) 
VALUES ('rua x', '00000000', 15, 'casa', 'Natal', 'Ponta Negra', 'RN');
INSERT INTO Endereco(logradouro, cep, numero, complemento, bairro, cidade, estado) 
VALUES ('rua y', '11111111', 20, 'casa', 'Natal', 'Lagoa Nova', 'RN');
INSERT INTO Endereco(logradouro, cep, numero, complemento, bairro, cidade, estado) 
VALUES ('rua z', '22222222', 30, 'Predio', 'Natal', 'Alecrim', 'RN');


/* Tabela Pessoa */
CREATE TABLE Pessoa (
  idPessoa serial NOT NULL UNIQUE,
  idEndereco INTEGER NOT NULL REFERENCES Endereco ON DELETE RESTRICT,
  nome VARCHAR NULL,
  PRIMARY KEY(idPessoa)
);

/* Forçar a utilização dos indices */
SET enable_seqscan To OFF;

/* Criando indice hash na tabela Pessoa para o idEndereço */
CREATE INDEX pessoa_endereco_id ON Pessoa USING HASH (idEndereco);

/* Dados para a Tabela Pessoa */
INSERT INTO Pessoa(idEndereco, nome) VALUES (1, 'Alberto'); 
INSERT INTO Pessoa(idEndereco, nome) VALUES (2, 'Gustavo');
INSERT INTO Pessoa(idEndereco, nome) VALUES (3, 'SGN LTDA');


/* Tabela telefone */
CREATE TABLE Telefone (
  idTelefone serial NOT NULL UNIQUE,
  idPessoa INTEGER NOT NULL REFERENCES Pessoa ON DELETE RESTRICT,
  ddd INTEGER NULL,
  numero INTEGER NULL,
  operadora VARCHAR NULL,
  tipo VARCHAR NULL,
  PRIMARY KEY(idTelefone)
);

/* Criando indice hash na tabela Telefine para o idPessoa */
CREATE INDEX telefone_pessoa_id ON Pessoa USING HASH (idPessoa);

/* Dados para a Tabela Telefone */
INSERT INTO Telefone(idPessoa, ddd, numero, operadora, tipo) VALUES (1, '84', '997010101', 'VIVO', 'CELULAR');
INSERT INTO Telefone(idPessoa, ddd, numero, operadora, tipo) VALUES (2, '15', '998819732', 'OI', 'CELULAR');
INSERT INTO Telefone(idPessoa, ddd, numero, operadora, tipo) VALUES (3, '12', '32414141', 'VIVO', 'COMERCIAL');


/* Tabela Cliente */
CREATE TABLE Cliente (
  idCliente serial NOT NULL UNIQUE,
  idPessoa INTEGER NOT NULL REFERENCES Pessoa ON DELETE RESTRICT,
  cpf VARCHAR NULL,
  PRIMARY KEY(idCliente)
);

/* Criando indice hash na tabela Cliente para o idPessoa */
CREATE INDEX cliente_pessoa_id ON Cliente USING HASH (idPessoa);

/* Dados para a Tabela Cliente */
INSERT INTO Cliente(idPessoa, cpf) VALUES (1, '44455566698');
INSERT INTO Cliente(idPessoa, cpf) VALUES (2, '55577711123');


/* Tabela Automovel */
CREATE TABLE Automovel (
  idAutomovel serial NOT NULL UNIQUE,
  idCliente INTEGER NOT NULL REFERENCES Cliente ON DELETE RESTRICT,
  tipo VARCHAR NULL,
  modelo VARCHAR NULL,
  marca VARCHAR NULL,
  ano INTEGER NULL,
  PRIMARY KEY(idAutomovel)
);

/* Criando indice hash na tabela Automovel para o idCliente */
CREATE INDEX automovel_cliente_id ON Automovel USING HASH (idCliente);

/* Dados para a Tabela Automovel */
INSERT INTO Automovel(idCliente, tipo, modelo, marca, ano) VALUES (1, 'Carro', 'UNO', 'FIAT', '2018');
INSERT INTO Automovel(idCliente, tipo, modelo, marca, ano) VALUES (2, 'MOTO', 'MT-09', 'Yamaha', '2018');


/* Tabela Fornecedor */
CREATE TABLE Fornecedor (
  idFornecedor serial NOT NULL UNIQUE,
  idPessoa INTEGER NOT NULL REFERENCES Pessoa ON DELETE RESTRICT,
  cnpj VARCHAR NULL,
  PRIMARY KEY(idFornecedor)
);

/* Criando indice hash na tabela Fornecedor para o idPessoa */
CREATE INDEX fornecedor_pessoa_id ON Fornecedor USING HASH (idPessoa);

/* Dados para a Tabela Fornecedor */
INSERT INTO Fornecedor(idPessoa, cnpj) VALUES (3, '548762565555560');


/* Tabela Produto */
CREATE TABLE Produto (
  idProduto serial NOT NULL UNIQUE,
  idFornecedor INTEGER NOT NULL REFERENCES Fornecedor ON DELETE RESTRICT,
  valor FLOAT NULL,
  qtde INTEGER NULL,
  PRIMARY KEY(idProduto)
);

/* Criando indice hash na tabela Produto para o idFornecedor */
CREATE INDEX produto_fornecedor_id ON Fornecedor USING HASH (idFornecedor);

/* Dados para a Tabela Produto */
INSERT INTO Produto(idFornecedor, valor, qtde) VALUES (1, '4000.00', '100');


/* Tabela NotaFiscalEntrada */
CREATE TABLE NotaFiscalEntrada (
  idNotaFiscalEntrada serial NOT NULL UNIQUE,
  dataEntrada DATE NULL,
  imposto FLOAT NULL,
  valorTotal FLOAT NULL,
  PRIMARY KEY(idNotaFiscalEntrada)
);

/* Dados para a Tabela NotaFiscalEntrada */
INSERT INTO NotaFiscalEntrada(dataEntrada, imposto, valorTotal) VALUES (now(), '300.00', '3000.00');


/* Tabela ItemEntrada */
CREATE TABLE ItemEntrada (
  idItemEntrada serial NOT NULL UNIQUE,
  idNotaFiscalEntrada INTEGER NOT NULL REFERENCES NotaFiscalEntrada ON DELETE RESTRICT,
  idProduto INTEGER NOT NULL REFERENCES Produto ON DELETE RESTRICT,
  qtde INTEGER NULL,
  valor FLOAT NULL,
  PRIMARY KEY(idItemEntrada)
);

/* Criando indice hash na tabela ItemEntrada para o idNotaFiscalEntrada */
CREATE INDEX itemEntrada_notaFiscalEntrada_id ON ItemEntrada USING BTREE (idNotaFiscalEntrada);

/* Criando indice hash na tabela ItemEntrada para o idProduto */
CREATE INDEX itemEntrada_produto_id ON ItemEntrada USING BTREE (idProduto);

/* Dados para a Tabela Produto */
INSERT INTO ItemEntrada(idNotaFiscalEntrada, idProduto, qtde, valor) VALUES (1, 1, '100', '3000.00');


/* Tabela ItemSaida */
CREATE TABLE ItemSaida (
  idItemSaida serial NOT NULL UNIQUE,
  idProduto INTEGER NOT NULL REFERENCES Produto ON DELETE RESTRICT,
  qtde INTEGER NULL,
  valor FLOAT NULL,
  PRIMARY KEY(idItemSaida)
);

/* Criando indice hash na tabela ItemSaida para o idProduto */
CREATE INDEX itemSaida_produto_id ON ItemEntrada USING HASH (idProduto);

/* Dados para a Tabela ItemSaida */
INSERT INTO ItemSaida(idProduto, qtde, valor) VALUES (1, '10', '300.00');
INSERT INTO ItemSaida(idProduto, qtde, valor) VALUES (1, '5', '150.00');


/* Tabela NotaFiscalSaida */
CREATE TABLE NotaFiscalSaida (
  idNotaFiscalSaida serial NOT NULL UNIQUE,
  idItemSaida INTEGER NOT NULL REFERENCES ItemSaida ON DELETE RESTRICT,
  cnpj VARCHAR NULL,
  dataSaida DATE NULL,
  PRIMARY KEY(idNotaFiscalSaida)
);

/* Criando indice hash na tabela NotaFiscalSaida para o idItemSaida */
CREATE INDEX notaFiscalSaida_itemSaida_id ON NotaFiscalSaida USING HASH (idItemSaida);

/* Dados para a Tabela NotaFiscalSaida */
INSERT INTO NotaFiscalSaida(idItemSaida, cnpj, dataSaida) VALUES (1, '111111111111111', now());
INSERT INTO NotaFiscalSaida(idItemSaida, cnpj, dataSaida) VALUES (2, '111111111111111', now());

                                                                                                                                           
/* Tabela Venda */
CREATE TABLE Venda (
  idVenda serial NOT NULL UNIQUE,
  idCliente INTEGER NOT NULL REFERENCES Cliente ON DELETE RESTRICT,
  idNotaFiscalSaida INTEGER NOT NULL REFERENCES NotaFiscalSaida ON DELETE RESTRICT,
  valor FLOAT NULL,
  PRIMARY KEY(idVenda)
);

/* Criando indice hash na tabela Venda para o idCliente */
CREATE INDEX venda_cliente_id ON Venda USING BTREE (idCliente);

/* Criando indice hash na tabela Venda para o idNotaFiscalSaida */
CREATE INDEX venda_notaFiscalSaida_id ON Venda USING BTREE (idNotaFiscalSaida);

/* Dados para a Tabela Venda */
INSERT INTO Venda(idCliente, idNotaFiscalSaida, valor) VALUES (1, 1, '350.00');
INSERT INTO Venda(idCliente, idNotaFiscalSaida, valor) VALUES (2, 2, '180.00');


/* Regras de Negocio */

/*  */


/* Views */

/* Visualizar dados dos Clientes  */
CREATE VIEW info_clientes AS 
SELECT p.nome, c.cpf, e.logradouro, e.cep, e.numero,
e.complemento, e.bairro, e.cidade, e.estado, t.ddd, t.numero as "Numero tel.", t.tipo
FROM Cliente c
JOIN Pessoa p on c.idPessoa = p.idPessoa
JOIN Endereco e on p.idEndereco = e.idEndereco
JOIN Telefone t on c.idPessoa = t.idPessoa
ORDER BY p.nome;

/* teste da view info_cliente */
select * from info_clientes;


/* Visualizar dados do Fornecedores */
CREATE VIEW info_fornecedores AS
SELECT p.nome, f.cnpj, e.logradouro, e.cep, e.numero,
e.complemento, e.bairro, e.cidade, e.estado, t.ddd, t.numero as "Numero tel.", t.tipo
FROM Fornecedor f
JOIN Pessoa p on f.idPessoa = p.idPessoa
JOIN Endereco e on p.idEndereco = e.idEndereco
JOIN Telefone t on f.idPessoa = t.idPessoa
ORDER BY p.nome;

select * from info_fornecedores;

