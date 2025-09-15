# Projeto Rede Social em PHP com Docker

Este é o repositório de uma pequena rede social desenvolvida com PHP Orientado a Objetos, seguindo o padrão MVC. O ambiente de desenvolvimento é totalmente containerizado com Docker, garantindo um setup rápido e consistente em qualquer máquina.

## Tecnologias Utilizadas

* **Backend:** PHP 8.2
* **Servidor Web:** Nginx
* **Banco de Dados:** MySQL 8.0
* **Gerenciador de Dependências:** Composer
* **Ambiente:** Docker e Docker Compose

## Pré-requisitos

Antes de começar, garanta que você tenha as seguintes ferramentas instaladas em sua máquina:

* [Git](https://git-scm.com/)
* [Docker](https://www.docker.com/products/docker-desktop/)
* [Docker Compose](https://docs.docker.com/compose/) (geralmente já vem com o Docker Desktop)

## Como Executar o Projeto

Siga os passos abaixo para configurar e executar o ambiente de desenvolvimento.

**1. Clone o repositório**

```bash
git clone <URL_DO_SEU_REPOSITORIO_GIT>
```

**2. Navegue até a pasta do projeto**

```bash
cd <NOME_DA_PASTA_DO_PROJETO>
```

**3. Construa as imagens e inicie os contêineres**

Execute o comando abaixo. Ele irá ler o `Dockerfile` para construir a imagem customizada do PHP e depois iniciar todos os serviços definidos no `docker-compose.yml`.

```bash
# O comando constrói as imagens (se ainda não existirem)
# e inicia os serviços em modo "detached" (segundo plano).
docker-compose up -d --build
```

Ao final do processo, seu ambiente com Nginx, PHP e MySQL estará no ar.

## Verificação

Para garantir que tudo subiu corretamente:

**1. Verifique os contêineres**

Execute o comando `docker-compose ps` para listar os contêineres ativos. Você deverá ver uma saída similar a esta, com os três serviços (`db`, `php`, `nginx`) com o status `Up` ou `running`.

```bash
      Name                     Command                  State           Ports
------------------------------------------------------------------------------------------
social_db           docker-entrypoint.sh mysqld      Up (healthy)   0.0.0.0:3306->3306/tcp
social_nginx        /docker-entrypoint.sh ngi ...    Up             0.0.0.0:8080->80/tcp
social_php          docker-php-entrypoint php-fpm    Up             9000/fpm
```

**2. Acesse no navegador**

Abra seu navegador e acesse **`http://localhost:8080`**.

Você deverá ver a página de teste que configuramos (ex: `phpinfo()` ou a mensagem de conexão com o banco de dados).

## Estrutura de Pastas

* `minha-rede-social/`
    * `├── docker-compose.yml`: Arquivo principal que orquestra todos os serviços Docker.
    * `├── Dockerfile`: Receita para construir a imagem customizada do PHP com as extensões necessárias.
    * `├── nginx/`: Contém os arquivos de configuração do servidor web Nginx.
    * `└── src/`: Contém todo o código-fonte da aplicação PHP.
        * `├── public/`: Raiz pública do projeto. É o único diretório acessível pelo navegador.
        * `├── composer.json`: Define as dependências e o autoload do projeto PHP.
        * `└── vendor/`: Pasta criada pelo Composer com as dependências instaladas.# rede_social
