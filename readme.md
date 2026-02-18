# Hadoop Cluster com Docker 

Este projeto implementa um cluster Apache Hadoop 3.3.6 funcional utilizando Docker Compose.  
A arquitetura foi projetada para separar claramente as camadas de armazenamento (HDFS) e gerenciamento de recursos (YARN), permitindo estudo prático de sistemas distribuídos e futura integração com ferramentas de processamento e orquestração de dados.

Este ambiente faz parte de um laboratório de engenharia de dados voltado ao estudo de pipelines distribuídos, armazenamento escalável e processamento paralelo.

---

## Arquitetura do Cluster

O cluster é composto por duas camadas principais.

### HDFS — Camada de Armazenamento

- **NameNode**  
  Responsável pelos metadados do sistema de arquivos distribuído.

- **DataNode 1 e DataNode 2**  
  Responsáveis pelo armazenamento real dos blocos de dados.  
  Fator de replicação configurado: 2.

### YARN — Camada de Processamento

- **ResourceManager**  
  Gerencia recursos computacionais e coordena a execução de jobs.

- **NodeManager 1 e NodeManager 2**  
  Executam tarefas distribuídas em cada nó do cluster.

---

## Estrutura de Arquivos

Certifique-se de que a estrutura do projeto esteja organizada da seguinte forma:

.
├── docker-compose.yml
└── config/
├── capacity-scheduler.xml
├── core-site.xml
├── hdfs-site.xml
├── mapred-site.xml
├── yarn-site.xml
└── workers


---

## Como Executar

### 1. Pré-requisitos

- Docker instalado
- Docker Compose instalado
- Mínimo de 4GB de RAM dedicados ao Docker  
- Recomendado: 8GB para estabilidade do cluster

---

### 2. Iniciar o Cluster

No diretório raiz do projeto, execute:

docker-compose up -d


Na primeira execução, o NameNode será formatado automaticamente.

---

### 3. Verificar o Status dos Containers

docker ps


Aguarde alguns instantes até que todos os serviços estejam em execução.

---

## Interfaces Web

O cluster fornece interfaces gráficas para monitoramento operacional.

| Serviço | URL | Descrição |
|---|---|---|
| HDFS NameNode | http://localhost:9870 | Status do sistema de arquivos |
| YARN ResourceManager | http://localhost:8383 | Monitoramento de jobs e recursos |

---

## Operações Básicas

### Acessar o container do NameNode

docker exec -it namenode bash


---

### Criar diretório no HDFS

hdfs dfs -mkdir -p /user/admin/input


---

### Listar conteúdo do HDFS

hdfs dfs -ls /


---

### Executar Job de Exemplo (MapReduce)

Dentro do container do NameNode:

hadoop jar /opt/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-3.3.6.jar pi 2 5


Este comando executa um job de exemplo para validação do processamento distribuído.

---

## Configurações Importantes

### Formatação Segura do NameNode
O ambiente inclui verificação automática para evitar reformatar o NameNode em reinicializações, preservando dados persistidos.

### Rede Interna Dedicada
Os containers se comunicam através da rede bridge:

hadoop-net


A comunicação ocorre via hostname entre os serviços.

### Persistência de Dados
Volumes Docker garantem que os dados permaneçam após reinicializações:

- namenode_data
- datanode_data

---

## Objetivo do Projeto

Este cluster foi projetado como ambiente de laboratório para:

- Estudo de arquitetura distribuída
- Compreensão do funcionamento interno do HDFS
- Execução de processamento distribuído com YARN
- Base para integração futura com ferramentas de engenharia de dados

Este ambiente servirá como fundação para pipelines mais avançadas e simulação de cenários reais de processamento de dados em larga escala.

---

## Próxima Fase

### Fase 2 — Integração com Hive

A próxima etapa do projeto incluirá:

- Integração com Apache Hive
- Criação de Data Warehouse sobre HDFS
- Execução de consultas SQL distribuídas
- Base para modelagem analítica em ambiente Hadoop

