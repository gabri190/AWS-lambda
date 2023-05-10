## Gerenciador de listas com AWS Lambda e Kinesis 
  <li>Este projeto é um exemplo de um sistema de gerenciamento de listas que utiliza a AWS Lambda como serviço principal e o Kinesis para processar eventos. A função de processador lê eventos de uma transmissão do Kinesis e usa os dados dos eventos para atualizar tabelas do DynamoDB. Além disso, ele armazena uma cópia do evento em um banco de dados MySQL.

### Topologia de Rede
  ![image](https://user-images.githubusercontent.com/72319195/235454593-a6150253-94b5-463d-8d08-0a0dabb0aa83.png)

### Tecnologias
  <div> 
    <a href="terraform logo" target="_blank"><img src="https://img.shields.io/badge/-TERRAFORM-blueviolet" target="_blank"></a>
    <a href="python log" target="_blank"><img src="https://img.shields.io/badge/-PYTHON-blue" target="_blank"></a>
  </div>

### Serviços Utilizados
A aplicação de exemplo usa os seguintes serviços da AWS:

<li> Kinesis: recebe eventos de clientes e os armazena temporariamente para processamento.

<li> AWS Lambda: lê a transmissão do Kinesis e envia eventos para o código do handler da função.

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
      
Para configurar sua conta no powershell, execute o comando "aws configure" no prompt de comando ou terminal e siga as instruções para inserir suas credenciais de acesso:

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

### Utilização

Agora já estamos prontos pra utlizar o projeto com as configurações do terraform e da AWS, ou seja, os principais comandos do terraform (vistos ao longo desse tutorial) para a criação da infraestrutura serão vistos na AWS. Por isso, como um fluxo de trabalho interessante é importante fazer o trabalho de forma local e ,posteriormente, conferir todas as atualizações no seu console da AWS.





