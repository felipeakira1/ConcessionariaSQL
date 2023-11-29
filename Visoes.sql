-- Visão Cliente Pessoa Fisica
CREATE VIEW VisaoClientePessoaFisica
AS
SELECT
	p.codigo_pessoa AS CodigoCliente,
	pf.cpf AS CPF,
	pf.nome AS Nome,
	pf.data_nascimento AS DataNascimento,
	p.endereco AS Endereço,
	p.telefone AS Telefone,
	p.email AS Email,
	CASE
        WHEN c.tipo_pessoa = 1 THEN 'Pessoa Física'
        WHEN c.tipo_pessoa = 2 THEN 'Pessoa Jurídica'
        ELSE 'Tipo não especificado'
    END AS TipoCliente
FROM Pessoa p
JOIN PessoaFisica pf ON p.codigo_pessoa = pf.codigo_pessoaFisica
JOIN Cliente c ON pf.codigo_pessoaFisica = c.codigo_cliente
WHERE c.tipo_pessoa = 1;

-- Visão Cliente Pessoa Juridica
CREATE VIEW VisaoClientePessoaJuridica
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
	CASE
        WHEN c.tipo_pessoa = 1 THEN 'Pessoa Física'
        WHEN c.tipo_pessoa = 2 THEN 'Pessoa Jurídica'
        ELSE 'Tipo não especificado'
    END AS TipoCliente
FROM Pessoa p
JOIN PessoaJuridica pj ON p.codigo_pessoa = pj.codigo_pessoaJuridica
JOIN Cliente c ON pj.codigo_pessoaJuridica = c.codigo_cliente
WHERE c.tipo_Pessoa = 2;

-- Finalizado
CREATE VIEW VisaoGeralClientes AS
SELECT
    P.codigo_pessoa AS CodigoPessoa,
    CASE
        WHEN P.tipo_pessoa = 1 THEN 'Pessoa Física'
        WHEN P.tipo_pessoa = 2 THEN 'Pessoa Jurídica'
        ELSE 'Tipo não especificado'
    END AS TipoCliente,
    PF.nome AS NomeCliente,
    PF.data_nascimento AS DataNascimento,
    PF.cpf AS CPF,
    PJ.razao_social AS RazaoSocial,
    PJ.cnpj AS CNPJ,
    PJ.nome_fantasia AS NomeFantasia,
    P.endereco AS Endereco,
    P.telefone AS Telefone,
    P.email AS Email
FROM Pessoa AS P
LEFT JOIN PessoaFisica AS PF ON P.codigo_pessoa = PF.codigo_pessoaFisica
LEFT JOIN PessoaJuridica AS PJ ON P.codigo_pessoa = PJ.codigo_pessoaJuridica
INNER JOIN Cliente AS C ON P.codigo_pessoa = C.codigo_cliente;

-- Finalizado
CREATE VIEW VisaoFuncionarios
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

-- Visão Fornecedor
CREATE VIEW VisaoFornecedores
AS
SELECT
	p.codigo_pessoa AS CodigoFornecedor,
	pj.cnpj AS CNPJ,
	pj.razao_social AS RazaoSocial,
	pj.nome_fantasia AS NomeFantasia,
	pj.data_fundacao AS DataFundacao,
	pj.inscricao_estadual AS InscricaoEstadual,
	p.endereco AS Endereço,
	p.telefone AS Telefone,
	p.email AS Email
FROM Pessoa p
JOIN PessoaJuridica pj ON p.codigo_pessoa = pj.codigo_pessoaJuridica
JOIN Fornecedor f ON pj.codigo_pessoaJuridica = f.codigo_fornecedor;

-- FINALIZAOD
CREATE VIEW VisaoNotasFiscais AS
SELECT
    NF.codigo_notaFiscal AS CodigoNotaFiscal,
    CASE
        WHEN C.tipo_pessoa = 1 THEN PF.nome
        WHEN C.tipo_pessoa = 2 THEN PJ.razao_social
        ELSE 'Cliente não especificado'
    END AS NomeCliente,
    Mo.nome AS ModeloCarro,
    Ca.cor AS CorCarro,
    Ca.preco AS Preco,
    PF_funcionario.nome AS NomeFuncionario,
    NF.data AS Data,
    NF.hora AS Hora,
    NF.valor_total AS ValorTotal,
    NF.metodo_pagamento AS MetodoPagamento,
    NF.desconto AS Desconto,
    NF.parcelas AS Parcelas,
    NF.juros AS Juros,
    C.tipo_pessoa AS TipoCliente
FROM Nota_Fiscal AS NF
INNER JOIN Funcionario AS F ON NF.codigo_funcionario = F.codigo_funcionario
INNER JOIN PessoaFisica AS PF_funcionario ON F.codigo_funcionario = PF_funcionario.codigo_pessoaFisica
INNER JOIN Cliente AS C ON NF.codigo_cliente = C.codigo_cliente
LEFT JOIN PessoaFisica AS PF ON C.codigo_pessoaFisica = PF.codigo_pessoaFisica
LEFT JOIN PessoaJuridica AS PJ ON C.codigo_pessoaJuridica = PJ.codigo_pessoaJuridica
INNER JOIN Carro AS Ca ON NF.codigo_carro = Ca.codigo_carro
INNER JOIN Modelo AS Mo ON Ca.codigo_modelo = Mo.codigo_modelo;

-- FINALIZAOD
CREATE VIEW VisaoCarros
AS
SELECT
	Ca.codigo_carro AS CodigoCarro,
	Mo.nome AS Modelo,
	Ca.cor AS Cor,
	Mo.ano_lancamento AS AnoLancamento,
	Mo.motorizacao AS Motorizacao,
	Ca.preco AS Preco,
	Ca.quantidade_estoque AS QuantidadeEstoque,
	Mo.capacidade_passageiros AS Capacidade,
	Mo.tipo_modelo AS TipoModelo,
	Mo.descricao AS Descricao,
    Re.data_entrada AS data_ultima_revisao_entrada,
    Re.data_saida AS data_ultima_revisao_saida,
    Re.observacoes AS observacoes_ultima_revisao
FROM Carro Ca
INNER JOIN Modelo Mo ON Ca.codigo_modelo = Mo.codigo_modelo
LEFT JOIN Revisao Re ON Ca.codigo_revisao = Re.codigo_revisao

CREATE VIEW VisaoModelosCarros AS
SELECT
    Mo.codigo_modelo AS CodigoModelo,
    Mo.nome AS NomeModelo,
    Mo.tipo_modelo AS TipoModelo,
    Mo.ano_lancamento AS AnoLancamento,
    Mo.descricao AS Descricao,
	Mo.motorizacao AS Motorizacao,
	Mo.capacidade_passageiros AS CapacidadePassageiros,
	Mo.caracteristicas_especiais AS CaracteristicasEspeciais
FROM Modelo AS Mo;

CREATE VIEW VisaoPedidosItens AS
SELECT
    Pe.codigo_pedido AS CodigoPedido,
    Pe.data AS Data,
    Pe.hora as Hora,
    Pe.valor_total AS ValorTotal,
    Pe.status AS Status,
    Pe.metodo_pagamento AS MetodoPagamento,
    Pe.desconto AS Desconto,
    Pe.parcelas AS Parcelas,
    Pe.juros AS Juros,
    C.tipo_pessoa AS TipoCliente,
    CASE
        WHEN C.tipo_pessoa = 'Pessoa Física' THEN PF.nome
        WHEN C.tipo_pessoa = 'Pessoa Jurídica' THEN PJ.razao_social
        ELSE 'Cliente não especificado'
    END AS NomeCliente,
    IP.codigo_acessorio,
    Ac.nome AS NomeAcessorio,
    IP.quantidade_pedido
FROM Pedido AS Pe
INNER JOIN Cliente AS C ON Pe.codigo_cliente = C.codigo_cliente
LEFT JOIN PessoaFisica AS PF ON C.codigo_pessoaFisica = PF.codigo_pessoaFisica
LEFT JOIN PessoaJuridica AS PJ ON C.codigo_pessoaJuridica = PJ.codigo_pessoaJuridica
INNER JOIN ItemPedido AS IP ON Pe.codigo_pedido = IP.codigo_pedido
INNER JOIN Acessorio AS Ac ON IP.codigo_acessorio = Ac.codigo_acessorio;

CREATE VIEW VisaoAcessorio
AS
SELECT
	Ac.codigo_acessorio AS CodigoAcessorio,
	Ac.nome AS Nome,
	Ac.descricao AS Descricao,
	Ac.preco AS Preco,
	Ac.categoria AS Categoria,
	Ac.quantidade_estoque AS QuantidadeEstoque,
	Ac.codigo_fornecedor AS CodigoFornecedor
FROM Acessorio AS Ac;

CREATE VIEW VisaoRevisoes AS
SELECT
    Re.codigo_revisao AS CodigoRevisao,
    Re.data_entrada AS DataEntrada,
    Re.data_saida AS DataSaida,
    Re.observacoes AS Observacoes,
    Re.resultados AS Resultados
FROM Revisao AS Re;