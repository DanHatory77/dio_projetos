# Projeto Gestão de oficina mecanica

## Introdução
Esse projeto foi criado para solucionar a necessidade de organização e armazenamento de informações de uma oficina mecanica. Com ele podemos armazenar informações importantes de forma simples e prática. Também podemos obter diversas informações relevantes ao negocio por meio das queries.

## Criação do banco

### Peças

```console
CREATE TABLE pecas(
    idPeca INT PRIMARY KEY NOT NULL,
    tipoPeca VARCHAR(255) NOT NULL,
    fabriPeca VARCHAR(255) NOT NULL,
    anoPeca DATE,
    infoPeca VARCHAR(255) NOT NULL
);
```

Armazena informações cadastrais sobre as peças automitivas. Também é possivel guardar observações relevantes. 

### estoque

```console
CREATE TABLE estoque(
    idEstoque INT PRIMARY KEY NOT NULL,
    idPeça INT NOT NULL,
    qtdPeca INT NOT NULL,
    FOREIGN KEY (idPeca) REFERENCES Pecas(idPeca)
);
```

Armazena informações do estoque de peças e a quantidade disponivel de cada uma.

### agenda_servicos

```console
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
```

Armazena informações de serviços mecanicos que já aconteceram, estão aconteceram e agenda proximos serviços. Também são armazenadas informações de forma de pagamento do cliente, tipo de serviço e qual é o status do serviço.

## Queries 


### Quais são as peças cadastradas no sistema e quantas são?

```console
SELECT pecas.*, estoque.qtdPeca
FROM pecas
INNER JOIN estoque ON pecas.idPeca = estoque.idPeca;
```

### Quantos serviços são realizados com cada forma de pagamento?
 
```console
SELECT clientePagto, COUNT(*) as numServices
FROM agenda_servicos
GROUP BY clientePagto;
```

### Quais são os carros que mais dão problema
 
```console
SELECT clienteCarro, COUNT(*) as numBreakdowns
FROM agenda_servicos
WHERE tipo_servico = 'serv_complexo' AND status_servico = 'finalizado'
GROUP BY clienteCarro
ORDER BY numBreakdowns DESC;
```

### Quais serviços estão parados por falta de peças?

```console
SELECT *
FROM agenda_servicos
WHERE status_servico = 'esperando_peça';
```

### Quando o status de um serviço muda, como faço para altera-lo no banco?

```console
UPDATE agenda_servicos
SET status_servico = 'em_andamento'
WHERE idAgenda = 1; 
```

 
