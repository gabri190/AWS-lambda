## Projeto AWS-lambda 

### Introdução
  <li>Esse projeto tem por objetivo criar códigos via terraform e fazer a integração do serviços da AWS lambda ,amazon RDS e amazon DinamoDb.
  <li>Um evento gerado por uma lambda event source mapping e configurado através de uma lambda function e esse dado é armazenado no amazon RDS, que utiliza Mysql, e também,
  por meio de uma VPC Endpoint é armazenado em tabelas com amazon DinamoDB.

### Topologia de Rede

![image](https://user-images.githubusercontent.com/72319195/235350674-5ac287bc-5c0c-44cc-af51-8b124f9472d8.png)


