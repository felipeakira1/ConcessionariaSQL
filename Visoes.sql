-- Visão Cliente Pessoa Fisica
CREATE VIEW vw_ClientePessoaFisica
AS
SELECT
	p.codigo_pessoa AS CodigoCliente,
	pf.cpf AS CPF,
	pf.nome AS Nome,
	pf.data_nascimento AS DataNascimento,
	p.endereco AS Endereço,
	p.telefone AS Telefone,
	p.email AS Email,
	c.tipo_pessoa AS TipoPessoa
FROM Pessoa p
JOIN PessoaFisica pf ON p.codigo_pessoa = pf.codigo_pessoaFisica
JOIN Cliente c ON pf.codigo_pessoaFisica = c.codigo_cliente
WHERE c.tipo_pessoa = 1;

-- Visão Cliente Pessoa Juridica
CREATE VIEW vw_ClientePessoaJuridica
AS
SELECT
	p.codigo_pessoa AS CodigoCliente,
	pj.cnpj AS CNPJ,
	pj.razao_social AS RazaoSocial,
	pj.nome_fantasia AS NomeFantasia,
	pj.data_fundacao AS DataFundaçao,
	pj.inscricao_estadual AS InscricaoEstadual,
	p.endereco AS Endereço,
	p.telefone AS Telefone,
	p.email AS Email,
	c.tipo_pessoa AS TipoPessoa
FROM Pessoa p
JOIN PessoaJuridica pj ON p.codigo_pessoa = pj.codigo_pessoaJuridica
JOIN Cliente c ON pj.codigo_pessoaJuridica = c.codigo_cliente
WHERE c.tipo_Pessoa = 2;

-- Visão Funcionário
CREATE VIEW vw_Funcionario
AS
SELECT
	p.codigo_pessoa AS CodigoFuncionario,
	pf.cpf AS CPF,
	pf.nome AS Nome,
	f.salario AS Salário,
	pf.data_nascimento AS DataNascimento,
	p.endereco AS Endereço,
	p.telefone AS Telefone,
	p.email AS Email
FROM Pessoa p
JOIN PessoaFisica pf ON p.codigo_pessoa = pf.codigo_pessoaFisica
JOIN Funcionario f ON pf.codigo_pessoaFisica = f.codigo_funcionario;
