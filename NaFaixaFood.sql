USE NaFaixaFood;

-- Criação das tabelas
CREATE TABLE Cliente (
    cliente_id INT PRIMARY KEY IDENTITY(1,1),
    clienteNome VARCHAR(100) NOT NULL,
    enderecoCliente VARCHAR(150) NOT NULL
);

CREATE TABLE Entregador (
    entregador_id INT PRIMARY KEY IDENTITY(1,1),
    nome VARCHAR(150) NOT NULL,
    placa VARCHAR(7) NOT NULL,
    veiculo VARCHAR(100),
);

CREATE TABLE Pedido (
    pedido_id INT PRIMARY KEY IDENTITY(1,1),
    statusPedido VARCHAR(20) NOT NULL,
    dataPedido DATE NOT NULL,
    cliente_id INT FOREIGN KEY(cliente_id) REFERENCES Cliente(cliente_id) NOT NULL,
    entregador_id INT FOREIGN KEY(entregador_id) REFERENCES Entregador(entregador_id) NOT NULL
);


CREATE TABLE Item (
    item_id INT IDENTITY(1,1) PRIMARY KEY,
	nomeItem varchar(100) NOT NULL,
    quantidade INT,
    precoUnidade DECIMAL(10,2) NOT NULL,
	pedido_id INT FOREIGN KEY(pedido_id) REFERENCES Pedido(pedido_id) NOT NULL
);

CREATE TABLE Avaliacao (
    avaliacao_id INT IDENTITY(1,1) PRIMARY KEY,
    pedido_id INT NOT NULL FOREIGN KEY REFERENCES Pedido(pedido_id),
    nota DECIMAL(2,1) NOT NULL,
    comentario VARCHAR(255)
);

-- Populando as tabelas
INSERT INTO Cliente (clienteNome, enderecoCliente) VALUES
('Paulo', 'R.Beethoven'),
('Pedro', 'R.Brasil'),
('Jose', 'R.31 de fevereiro'),
('Maria', 'R.Biriri'),
('Juliana', 'R.São José'),
('Roberto', 'R.Canadá'),
('Claudio', 'R.do Bom Jesus');

INSERT INTO Entregador (nome, veiculo, placa) VALUES
('Mateus', 'CG 160', 'JPP3455'),
('Vitor', 'Honda Biz', 'EUA4466'),
('Kawan', 'Pop 100', 'USA5533'),
('Isaque', 'Yamaha Factor', 'JAP3322'),
('Luiz', 'XJ 6', 'YUE2211'),
('André', 'Tiger 1200', 'TET1010'),
('Jorge', 'PCX', 'RUA1230');


INSERT INTO Pedido (statusPedido,cliente_id,dataPedido,entregador_id) VALUES
('Em andamento',1,'2025-11-15',1),
('Concluído',2,'2025-04-13',2),
('Em andamento',3,'2022-02-11',3),
('Em andamento',4,'2023-03-10',4),
('Concluído',5,'2025-02-09',5),
('Concluído',6,'2025-08-03',6),
('Em andamento',7,'2025-11-13',7);

INSERT INTO Pedido (statusPedido, cliente_id, dataPedido, entregador_id) VALUES
('Concluído', 2, '2025-11-10',1),
('Concluído', 2, '2025-10-09',1);

INSERT INTO Item (nomeItem,quantidade, precoUnidade, pedido_id) VALUES
('Hamburguer',1, 15.00,1),
('Coca-Cola',1, 5.00,1),
('Cachorro Quente',1, 10.00,2),
('Espeto',1, 12.00,2),
('Sanduiche',2, 20.00,3),
('Coxinha',1, 7.00,4);

INSERT INTO Item (nomeItem,quantidade, precoUnidade, pedido_id) VALUES
('Hamburguer',2, 15.00,5),
('Coca-Cola',1, 5.00,5),
('Cachorro Quente',1, 10.00,6),
('Sanduiche',1, 20.00,6),
('Coxinha',1, 7.00,7);

INSERT INTO Item (nomeItem,quantidade, precoUnidade, pedido_id) VALUES
('Coxinha', 2, 7.00, 8),
('Cachorro Quente', 2, 10.00, 9);

--Listando a quantidade de itens pedidos por cada cliente
SELECT c.clienteNome, SUM(i.Quantidade) AS totalItensPedidos FROM Item i
INNER JOIN
Pedido p ON p.pedido_id = i.pedido_id
INNER JOIN
Cliente c ON c.cliente_id = p.cliente_id
GROUP BY c.clienteNome;

--Listando todos os pedidos que têm o status "Em Andamento".
SELECT c.clienteNome, p.pedido_id, p.statusPedido FROM Pedido p
INNER JOIN 
Cliente c ON c.cliente_id = p.cliente_id
WHERE statusPedido = 'Em andamento';

--Quantidade de Entregas feitas por cada Entregador
SELECT e.nome, COUNT(p.pedido_id) as totalEntregas FROM Entregador e
INNER JOIN
Pedido p ON p.entregador_id = e.entregador_id
GROUP BY e.nome
ORDER BY totalEntregas DESC;

--Identifique os 5 itens mais pedidos
SELECT TOP 5 nomeItem AS maisPedido,quantidade FROM Item
ORDER BY quantidade DESC;

--Entregadores que já concluiram todas as entregas 
SELECT e.nome as nomeEntregadores, e.veiculo, p.statusPedido FROM Entregador e
INNER JOIN Pedido p ON p.pedido_id = e.entregador_id
WHERE p.statusPedido = 'Concluído';

--Alterando um pedido com o status 'Em andamento' para 'Concluído'
UPDATE Pedido
SET statusPedido = 'Concluído' 
WHERE pedido_id = 1;

--Mostrando a alteração feita
select statusPedido,pedido_id from Pedido;

CREATE VIEW vw_PedidosDetalhes AS
SELECT 
    c.clienteNome AS nome_cliente,
    e.nome AS nome_entregador,
    p.dataPedido AS data_pedido,
    p.statusPedido AS status_pedido
FROM 
    Pedido p
INNER JOIN 
    Cliente c ON p.cliente_id = c.cliente_id
INNER JOIN 
    Entregador e ON p.entregador_id = e.entregador_id
WHERE 
    p.statusPedido <> 'Concluído';

--Testando a view
SELECT * FROM vw_PedidosDetalhes;
    
CREATE PROCEDURE sp_FinalizarEntrega
    @ID_Pedido INT,
    @Avaliacao_Cliente DECIMAL(2,1),
    @Comentario VARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    -----------------------------------------------------------------------
    -- 1) Verificar se o pedido existe
    -----------------------------------------------------------------------
    IF NOT EXISTS (SELECT 1 FROM Pedido WHERE pedido_id = @ID_Pedido)
    BEGIN
        PRINT 'Erro: O pedido informado não existe.';
        RETURN;
    END

    -----------------------------------------------------------------------
    -- 2) Verificar se o pedido já está concluído
    -----------------------------------------------------------------------
    IF EXISTS (
        SELECT 1 
        FROM Pedido 
        WHERE pedido_id = @ID_Pedido AND statusPedido = 'Concluído'
    )
    BEGIN
        PRINT 'Aviso: Este pedido já está finalizado.';
        RETURN;
    END
-----------------------------------------------------------------------
    -- 3) Atualizar status para "Concluído"
    -----------------------------------------------------------------------
    UPDATE Pedido
    SET statusPedido = 'Concluído'
    WHERE pedido_id = @ID_Pedido;

    -----------------------------------------------------------------------
    -- 4) Calcular o valor total do pedido
    -----------------------------------------------------------------------
    DECLARE @ValorTotal DECIMAL(10,2);

    SELECT @ValorTotal = SUM(i.quantidade * i.precoUnidade)
    FROM Item i
    WHERE i.pedido_id = @ID_Pedido;

    -----------------------------------------------------------------------
    -- 5) Registrar a avaliação na tabela Avaliacao
    -----------------------------------------------------------------------
    INSERT INTO Avaliacao (pedido_id, nota, comentario)
    VALUES (@ID_Pedido, @Avaliacao_Cliente, @Comentario);

    -----------------------------------------------------------------------
    -- Mensagens de retorno
    -----------------------------------------------------------------------
    PRINT 'Pedido finalizado com sucesso.';
    PRINT 'Valor total calculado: R$ ' + CAST(@ValorTotal AS VARCHAR(20));
    PRINT 'Avaliação registrada com sucesso.';
END

EXEC sp_FinalizarEntrega 
    @ID_Pedido = 3,
    @Avaliacao_Cliente = 4.5,
    @Comentario = 'Entrega rápida, tudo certo.';

EXEC sp_FinalizarEntrega 
    @ID_Pedido = 4,
    @Avaliacao_Cliente = 5.0,
    @Comentario = 'Lanche muito saboroso!';

--Mostrando as alterações feitas com a procedure
SELECT p.pedido_id,a.comentario,a.nota FROM Pedido p
INNER JOIN
Avaliacao a ON a.pedido_id = p.pedido_id;

