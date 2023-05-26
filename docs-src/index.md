# AWS Lambda User Registration

Este projeto é um exemplo de um sistema de gerenciamento da função lambda que utiliza a AWS Lambda como serviço principal e SQS, Amazon Rds, DynamoDb e CloudWatch como serviços auxiliares.Assim, de forma prática pode-se fazer um sistema de gerenciamento de bancos de dados ou tabelas onde o SQS que é um sistema de filas(Queue) iria mandar uma mensagem em forma de json para cadastrar algum usuário para a função lambda por meio de um event source mapping e ,posteriormente, usa os dados dos eventos (cadastro do usuário) para atualizar tabelas do DynamoDB . Além disso, ele armazena uma cópia do evento em um banco de dados MySQL (Amazon Rds).

## Topologia de Rede
  
![image](https://github.com/gabri190/AWS-lambda/assets/72319195/eabea0ed-d34b-4e46-b903-faa5bb933036)

## Tecnologias
   
<a href="terraform logo" target="_blank"><img src="https://img.shields.io/badge/-TERRAFORM-blueviolet" target="_blank"></a>
<a href="python log" target="_blank"><img src="https://img.shields.io/badge/-PYTHON-blue" target="_blank"></a>
  

## Serviços Utilizados

A aplicação de exemplo usa os seguintes serviços da AWS:

-  SQS: O Amazon SQS envia mensagens(cadastro de usuários) para a função lambda que irá processá-las e envia-las para o banco de dados e a tabela do dynamoDB.
  
-  AWS Lambda: lê a mensagem do SQS e envia eventos para o código do handler da função.

-  DynamoDB: armazena listas geradas pela aplicação.

-  Amazon RDS: armazena uma cópia dos registros processados em um banco de dados relacional.
 
-  CloudWatch: Por meio dos streams de Log é possível saber se os cadastros foram criados.

-  Amazon VPC: fornece uma rede local privada para comunicação entre a função lambda e o banco de dados que necessitam estar na mesma subnet.

## Requisitos

 -  <a href="https://aws.amazon.com/pt/">AWS account</a>
 -  <a href="https://docs.aws.amazon.com/pt_br/IAM/latest/UserGuide/id_users_create.html">AWS IAM user (usuário criado)</a>
 -  <a href="https://www.python.org/downloads/">Python</a>
 -  <a href="https://developer.hashicorp.com/terraform/downloads">Terraform</a>
 -  <a href="https://us-east-1.console.aws.amazon.com/iamv2/home?region=us-east-1#/roles">Acesso a console da AWS</a>
 -  Powershell

## Primeiros Passos


### Instalação Terraform
Para a intalação do terraform siga o tutorial abaixo:
  -   <a href="https://www.youtube.com/watch?v=bSrV1Dr8py8&t=223s">Instalando o Terraform no Windows, Linux e MacOS</a>

Para conferir se o terraform está devidamente instalado vá no seu powershell e digite o seguinte comando:

~~~ 
terraform --version 
~~~

Com a imagem a seguir:

![image](https://user-images.githubusercontent.com/72319195/235461220-2acd6748-ec28-4114-98f1-b0909cc2593d.png)

### Configuração AWS
  
#### Criação de usuário e acesso as credenciais
  Para criar credenciais na AWS para usar com o Terraform posteriormente, siga as etapas abaixo:

  -  Faça login na AWS Management Console em https://console.aws.amazon.com/

  -  Navegue até a página de serviços e selecione "IAM" no menu "Security, Identity & Compliance".

  -  Na página do IAM, selecione "Usuários" no painel de navegação esquerdo e clique no botão "Adicionar usuário".

  -  Na página "Adicionar usuário", digite um nome de usuário e selecione "Acesso programático" como tipo de acesso. Em seguida, clique no botão "Avançar: Permissões".

  -  Na página "Adicionar permissões", selecione "Anexar políticas existentes diretamente" e selecione a política "AdministratorAccess" (ou outra política que conceda as permissões necessárias para gerenciar sua infraestrutura da AWS usando o Terraform). Em seguida,clique no botão "Avançar: Tags" (opcional).

  -  Na página "Adicionar tags", adicione tags (opcional) e clique no botão "Avançar: Revisar".

  -  Na página "Revisar", revise as configurações da conta do usuário e clique no botão "Criar usuário".

  -  Na página "Usuários", selecione o usuário recém-criado e clique na guia "Credenciais de segurança".
    
  -  Agora na mesma guia você pode criar as "chaves de acesso":
      
  ![image](https://github.com/gabri190/AWS-lambda/assets/72319195/082308d3-61b3-4b79-9342-21a2ff4f8d6c)


  -  Anote ou baixe as chaves de acesso (Access Key ID e Secret Access Key) para uso posterior com o Terraform.

Agora que você criou as credenciais de acesso programático na AWS, você pode usar essas credenciais para autenticar o Terraform e gerenciar sua infraestrutura na AWS. Certifique-se de armazenar as chaves de acesso com segurança e de nunca compartilhar essas informações com outras pessoas.
  
#### Configuração da sua conta AWS no powershell

#### 1 opção
Para configurar a AWS pelo AWS CLI (command Line Interface),siga o tutorial abaixo:    
      -  https://www.youtube.com/watch?v=saSaoZJVQnk&t=34s

 Para configurar sua conta no powershell, com o AWS CLI instalado, execute o comando "aws configure" no prompt de comando ou terminal e siga as instruções para inserir suas credenciais de acesso:

  -  Execute o comando "aws configure" no prompt de comando ou terminal
  -  Insira suas credenciais de acesso à AWS (chave de acesso e chave secreta) quando solicitado. Você pode obter essas credenciais na seção "Security Credentials" no Console de Gerenciamento da AWS.
  
  ![image](https://user-images.githubusercontent.com/72319195/235463289-3f9182ab-dbf3-4d1a-b279-c584b83e0d6b.png)

  -  Escolha a região padrão para seus recursos da AWS, se solicitado.

  ![image](https://user-images.githubusercontent.com/72319195/235463366-3cb7ecbd-5582-44fd-8baa-829e236c5688.png)

  -  Escolha o formato padrão para as saídas do AWS CLI, se solicitado.

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

Utilização terraform
---------------

Agora já estamos prontos pra utlizar o projeto com as configurações do terraform e da AWS, ou seja, os principais comandos do terraform (vistos ao longo desse tutorial) para a criação da infraestrutura serão vistos na AWS. Por isso, como um fluxo de trabalho interessante é importante fazer o trabalho de forma local e ,posteriormente, conferir todas as atualizações no seu console da AWS.

Para baixar esse projeto vá em algum diretório da sua máquina e digite :
```
git clone https://github.com/gabri190/AWS-lambda.git
```

Para aqueles que não possuem alguma dependência necessária para esse projeto, foi criado um arquivo requirements.txt e para rodar utilize o seguinte comando abaixo:

~~~
pip install -r requirements.txt
~~~
  
Como já instalei, a imagem a seguir mostrará as dependências já instaladas



![image](https://github.com/gabri190/AWS-lambda/assets/72319195/3cb6db53-5319-415d-875a-6a75ff1fc2b6)


    
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

![image](https://github.com/gabri190/AWS-lambda/assets/72319195/bd4538ee-68ba-41b5-95dc-bdb378d04bb7)
    
Agora por fim podemos aplicar a infraestrutura e subi-lá na AWS por meio do comando apply, mostrado a seguir (pode demorar uns minutinhos):.
~~~
terraform apply -auto-approve
~~~

A imagem a seguir mostrará a seguida adequada com a infraestrutura sendo aplicada:

![image](https://github.com/gabri190/AWS-lambda/assets/72319195/b847cc46-8e0d-44eb-be9d-4afc9799ab5d)
    
Teste Infraestrutura AWS
---------------
    
### Recursos Criados
Primeiramente, é necessário saber se os recursos de fato foram criados na AWS:

-  Acesse o console da AWS com o seu login e senha da AWS:
      
![image](https://github.com/gabri190/AWS-lambda/assets/72319195/9a6e3144-d068-45ff-be7b-4d651bd00086)

-  Verifique a criação dos serviços procurando nesse campo: 
  
![image](https://github.com/gabri190/AWS-lambda/assets/72319195/102490b6-a3cf-4f6f-bce9-17095705aaf5)

Procure em sequência com os nomes "SQS" , "Lambda", "RDS" e DynamoDB"

#### Criação SQS
Procure por project-terraform-event-notification-queue e clique para ir à pagina a seguir:

![image](https://github.com/gabri190/AWS-lambda/assets/72319195/193739f0-05b0-4a17-af95-d2782234fd33)

#### Criação lambda Function
Procure por project-terraform-lambda-function e clique para ir à pagina a seguir:

![image](https://github.com/gabri190/AWS-lambda/assets/72319195/9b5d635e-6b91-43d0-bddb-49cf64937a83)

#### Criação RDS
Ao chegar a página após procurar por "RDS" no campo de pesquisa na parte esquerda procure por bancos de dados e clique para ir à pagina, posteriormente você será redirecionado a página dos bancos e clique no único banco e irá para a próxima página:

![image](https://github.com/gabri190/AWS-lambda/assets/72319195/53f4f91f-0503-414c-b028-7433b07039e6)

#### Criação DynamoDB
Ao chegar a página após procurar por "DyanamoDB" no campo de pesquisa na parte esquerda procure por tabelas e clique para ir à pagina, posteriormente você será redirecionado a página de tabelas e clique na única tabela e irá para a próxima página:

![image](https://github.com/gabri190/AWS-lambda/assets/72319195/3b82029d-2bab-4f3c-b8b5-b26f511db43a)


### Teste dos Recursos

Agora podemos testar os recursos criados na AWS, como visto anteriormente:

-  Com tudo criado volte para a função lambda criada, e na parte principal vá em testar:
 
![image](https://github.com/gabri190/AWS-lambda/assets/72319195/28506f13-a504-43e8-893a-2473b20af3dc)

-  Substitua o JSON do evento pelo código a seguir:
 
test.json  
 ```json
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
        "eventSourceARN": "*",
        "awsRegion": "us-east-1"
      }
    ]
  }
 ```
 
-  Salve o evento e volte para o Banco de dados RDS que foi criado!

- Observe a imagem a seguir:

![image](https://github.com/gabri190/AWS-lambda/assets/72319195/53f4f91f-0503-414c-b028-7433b07039e6)

- Na imagem anterior você viu a instância de banco de dados que foi criada, com isso, guarde o valor da Endpoint (está em segurança e conexão em Endpoint e Porta) , pois iremos utilizá-la para acessar o banco de dados, lembrando que cada usuário possuirá uma endpoint diferente.

- Agora volte a função lambda e na parte de código,você verá o código a seguir:


```python

import sys
import logging
import pymysql
import json

# rds settings
rds_host  = "My_RDS_Endpoint"
user_name = "admin"
password = "admin-gabriel"
db_name = "database_lambda"

logger = logging.getLogger()
logger.setLevel(logging.INFO)

# create the database connection outside of the handler to allow connections to be
# re-used by subsequent function invocations.
try:
    conn = pymysql.connect(host=rds_host, user=user_name, passwd=password, db=db_name, connect_timeout=5)
except pymysql.MySQLError as e:
    logger.error("ERROR: Unexpected error: Could not connect to MySQL instance.")
    logger.error(e)
    sys.exit()

logger.info("SUCCESS: Connection to RDS MySQL instance succeeded")

def lambda_handler(event, context):
    """
    This function creates a new RDS database table and writes records to it
    """
    message = event['Records'][0]['body']
    data = json.loads(message)
    CustID = data['CustID']
    Name = data['Name']

    item_count = 0
    sql_string = f"insert into Customer (CustID, Name) values({CustID}, '{Name}')"

    with conn.cursor() as cur:
        cur.execute("create table if not exists Customer ( CustID  int NOT NULL, Name varchar(255) NOT NULL, PRIMARY KEY (CustID))")
        cur.execute(sql_string)
        conn.commit()
        cur.execute("select * from Customer")
        logger.info("The following items have been added to the database:")
        for row in cur:
            item_count += 1
            logger.info(row)
    conn.commit()

    return "Added %d items to RDS MySQL table" %(item_count)
```


- Nessa parte do código: 

```python

rds_host  = "My_RDS_Endpoint"

``` 

Substitua o valor de My_RDS_Endpoint pelo valor da endpoint que você guardou anteriormente.

- Agora sim com JSON de evento salvo e o código substituído, clique em testar e a imagem a seguir deverá aparecer avisando que 1 item foi adicionado ao RDS:

![image](https://github.com/gabri190/AWS-lambda/assets/72319195/17ef8b8f-bee4-4e5e-b7d1-732d54e3cc04)
  
-  Agora volte ao recurso criado do SQS (queue) ,clique na queue criada e posteriormente, clique em enviar e receber mensagens e já nessa página envie a mensagem a seguir:
 
![image](https://github.com/gabri190/AWS-lambda/assets/72319195/62bd7e54-2eee-4e8a-8ff7-7aaa1de4ace4)

-  A mensagem correspondente em um json:

sqs_test.json
```json
{
  "CustID": 1054,
  "Name": "Richard Roe"
}
```
  

-  Podemos ver essas criações por meio do cloudwatch, pesquise por cloudwatch e ao chegar à página clique em Grupos de Logs na parte de Logs:

<div align="center">

<img src="https://github.com/gabri190/AWS-lambda/assets/72319195/8694085c-df38-4c91-ade2-884ffa260868">

</div>


- Clique em   **/aws/lambda/project-terraform-lambda-function** :
  

![image](https://github.com/gabri190/AWS-lambda/assets/72319195/549d9236-4f4d-4ac7-976b-44998c587734)
  

-  Clique no último log criado (o primeiro de cima pra baixo):

![image](https://github.com/gabri190/AWS-lambda/assets/72319195/0aa71985-92ce-4c66-a848-5b238d82e182)


-  Após isso teremos a imagem :  

![image](https://github.com/gabri190/AWS-lambda/assets/72319195/e576eec3-1d77-404b-a2a5-54a1ee3fdec4)
  
-  Na imagem anterior percebemos, entre todas as mensagens, a criação de 2 items de maneira que um deles foi criado no JSON de evento simulado e outro por meio do envio da mensagem da SQS para a função lambda:

![image](https://github.com/gabri190/AWS-lambda/assets/72319195/a0e2976a-4611-46fd-89b1-bb838a313978)
  
-  Agora modifique o código python na seção de códigos da função lambda para o último teste agora em relação ao DynamoDB!  
  
``` python
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
```
  
-  Modifique também o JSON de evento:

```json
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
```
  
-  Você verá a seguinte saída:
 
![image](https://github.com/gabri190/AWS-lambda/assets/72319195/2a0a7d7c-6a9e-4f92-80ab-288bf20dc67e)

-  Pelo cloudwatch podemos ver nos streams de log (clique sempre no último de cima pra baixo) o item criado:
  
![image](https://github.com/gabri190/AWS-lambda/assets/72319195/c888ead8-8075-4fcd-a44d-8e4ab48eda29)

Término e destruição da Infraestrutura
---------------  

Ao realizar todos os testes na AWS e conferir todos os recursos precisamos destruir a infraestutura e a seguir alguns motivos pelos quais precisamos realizar essa última ação:
    

  -  Evitar custos desnecessários: Quando não precisamos mais da infraestrutura que criamos, devemos destruí-la para evitar custos desnecessários de infraestrutura em execução na nuvem.

  -  Manter o ambiente limpo: Destruir a infraestrutura garante que o ambiente de nuvem seja mantido limpo e organizado, facilitando a manutenção e a atualização futura do ambiente.

  -  Identificar problemas de configuração: Destruir a infraestrutura é uma boa maneira de testar se as configurações do Terraform estão funcionando corretamente. Se a infraestrutura for criada e destruída com sucesso, isso significa que as configurações do Terraform foram escritas corretamente.

  -  Flexibilidade: A destruição da infraestrutura com o terraform destroy dá a flexibilidade de recriar a infraestrutura facilmente, se necessário, com as mesmas configurações.

    
Dito isso, o último comando será aplicado para destruir a infraestrutura.Nesse contexto, no seu terminal destrua a aplicação com o comando a seguir:
    
~~~
terraform destroy
~~~

Após destruir a infraestrutura, você verá a saída a seguir:

![image](https://github.com/gabri190/AWS-lambda/assets/72319195/b3b2c3e9-dbd6-4eda-8b14-5d6ec5857156)   
  
 Observações Finais :

-  Os comandos terraform apply e terraform destroy podem demorar mais do que o normal pelos serviços que estão subindo na AWS, por isso, principalmente, no destroy pode ser necessário rodar o comando mais de uma vez!
  
  

Conclusão
---------------  
Assim, finalizamos nosso projeto que tinha como intuito o cadastro de usuários em bancos de dados (amazon RDS) e tabelas (DynamoDb), no entanto, note que o ponto central desse projeto diz respeito a função lambda que faz toda a integração entre o sistema de filas (SQS) que realiza o envio da mensagem e os sistemas de armazenamento de dados (RDS e DynamoDB). Por isso, apesar de ser apenas um projeto menor, vê-se a importância da lambda function e de todas as integrações feitas para o sistema de armazenamento de valores (dados de usuários) que pode , por exemplo, servir de backend para um site ou outros usos a depender da iteração para a melhora do projeto. 


Referências
---------------
  
https://www.youtube.com/watch?v=3E1IcVIaI0A&t=756s

https://www.youtube.com/watch?v=etru_8t7Dyk&t=2226s

https://docs.aws.amazon.com/pt_br/lambda/latest/dg/services-rds-tutorial.html

https://docs.aws.amazon.com/pt_br/lambda/latest/dg/with-ddb.html  

https://registry.terraform.io/providers/hashicorp/aws/latest/docs
