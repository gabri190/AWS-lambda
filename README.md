## Projeto AWS Lambda 
  <li>Este projeto é um exemplo de um sistema de gerenciamento da função lambda que utiliza a AWS Lambda como serviço principal e o S3, SQS, Amazon Rds e DynamoDb como serviços auxiliares.Assim, de forma prática pode-se fazer um sistema de gerenciamento de bancos de dados ou tabelas onde o SQS que é um sistema de filas(Queue) iria mandar uma mensagem em forma de json para cadastrar algum usuário para a função lambda por meio de um event source mapping e ,posteriormente, usa os dados dos eventos (cadastro do usuário) para atualizar tabelas do DynamoDB . Além disso, ele armazena uma cópia do evento em um banco de dados MySQL (Amazon Rds).Neste projeto, foi feita a estrutura para o s3 mas o s3 não foi utilizado. Neste caso, o s3 é um possível trigger (gatilho) para a função lambda.

### Topologia de Rede
  
  ![image](https://github.com/gabri190/AWS-lambda/assets/72319195/eabea0ed-d34b-4e46-b903-faa5bb933036)
### Tecnologias
  <div> 
    <a href="terraform logo" target="_blank"><img src="https://img.shields.io/badge/-TERRAFORM-blueviolet" target="_blank"></a>
    <a href="python log" target="_blank"><img src="https://img.shields.io/badge/-PYTHON-blue" target="_blank"></a>
  </div>

### Serviços Utilizados
A aplicação de exemplo usa os seguintes serviços da AWS:

<li> S3: Feito no projeto mas não utilizado colocado como opção de um possível trigger para a função lambda!

<li> SQS: O Amazon SQS envia mensagens(cadastro de usuários) para a função lambda que irá processá-las e envia-las para o banco de dados e a tabela do dynamoDB.
  
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
    
  <li> Agora na mesma guia você pode criar as "chaves de acesso":
      
  ![image](https://github.com/gabri190/AWS-lambda/assets/72319195/082308d3-61b3-4b79-9342-21a2ff4f8d6c)


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

 Agora por fim podemos aplicar a infraestrutura e subi-lá na AWS por meio do comando apply, mostrado a seguir (pode demorar uns minutinhos):.
~~~
terraform apply -auto-approve
~~~

A imagem a seguir mostrará a seguida adequada com a infraestrutura sendo aplicada:

![image](https://github.com/gabri190/AWS-lambda/assets/72319195/ce562ef1-b87f-4417-987b-00ad10d7b550)

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

![image](https://github.com/gabri190/AWS-lambda/assets/72319195/53f4f91f-0503-414c-b028-7433b07039e6)

#### Criação DynamoDB
Ao chegar a página após procurar por "DyanamoDB" no campo de pesquisa na parte esquerda procure por tabelas e clique para ir à pagina, posteriormente você será redirecionado a página de tabelas e clique na única tabela e irá para a próxima página:

![image](https://github.com/gabri190/AWS-lambda/assets/72319195/3b82029d-2bab-4f3c-b8b5-b26f511db43a)


#### Teste dos Recursos

Agora podemos testar os recursos criados na AWS, como visto anteriormente:

<li> Com tudo criado volte para a função lambda criada, e na parte principal vá em testar:
 
![image](https://github.com/gabri190/AWS-lambda/assets/72319195/28506f13-a504-43e8-893a-2473b20af3dc)

<li> Substitua o JSON do evento pelo código a seguir:
 
test.json  
 ~~~
 {
    "Records": [
      {
        "messageId": "059f36b4-87a3-44ab-83d2-661975830a7d",
        "receiptHandle": "AQEBwJnKyrHigUMZj6rYigCgxlaS3SLy0a...",
        "body": "{\n     \"CustID\": 1021,\n     \"Name\": \"Martha Rivera\"\n}",
        "attributes": {
          "ApproximateReceiveCount": "1",
          "SentTimestamp": "1545082649183",
          "SenderId": "AIDAIENQZJOLO23YVJ4VO",
          "ApproximateFirstReceiveTimestamp": "1545082649185"
        },
        "messageAttributes": {},
        "md5OfBody": "e4e68fb7bd0e697a0ae8f1bb342846b3",
        "eventSource": "aws:sqs",
        "eventSourceARN": "arn:aws:sqs:us-east-1:108791993403:project-terraform-s3-event-notification-queue",
        "awsRegion": "us-east-1"
      }
    ]
  } 
 ~~~
 
<li> Salve o evento e agora estaremos prontos pra testar!
  
<li> Volte para a parte de código e após clicar em teste, a imagem a seguir deverá aparecer avisando que 1 item foi adicionado ao RDS:
 
![image](https://github.com/gabri190/AWS-lambda/assets/72319195/2a054f7c-7d55-4a28-8289-886934a17d36)

<li> Agora volte ao recurso criado do SQS (queue) ,clique na queue criada e posteriormente, clique em enviar e recever mensagens e já nessa página envie a mensagem a seguir:
 
![image](https://github.com/gabri190/AWS-lambda/assets/72319195/62bd7e54-2eee-4e8a-8ff7-7aaa1de4ace4)

<li> Agora volte para a função Lambda e altere o Json de evento para evitar chaves duplicadas
  
~~~
{
    "Records": [
      {
        "messageId": "059f36b4-87a3-44ab-83d2-661975830a7d",
        "receiptHandle": "AQEBwJnKyrHigUMZj6rYigCgxlaS3SLy0a...",
        "body": "{\n     \"CustID\": 1023,\n     \"Name\": \"Gabriel Alves\"\n}",
        "attributes": {
          "ApproximateReceiveCount": "1",
          "SentTimestamp": "1545082649183",
          "SenderId": "AIDAIENQZJOLO23YVJ4VO",
          "ApproximateFirstReceiveTimestamp": "1545082649185"
        },
        "messageAttributes": {},
        "md5OfBody": "e4e68fb7bd0e697a0ae8f1bb342846b3",
        "eventSource": "aws:sqs",
        "eventSourceARN": "arn:aws:sqs:us-east-1:108791993403:project-terraform-s3-event-notification-queue",
        "awsRegion": "us-east-1"
      }
    ]
  }
~~~
  
Após isso teremos a imagem (eu já havia criado outro evento antes):  

![image](https://github.com/gabri190/AWS-lambda/assets/72319195/7ea88fa8-c8eb-4a03-8e6e-8f9a26ead5e0)
  
Na imagem anterior percebemos a criação de 2 items ( 1 item havia sido criado antes) além  do item que foi criado anteriormente de maneira que um deles foi criado no JSON de evento e outro por meio do envio da mensagem da SQS para a função lambda:

![image](https://github.com/gabri190/AWS-lambda/assets/72319195/ed858955-e1d6-4c24-8478-51403d01ba01)
  
<li> Podemos também ver essas criações por meio do cloudwatch, pesquise por cloudwatch e ao chegar à página clique em Grupos de Logs na parte de Logs:

![image](https://github.com/gabri190/AWS-lambda/assets/72319195/c5d5693b-5861-4820-a1a8-25acbf0a0026)

Clique em   **/aws/lambda/project-terraform-lambda-function** :
  
![image](https://github.com/gabri190/AWS-lambda/assets/72319195/549d9236-4f4d-4ac7-976b-44998c587734)

<li> Na parte de Streams de Log clique no mais recente:

![image](https://github.com/gabri190/AWS-lambda/assets/72319195/c0c91d7b-59a4-487a-a82b-3cb8d8c03310)

<li> Você verá a criação dos cadastros que foram mostrados anteriormente:

![image](https://github.com/gabri190/AWS-lambda/assets/72319195/3e639ca2-80c6-49ea-b5ef-57a79d29104e)

<li> Agora modifique o código python na seção de códigos da função lambda para o último teste agora em relação ao DynamoDB!  
  
~~~  
def lambda_handler(event, context):
    print('Incoming event: ', event)
    print('Incoming state: ', event['state'])

#Check if this is the end of the window to either aggregate or process.
    if event['isFinalInvokeForWindow']:
        # logic to handle final state of the window
        print('Destination invoke')
    else:
        print('Aggregate invoke')

#Check for early terminations
    if event['isWindowTerminatedEarly']:
        print('Window terminated early')

    #Aggregation logic
    state = event['state']
    for record in event['Records']:
        state[str(record['dynamodb']['Keys']['Id']['N'])] = state.get(str(record['dynamodb']['Keys']['Id']['N']), 0) + 1


    print('Returning state: ', state)
    return {'state': state}
 ~~~
  
<li> Modifique também o JSON de evento:

 ~~~
 {
  "Records": [
    {
      "eventID": "1",
      "eventName": "INSERT",
      "eventVersion": "1.0",
      "eventSource": "aws:dynamodb",
      "awsRegion": "us-east-1",
      "dynamodb": {
        "Keys": {
          "Id": {
            "N": "101"
          }
        },
        "NewImage": {
          "Message": {
            "S": "New item!"
          },
          "Id": {
            "N": "101"
          }
        },
        "SequenceNumber": "111",
        "SizeBytes": 26,
        "StreamViewType": "NEW_AND_OLD_IMAGES"
      },
      "eventSourceARN": "stream-ARN"
    },
    {
      "eventID": "2",
      "eventName": "MODIFY",
      "eventVersion": "1.0",
      "eventSource": "aws:dynamodb",
      "awsRegion": "us-east-1",
      "dynamodb": {
        "Keys": {
          "Id": {
            "N": "101"
          }
        },
        "NewImage": {
          "Message": {
            "S": "This item has changed"
          },
          "Id": {
            "N": "101"
          }
        },
        "OldImage": {
          "Message": {
            "S": "New item!"
          },
          "Id": {
            "N": "101"
          }
        },
        "SequenceNumber": "222",
        "SizeBytes": 59,
        "StreamViewType": "NEW_AND_OLD_IMAGES"
      },
      "eventSourceARN": "stream-ARN"
    },
    {
      "eventID": "3",
      "eventName": "REMOVE",
      "eventVersion": "1.0",
      "eventSource": "aws:dynamodb",
      "awsRegion": "us-east-1",
      "dynamodb": {
        "Keys": {
          "Id": {
            "N": "101"
          }
        },
        "OldImage": {
          "Message": {
            "S": "This item has changed"
          },
          "Id": {
            "N": "101"
          }
        },
        "SequenceNumber": "333",
        "SizeBytes": 38,
        "StreamViewType": "NEW_AND_OLD_IMAGES"
      },
      "eventSourceARN": "stream-ARN"
    }
  ],
  "window": {
    "start": "2020-07-30T17:00:00Z",
    "end": "2020-07-30T17:05:00Z"
  },
  "state": {
    "1": "state1"
  },
  "shardId": "shard123456789",
  "eventSourceARN": "stream-ARN",
  "isFinalInvokeForWindow": false,
  "isWindowTerminatedEarly": false
} 
~~~
  
Você verá a seguinte saída:
 
![image](https://github.com/gabri190/AWS-lambda/assets/72319195/2a0a7d7c-6a9e-4f92-80ab-288bf20dc67e)


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

 

    

    
    
