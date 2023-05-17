## Projeto AWS Lambda 
  <li>Este projeto é um exemplo de um sistema de gerenciamento da função lambda que utiliza a AWS Lambda como serviço principal e o S3, SQS, Amazon Rds e DynamoDb como serviços auxiliares.Assim, de forma prática um evento como um upload de um arquivo seria processado inicialmente, o SQS que é um sistema de filas(Queue) iria mandar uma mensagem para a função lambda por meio de um event source mapping sobre o arquivo baixado no s3 e ,posteriormente, usa os dados dos eventos para atualizar tabelas do DynamoDB . Além disso, ele armazena uma cópia do evento em um banco de dados MySQL.

### Topologia de Rede
  
  ![image](https://github.com/gabri190/AWS-lambda/assets/72319195/8429f45f-6ca5-4bbe-953c-cca95d45809e)

### Tecnologias
  <div> 
    <a href="terraform logo" target="_blank"><img src="https://img.shields.io/badge/-TERRAFORM-blueviolet" target="_blank"></a>
    <a href="python log" target="_blank"><img src="https://img.shields.io/badge/-PYTHON-blue" target="_blank"></a>
  </div>

### Serviços Utilizados
A aplicação de exemplo usa os seguintes serviços da AWS:

<li> S3: recebe eventos de clientes e os armazena temporariamente para processamento por meio de um bucket (upload de um evento).

<li> SQS: O Amazon SQS atua como um intermediário entre o S3 e a função Lambda, permitindo que a função seja acionada de forma assíncrona pelo evento de criação de objeto no bucket S3, após ser adicionado à fila SQS correspondente.
  
<li> AWS Lambda: lê a mensagem do SQS e envia eventos para o código do handler da função.

<li> DynamoDB: armazena listas geradas pela aplicação.

<li> Amazon RDS: armazena uma cópia dos registros processados em um banco de dados relacional.

<li> Secrets Manager: armazena a senha do banco de dados.

<li> Amazon VPC: fornece uma rede local privada para comunicação entre a função e o banco de dados.

### Requisitos
 <li> <a href="https://aws.amazon.com/pt/">AWS account</a>
 <li> <a href="https://docs.aws.amazon.com/pt_br/IAM/latest/UserGuide/id_users_create.html">AWS IAM user (usuário criado)</a>
 <li> <a href="https://www.python.org/downloads/">Python</a>
 <li> <a href="https://developer.hashicorp.com/terraform/downloads">Terraform</a>
 <li> <a href="https://us-east-1.console.aws.amazon.com/iamv2/home?region=us-east-1#/roles">Acesso a console da AWS</a>
 <li> Powershell

### Primeiros Passos

#### Instalação Terraform
Para a intalação do terraform siga o tutorial abaixo:
  <li>  <a href="https://www.youtube.com/watch?v=bSrV1Dr8py8&t=223s">Instalando o Terraform no Windows, Linux e MacOS</a>

Para conferir se o terraform está devidamente instalado vá no seu powershell e digite o seguinte comando:

~~~ 
terraform --version 
~~~

Com a imagem a seguir:

![image](https://user-images.githubusercontent.com/72319195/235461220-2acd6748-ec28-4114-98f1-b0909cc2593d.png)

### Configuração AWS
  
#### Criação de usuário e acesso as credenciais
  Para criar credenciais na AWS para usar com o Terraform posteriormente, siga as etapas abaixo:

  <li> Faça login na AWS Management Console em https://console.aws.amazon.com/

  <li> Navegue até a página de serviços e selecione "IAM" no menu "Security, Identity & Compliance".

  <li> Na página do IAM, selecione "Usuários" no painel de navegação esquerdo e clique no botão "Adicionar usuário".

  <li> Na página "Adicionar usuário", digite um nome de usuário e selecione "Acesso programático" como tipo de acesso. Em seguida, clique no botão "Avançar: Permissões".

  <li> Na página "Adicionar permissões", selecione "Anexar políticas existentes diretamente" e selecione a política "AdministratorAccess" (ou outra política que conceda as permissões necessárias para gerenciar sua infraestrutura da AWS usando o Terraform). Em seguida,clique no botão "Avançar: Tags" (opcional).

  <li> Na página "Adicionar tags", adicione tags (opcional) e clique no botão "Avançar: Revisar".

  <li> Na página "Revisar", revise as configurações da conta do usuário e clique no botão "Criar usuário".

  <li> Na página "Usuários", selecione o usuário recém-criado e clique na guia "Credenciais de segurança".

  <li> Anote ou baixe as chaves de acesso (Access Key ID e Secret Access Key) para uso posterior com o Terraform.

Agora que você criou as credenciais de acesso programático na AWS, você pode usar essas credenciais para autenticar o Terraform e gerenciar sua infraestrutura na AWS. Certifique-se de armazenar as chaves de acesso com segurança e de nunca compartilhar essas informações com outras pessoas.
  
#### Configuração da sua conta AWS no powershell

#### 1 opção
Para configurar a AWS pelo AWS CLI (command Line Interface),siga o tutorial abaixo:    
      <li> https://www.youtube.com/watch?v=saSaoZJVQnk&t=34s

 Para configurar sua conta no powershell, com o AWS CLI instalado, execute o comando "aws configure" no prompt de comando ou terminal e siga as instruções para inserir suas credenciais de acesso:

  <li> Execute o comando "aws configure" no prompt de comando ou terminal
  <li> Insira suas credenciais de acesso à AWS (chave de acesso e chave secreta) quando solicitado. Você pode obter essas credenciais na seção "Security Credentials" no Console de Gerenciamento da AWS.
  
  ![image](https://user-images.githubusercontent.com/72319195/235463289-3f9182ab-dbf3-4d1a-b279-c584b83e0d6b.png)

  <li> Escolha a região padrão para seus recursos da AWS, se solicitado.

  ![image](https://user-images.githubusercontent.com/72319195/235463366-3cb7ecbd-5582-44fd-8baa-829e236c5688.png)

  <li> Escolha o formato padrão para as saídas do AWS CLI, se solicitado.

  ![image](https://user-images.githubusercontent.com/72319195/235463479-1c2aa697-dd60-408c-930d-a0fee9779638.png)

Certifique-se de que suas credenciais estejam configuradas corretamente e que você tenha as permissões necessárias para acessar os recursos da AWS que está tentando acessar.

#### 2 opção

Para configurar a AWS no PowerShell para usar o Terraform, você não precisa necessariamente estar no diretório do seu projeto. No entanto, é importante que você tenha o arquivo de configuração de credenciais da AWS (geralmente localizado em `~/.aws/credentials` no Linux ou macOS e em `C:\Users\USERNAME\.aws\credentials` no Windows) configurado corretamente com as credenciais da sua conta da AWS.

Depois de configurar o arquivo de credenciais da AWS, você pode configurar as credenciais da AWS no PowerShell usando as seguintes variáveis de ambiente:

~~~
$env:AWS_ACCESS_KEY_ID="SUA_ACCESS_KEY_ID"
$env:AWS_SECRET_ACCESS_KEY="SUA_SECRET_ACCESS_KEY"
$env:AWS_DEFAULT_REGION="REGIÃO_PREFERENCIAL"
~~~

### Utilização terraform

Agora já estamos prontos pra utlizar o projeto com as configurações do terraform e da AWS, ou seja, os principais comandos do terraform (vistos ao longo desse tutorial) para a criação da infraestrutura serão vistos na AWS. Por isso, como um fluxo de trabalho interessante é importante fazer o trabalho de forma local e ,posteriormente, conferir todas as atualizações no seu console da AWS.

Para baixar esse projeto vá em algum diretório da sua máquina e digite :
```
git clone https://github.com/gabri190/AWS-lambda.git
```

Agora com o projeto já baixado, podemos começar a utilizar os principais comandos do terraform para subir nossa infraestrura.Dessa maneira, vá ao diretório onde seu projeto foi clonado anteriormente e digite o seguinte comando:
~~~
terraform init
~~~

A imagem a seguir mostrará a saida adequada com a infraestrutura sendo inicializada:

![image](https://github.com/gabri190/AWS-lambda/assets/72319195/8a3ed6ae-b51b-4914-bc9d-f1e6a69be38e)
    

Você pode utilizar o comando validate para validar a sintaxe do arquivo de configuração do Terraform. Ele verifica se o arquivo de configuração está correto em termos de sintaxe e de acordo com a documentação da versão do Terraform que você está usando,como a seguir:
 ~~~
terraform validate
~~~

A imagem a seguir mostrará a saida adequada com a infraestrutura validada em sintaxe:

![image](https://github.com/gabri190/AWS-lambda/assets/72319195/90602309-8c7e-40a6-9d9c-6e84243ec48d)
    
A seguir será utilizado o comando plan. Esse comando é usado para criar um plano de execução que mostra o que o Terraform fará quando você executar o comando apply. O plano mostra quais recursos serão criados, atualizados ou excluídos e quaisquer mudanças no estado que ocorrerão como resultado dessas ações. O plano é uma visualização útil do que o Terraform fará e permite que você verifique se está satisfeito com as mudanças antes de executar o comando apply.
~~~
terraform plan
~~~

A imagem a seguir mostrará a seguida adequada com a infraestrutura sendo planejada:

![image](https://github.com/gabri190/AWS-lambda/assets/72319195/5ac44d48-aad8-46a7-9da7-a2535155ed66)

A seguir será utilizado o comando plan. Esse comando é usado para criar um plano de execução que mostra o que o Terraform fará quando você executar o comando apply. O plano mostra quais recursos serão criados, atualizados ou excluídos e quaisquer mudanças no estado que ocorrerão como resultado dessas ações. O plano é uma visualização útil do que o Terraform fará e permite que você verifique se está satisfeito com as mudanças antes de executar o comando apply.
~~~
terraform apply
~~~

A imagem a seguir mostrará a seguida adequada com a infraestrutura sendo aplicada:

![image](https://github.com/gabri190/AWS-lambda/assets/72319195/c5645125-846f-485f-9ed1-20e4e7a5e5cd)



<!-- Agora por fim podemos aplicar a infraestrutura e subi-lá na AWS por meio do comando apply, mostrado a seguir (pode demorar uns minutinhos):
~~~
terraform apply
~~

A imagem a seguir mostrará a seguida adequada com a infraestrutura sendo aplicada:

![image](https://github.com/gabri190/AWS-lambda/assets/72319195/c5645125-846f-485f-9ed1-20e4e7a5e5cd)
 -->


### Teste Infraestrutura AWS

#### Recursos Criados
Primeiramente, é necessário saber se os recursos de fato foram criados na AWS:

<li> Acesse o console da AWS com o seu login e senha da AWS:
      
![image](https://github.com/gabri190/AWS-lambda/assets/72319195/9a6e3144-d068-45ff-be7b-4d651bd00086)

<li> Verifique a criação dos serviços procurando nesse campo: 
  
![image](https://github.com/gabri190/AWS-lambda/assets/72319195/102490b6-a3cf-4f6f-bce9-17095705aaf5)

Procure em sequência com os nomes "S3", "SQS" , "Lambda", "RDS" e DynamoDB"
#### Criação S3
Procure por project-terraform-s3-sqs-demo-bucket e clique para ir à pagina a seguir:

![image](https://github.com/gabri190/AWS-lambda/assets/72319195/95f04a33-db02-4785-86ab-e12ed272df16)

#### Criação SQS
Procure por project-terraform-s3-event-notification-queue e clique para ir à pagina a seguir:

![image](https://github.com/gabri190/AWS-lambda/assets/72319195/2f9a9c36-77a5-445b-b2bb-a936b292b81e)

#### Criação lambda Function
Procure por project-terraform-lambda-function e clique para ir à pagina a seguir:

![image](https://github.com/gabri190/AWS-lambda/assets/72319195/9b5d635e-6b91-43d0-bddb-49cf64937a83)

#### Criação RDS
Ao chegar a página após procurar por "RDS" no campo de pesquisa na parte esquerda procure por bancos de dados e clique para ir à pagina, posteriormente você será redirecionado a página dos bancos e clique no único banco e irá para a próxima página:

![image](https://github.com/gabri190/AWS-lambda/assets/72319195/5782616e-903d-4179-9521-5118e188b085)

#### Criação DynamoDB
Ao chegar a página após procurar por "DyanamoDB" no campo de pesquisa na parte esquerda procure por tabelas e clique para ir à pagina, posteriormente você será redirecionado a página de tabelas e clique na única tabela e irá para a próxima página:

![image](https://github.com/gabri190/AWS-lambda/assets/72319195/3b82029d-2bab-4f3c-b8b5-b26f511db43a)


#### Teste dos Recursos


### Término e destruição da Infraestrutura
    
Ao realizar todos os testes na AWS e conferir todos os recursos precisamos destruir a infraestutura e a seguir alguns motivos pelos quais precisamos realizar essa última ação:
    
<div>
  <li> Evitar custos desnecessários: Quando não precisamos mais da infraestrutura que criamos, devemos destruí-la para evitar custos desnecessários de infraestrutura em execução na nuvem.

  <li> Manter o ambiente limpo: Destruir a infraestrutura garante que o ambiente de nuvem seja mantido limpo e organizado, facilitando a manutenção e a atualização futura do ambiente.

  <li> Identificar problemas de configuração: Destruir a infraestrutura é uma boa maneira de testar se as configurações do Terraform estão funcionando corretamente. Se a infraestrutura for criada e destruída com sucesso, isso significa que as configurações do Terraform foram escritas corretamente.

  <li> Flexibilidade: A destruição da infraestrutura com o terraform destroy dá a flexibilidade de recriar a infraestrutura facilmente, se necessário, com as mesmas configurações.
</div>
    
Dito isso, o último comando será aplicado para destruir a infraestrutura.Nesse contexto, no seu terminal destrua a aplicação com o comando a seguir:
    
~~~
terraform destroy
~~~

Após destruir a infraestruturua, você verá a saída a seguir:

![image](https://github.com/gabri190/AWS-lambda/assets/72319195/aa157664-58ad-48e0-9632-5b4245694afd)

 

    

    
    
