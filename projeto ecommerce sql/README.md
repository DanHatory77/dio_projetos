# Projeto Banco E-commerce2

## Introdução
Banco de dados para loja online de peças para computador.

Esse script foi criado para gerenciar o processo de vendas, estoque de produtos, entregas além da gestão de funcionários,  clientes e fornecedores.
Ele também conta com funções uteis para obter diversas informações estrategicas para o bom funcionamento do negócio.

_Ps: A sintaxe do script está toda em inglês pois quero usar essa oportunidade para melhorar minha capacidade linguistica e poder aplicar para vagas no exterior._

## Criação do banco
### Tabelas Pessoa(Person), Cliente(Clients), Vendedor(Seller) e fornecedor(supplier)
Tabelas que representam os principais atores do banco. Sendo o 'Pessoa' com informações genericas, os outros com caracteristicas especiais. Vendedor e fornecedor tem codigos exclusivos para a identificação e o cliente tem o campo 'DebtClient' que sinaliza se o cliente está devendo, e o campo 'typeClient' que informa se o cliente é 'PF'(pessoa fisica) ou é 'PJ' (Pessoa juridica).

### Tabela produto(Product)
Armazena caracteristicas basicas do produto como nome e id.

### Tabela estoque(ProductStorage)
Nessa tabela relacionamos os produtos com seus fornecedores e armazenamos a quantidade de cada produto.

### Tabela Produtos para a venda(ReadyProducts)
Armazena os produtos prontos para vender. É nessa tabela que também são armazenados a quantidade de produtos prontos para a venda e o preço. 
Apenas inserimos produtos nessa tabela que estejam na tabela estoque e tenham passado pela verificação para se tornarem aptos a serem vendidos.
Por meio dessa tabela podemos garantir o produto que o cliente escolheu para comprar, evitando atrasos, frustações e melhorando a logistica da empresa. 

### Tabela vendas(Sales)

Nessa tabela relacionamos o produto pronto para ser vendido, o cliente e o vendedor. E adicionamos mais duas colunas: Tipo de pagamento(payType) que informa se o cliente pagou com 'Cartão', 'Boleto' ou 'Pix' e a data da venda(dateSale). 

### Tabela entrega(Delivery)
Nessa ultima tabela, além do relacionamento com a tabela vendas, também registramos o tipo de entrega(typeDelivery) que pode ser 'Sedex' ou 'Pac', a data da entrega(dateDelivery) e a situação da entrega(statusDelivery) que pode ser 'em_viagem', 'entregue', 'atraso', 'destino_nulo' ou 'emcomenda_perdida'. 

## Consultas de informações

Depois de inserir os dados nas tabelas podemos por meio de queries(perguntas) onter informações do banco.

### Quantos clientes que estão devendo estão fazendo compras:

```console
SELECT COUNT(DISTINCT s.idClient) AS num_clients_with_debt
FROM Sales s
INNER JOIN Client c ON s.idClient = c.idClient
WHERE c.DebtClient = 1;
```


### Com qual das opções os clientes estão gastando mais dinheiro? Boleto, cartão ou Pix?
```console
SELECT payType, AVG(TotalPrice) AS average_amount
FROM Sales
GROUP BY payType;
```

### Qual é o dia e a hora que as pessoas mais compram?
```console
SELECT DATE(dateSale) AS sale_date, COUNT(*) AS num_products_sold
FROM Sales
GROUP BY sale_date
ORDER BY num_products_sold DESC
LIMIT 1;
```

### Qual é o dia que as pessoas menos compram? 
```console
SELECT DATE(dateSale) AS sale_date, COUNT(*) AS num_products_sold
FROM Sales
GROUP BY sale_date
ORDER BY num_products_sold ASC
LIMIT 1;
```

### Quais são as horas em que mais e menos produtos são vendidos?

#### Horas com mais vendas
```console
SELECT DATE(dateSale) AS sale_date, HOUR(dateSale) AS sale_hour, COUNT(*) AS num_sales
FROM Sales
GROUP BY sale_date, sale_hour
ORDER BY num_sales DESC
LIMIT 1;
```

#### Horas com menos vendas
```console
SELECT DATE(dateSale) AS sale_date, HOUR(dateSale) AS sale_hour, COUNT(*) AS num_sales
FROM Sales
GROUP BY sale_date, sale_hour
ORDER BY num_sales ASC
LIMIT 1;
```
