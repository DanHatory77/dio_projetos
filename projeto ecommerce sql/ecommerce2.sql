
-- comando para criar o banco de dados 
CREATE DATABASE ecommerce2;
USE ecommerce2;

-- comando para criar a tabela pessoa
CREATE TABLE Person (
    idPerson INT PRIMARY KEY AUTO_INCREMENT,
    namePerson VARCHAR(100) NOT NULL,
    CPF INT(11) NOT NULL
);

-- comando para criar a tabela vendedor
CREATE TABLE Seller (
    idSeller INT PRIMARY KEY AUTO_INCREMENT,
    idPerson INT NOT NULL,
    SellerCode INT NOT NULL,
    FOREIGN KEY (idPerson) REFERENCES Person(idPerson)
);
-- comando para criar a tabela cliente
CREATE TABLE Client (
    idClient INT PRIMARY KEY AUTO_INCREMENT,
    idPerson INT NOT NULL,
    nameClient VARCHAR(100) NOT NULL,
    DebtClient ENUM('S','N') NOT NULL,
    typeClient ENUM('PF', 'PJ') NOT NULL,
    FOREIGN KEY (idPerson) REFERENCES Person(idPerson)
);

-- comando para criar a tabela fornecedor
CREATE TABLE Supplier (
    idSupplier INT PRIMARY KEY AUTO_INCREMENT,
    idPerson INT NOT NULL,
    SupplierCode INT NOT NULL,
    FOREIGN KEY (idPerson) REFERENCES Person(idPerson)
);

-- comando para criar a tabela produto
CREATE TABLE Product (
    idProduct INT PRIMARY KEY AUTO_INCREMENT,
    nameProduct VARCHAR(100) NOT NULL,
    
);

-- comando para criar a tabela estoque de produtos
CREATE TABLE ProductStorage (
    idProductStorage INT PRIMARY KEY AUTO_INCREMENT,
    idProduct INT NOT NULL,
    idSupplier INT NOT NULL,
    quantProd INT NOT NULL,
    FOREIGN KEY (idProduct) REFERENCES Product(idProduct),
    FOREIGN KEY (idSupplier) REFERENCES Supplier(idSupplier)
);

-- comando para criar a tabela produtos prontos para serem vendidos
CREATE TABLE ReadyProducts (
    idReadyProd INT PRIMARY KEY AUTO_INCREMENT,
    idProductStorage INT NOT NULL,
    priceProd DECIMAL(10, 2) NOT NULL,
    readyProdQuant INT NOT NULL
    FOREIGN KEY (idProductStorage) REFERENCES ProductStorage(idProductStorage)
);

-- comando para criar a tabela de vendas
CREATE TABLE Sales (
    idSales INT PRIMARY KEY AUTO_INCREMENT,
    idReadyProd INT NOT NULL,
    idClient INT NOT NULL,
    idSeller INT NOT NULL,
    payType ENUM('cartão', 'boleto', 'pix') NOT NULL,
    dateSale DATETIME NOT NULL,

    FOREIGN KEY (idReadyProd) REFERENCES ReadyProducts(idReadyProd),
    FOREIGN KEY (idClient) REFERENCES Client(idClient),
    FOREIGN KEY (idSeller) REFERENCES Seller(idSeller)
);

-- comando para criar a tabela de entregas
CREATE TABLE Delivery (
    idDelivery INT PRIMARY KEY AUTO_INCREMENT,
    idSales INT NOT NULL,
    typeDelivery ENUM('sedex', 'pac') NOT NULL,
    deliveryDate DATETIME,
    deliveryStatus ENUM('em_viagem','atraso','entregue','destino_nulo','encomenda_perdida')
    tracker_code INT(20),
    FOREIGN KEY (idSales) REFERENCES Sales(idSales)
);

-- SCRIPTS PARA A OBTENÇÃO DE INFORMAÇÕES DO BANCO

-- Quantos clientes que estão devendo estão fazendo compras:
SELECT COUNT(DISTINCT s.idClient) AS num_clients_with_debt
FROM Sales s
INNER JOIN Client c ON s.idClient = c.idClient
WHERE c.DebtClient = 1;

-- Com qual das opções os clientes estão gastando mais dinheiro? Boleto, cartão ou Pix?
SELECT payType, AVG(TotalPrice) AS average_amount
FROM Sales
GROUP BY payType;

--Qual é o dia e a hora que as pessoas mais compram?
SELECT DATE(dateSale) AS sale_date, COUNT(*) AS num_products_sold
FROM Sales
GROUP BY sale_date
ORDER BY num_products_sold DESC
LIMIT 1;

--Qual é o dia que as pessoas menos compram? 
SELECT DATE(dateSale) AS sale_date, COUNT(*) AS num_products_sold
FROM Sales
GROUP BY sale_date
ORDER BY num_products_sold ASC
LIMIT 1;

--Quais são as horas em que mais e menos produtos são vendidos?

-- Horas com mais vendas
SELECT DATE(dateSale) AS sale_date, HOUR(dateSale) AS sale_hour, COUNT(*) AS num_sales
FROM Sales
GROUP BY sale_date, sale_hour
ORDER BY num_sales DESC
LIMIT 1;

-- Horas com menos vendas
SELECT DATE(dateSale) AS sale_date, HOUR(dateSale) AS sale_hour, COUNT(*) AS num_sales
FROM Sales
GROUP BY sale_date, sale_hour
ORDER BY num_sales ASC
LIMIT 1;