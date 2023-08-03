CREATE DATABASE mecanica
USE mecanica

CREATE TABLE pecas(
    idPeca INT PRIMARY KEY NOT NULL,
    tipoPeca VARCHAR(255) NOT NULL,
    fabriPeca VARCHAR(255) NOT NULL,
    anoPeca DATE,
    infoPeca VARCHAR(255) NOT NULL
);

CREATE TABLE estoque(
    idEstoque INT PRIMARY KEY NOT NULL,
    idPeça INT NOT NULL,
    qtdPeca INT NOT NULL,
    FOREIGN KEY (idPeca) REFERENCES Pecas(idPeca)
);

CREATE TABLE agenda_servicos(
    idAgenda INT PRIMARY KEY NOT NULL,
    idEstoque INT PRIMARY KEY NOT NULL,
    clienteNome VARCHAR(255) NOT NULL,
    clienteCarro VARCHAR(255) NOT NULL,
    clienteServico VARCHAR(255) NOT NULL,
    clientePagto ENUM('cartão', 'boleto', 'pix') NOT NULL,
    dataServInicio DATETIME,
    dataServFim DATETIME,
    tipo_servico ENUM ('revisão','serv_simples','serv_complexo')
    status_servico ENUM ('em_andamento','esperando_peça','finalizado')
    FOREIGN KEY (idEstoque) REFERENCES Pecas(idEstoque)
);



-- Mostrando todas as peças e suas respectivas quantidades
SELECT pecas.*, estoque.qtdPeca
FROM pecas
INNER JOIN estoque ON pecas.idPeca = estoque.idPeca;


-- Mostra a quantidade de servicos realizados com cada forma de pagamento


SELECT clientePagto, COUNT(*) as numServices
FROM agenda_servicos
GROUP BY clientePagto;

-- lista os carros que mais dão problema em ordem descendente
SELECT clienteCarro, COUNT(*) as numBreakdowns
FROM agenda_servicos
WHERE tipo_servico = 'serv_complexo' AND status_servico = 'finalizado'
GROUP BY clienteCarro
ORDER BY numBreakdowns DESC;

-- Atualiza o status de um serviço
UPDATE agenda_servicos
SET status_servico = 'em_andamento'
WHERE idAgenda = 1; 

-- mostra serviços que estão parados por falta de peças
SELECT *
FROM agenda_servicos
WHERE status_servico = 'esperando_peça';
