-- Seleciona o banco de dados
USE rede_social;

-- Tabela usuarios: Armazena informações dos usuários da rede social
CREATE TABLE usuarios (
    id_usuario INT(11) AUTO_INCREMENT PRIMARY KEY, -- ID único do usuário
    nome VARCHAR(100) NOT NULL, -- Nome do usuário
    email VARCHAR(100) UNIQUE NOT NULL, -- Email único do usuário
    senha VARCHAR(255) NOT NULL, -- Senha do usuário (armazenada como hash)
    data_cadastro DATETIME NOT NULL, -- Data e hora do cadastro do usuário
    INDEX (email) -- Índice no campo email para consultas rápidas
);

-- Tabela amizades: Armazena as relações de amizade entre usuários
CREATE TABLE amizades (
    id_amizade INT(11) AUTO_INCREMENT PRIMARY KEY, -- ID único da amizade
    id_usuario1 INT(11) NOT NULL, -- ID do primeiro usuário na amizade
    id_usuario2 INT(11) NOT NULL, -- ID do segundo usuário na amizade
    status ENUM('pendente', 'aceita', 'recusada') NOT NULL, -- Status da amizade
    data_interacao DATETIME NOT NULL, -- Data e hora da última interação na amizade
    FOREIGN KEY (id_usuario1) REFERENCES usuarios(id_usuario), -- Chave estrangeira para o primeiro usuário
    FOREIGN KEY (id_usuario2) REFERENCES usuarios(id_usuario) -- Chave estrangeira para o segundo usuário
);

-- Tabela seguidores: Armazena as relações de seguidores entre usuários
CREATE TABLE seguidores (
    id_seguidor INT(11) AUTO_INCREMENT PRIMARY KEY, -- ID único do registro de seguidor
    id_usuario_seguido INT(11) NOT NULL, -- ID do usuário seguido
    id_usuario_seguidor INT(11) NOT NULL, -- ID do usuário seguidor
    data_seguimento DATETIME NOT NULL, -- Data e hora do seguimento
    FOREIGN KEY (id_usuario_seguido) REFERENCES usuarios(id_usuario), -- Chave estrangeira para o usuário seguido
    FOREIGN KEY (id_usuario_seguidor) REFERENCES usuarios(id_usuario) -- Chave estrangeira para o usuário seguidor
);

-- Tabela posts: Armazena os posts feitos pelos usuários
CREATE TABLE posts (
    id_post INT(11) AUTO_INCREMENT PRIMARY KEY, -- ID único do post
    id_usuario INT(11) NOT NULL, -- ID do usuário que fez o post
    conteudo TEXT NOT NULL, -- Conteúdo do post
    data_publicacao DATETIME NOT NULL, -- Data e hora da publicação
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario) -- Chave estrangeira para o usuário
);

-- Tabela post_imagens: Armazena as imagens associadas a um post
CREATE TABLE post_imagens (
    id_imagem INT(11) AUTO_INCREMENT PRIMARY KEY, -- ID único da imagem
    id_post INT(11) NOT NULL, -- ID do post ao qual a imagem pertence
    caminho_imagem VARCHAR(255) NOT NULL, -- Caminho da imagem no servidor
    descricao_imagem TEXT, -- Descrição opcional da imagem
    data_upload DATETIME NOT NULL, -- Data e hora do upload da imagem
    FOREIGN KEY (id_post) REFERENCES posts(id_post) ON DELETE CASCADE -- Chave estrangeira para o post (exclusão em cascata)
);

-- Tabela curtidas: Armazena as curtidas dos usuários em posts
CREATE TABLE curtidas (
    id_curtida INT(11) AUTO_INCREMENT PRIMARY KEY, -- ID único da curtida
    id_post INT(11) NOT NULL, -- ID do post curtido
    id_usuario INT(11) NOT NULL, -- ID do usuário que curtiu
    data_curtida DATETIME NOT NULL, -- Data e hora da curtida
    FOREIGN KEY (id_post) REFERENCES posts(id_post), -- Chave estrangeira para o post
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario) -- Chave estrangeira para o usuário
);

-- Tabela comentarios: Armazena os comentários feitos pelos usuários em posts
CREATE TABLE comentarios (
    id_comentario INT(11) AUTO_INCREMENT PRIMARY KEY, -- ID único do comentário
    id_post INT(11) NOT NULL, -- ID do post comentado
    id_usuario INT(11) NOT NULL, -- ID do usuário que comentou
    conteudo TEXT NOT NULL, -- Conteúdo do comentário
    data_comentario DATETIME NOT NULL, -- Data e hora do comentário
    FOREIGN KEY (id_post) REFERENCES posts(id_post), -- Chave estrangeira para o post
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario) -- Chave estrangeira para o usuário
);

-- Tabela grupos: Armazena os grupos criados pelos usuários
CREATE TABLE grupos (
    id_grupo INT(11) AUTO_INCREMENT PRIMARY KEY, -- ID único do grupo
    nome VARCHAR(100) NOT NULL, -- Nome do grupo
    descricao TEXT, -- Descrição do grupo
    id_criador INT(11) NOT NULL, -- ID do usuário que criou o grupo
    data_criacao DATETIME NOT NULL, -- Data e hora da criação do grupo
    FOREIGN KEY (id_criador) REFERENCES usuarios(id_usuario) -- Chave estrangeira para o criador do grupo
);

-- Tabela membros_grupo: Armazena os membros de cada grupo
CREATE TABLE membros_grupo (
    id_membro_grupo INT(11) AUTO_INCREMENT PRIMARY KEY, -- ID único do registro de membro
    id_grupo INT(11) NOT NULL, -- ID do grupo
    id_usuario INT(11) NOT NULL, -- ID do usuário membro
    data_entrada DATETIME NOT NULL, -- Data e hora da entrada no grupo
    FOREIGN KEY (id_grupo) REFERENCES grupos(id_grupo), -- Chave estrangeira para o grupo
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario) -- Chave estrangeira para o usuário
);

-- Tabela mensagens_privadas: Armazena as mensagens privadas entre usuários
CREATE TABLE mensagens_privadas (
    id_mensagem INT(11) AUTO_INCREMENT PRIMARY KEY, -- ID único da mensagem
    id_remetente INT(11) NOT NULL, -- ID do usuário remetente
    id_destinatario INT(11) NOT NULL, -- ID do usuário destinatário
    conteudo TEXT NOT NULL, -- Conteúdo da mensagem
    data_envio DATETIME NOT NULL, -- Data e hora do envio
    FOREIGN KEY (id_remetente) REFERENCES usuarios(id_usuario), -- Chave estrangeira para o remetente
    FOREIGN KEY (id_destinatario) REFERENCES usuarios(id_usuario) -- Chave estrangeira para o destinatário
);

-- Tabela notificacoes: Armazena as notificações dos usuários
CREATE TABLE notificacoes (
    id_notificacao INT(11) AUTO_INCREMENT PRIMARY KEY, -- ID único da notificação
    id_usuario INT(11) NOT NULL, -- ID do usuário que recebe a notificação
    tipo ENUM('curtida', 'comentario', 'amizade', 'seguimento', 'mensagem') NOT NULL, -- Tipo de notificação
    id_referencia INT(11) NOT NULL, -- ID de referência (post, comentário, amizade, etc.)
    data_notificacao DATETIME NOT NULL, -- Data e hora da notificação
    lida BOOLEAN DEFAULT FALSE, -- Indica se a notificação foi lida
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario) -- Chave estrangeira para o usuário
);

-- Tabela midia: Armazena as mídias (fotos, vídeos) enviadas pelos usuários
CREATE TABLE midia (
    id_midia INT(11) AUTO_INCREMENT PRIMARY KEY, -- ID único da mídia
    id_usuario INT(11) NOT NULL, -- ID do usuário que enviou a mídia
    tipo ENUM('foto', 'video') NOT NULL, -- Tipo de mídia (foto ou vídeo)
    caminho VARCHAR(255) NOT NULL, -- Caminho da mídia no servidor
    data_upload DATETIME NOT NULL, -- Data e hora do upload
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario) -- Chave estrangeira para o usuário
);

-- Tabela tags: Armazena as tags usadas nos posts
CREATE TABLE tags (
    id_tag INT(11) AUTO_INCREMENT PRIMARY KEY, -- ID único da tag
    nome VARCHAR(100) NOT NULL, -- Nome da tag
    UNIQUE (nome) -- Garante que cada tag seja única
);

-- Tabela post_tags: Armazena a relação entre posts e tags
CREATE TABLE post_tags (
    id_post_tag INT(11) AUTO_INCREMENT PRIMARY KEY, -- ID único do registro de post_tag
    id_post INT(11) NOT NULL, -- ID do post
    id_tag INT(11) NOT NULL, -- ID da tag
    FOREIGN KEY (id_post) REFERENCES posts(id_post), -- Chave estrangeira para o post
    FOREIGN KEY (id_tag) REFERENCES tags(id_tag) -- Chave estrangeira para a tag
);

-- Tabela mencoes: Armazena as menções de usuários em posts ou comentários
CREATE TABLE mencoes (
    id_mencao INT AUTO_INCREMENT PRIMARY KEY, -- ID único da menção
    id_usuario_mencionador INT NOT NULL, -- ID do usuário que mencionou
    id_usuario_mencionado INT NOT NULL, -- ID do usuário mencionado
    id_referencia INT NOT NULL, -- ID de referência (post ou comentário)
    tipo_mencao ENUM('post', 'comentario') NOT NULL, -- Tipo de menção (post ou comentário)
    FOREIGN KEY (id_usuario_mencionador) REFERENCES usuarios(id_usuario), -- Chave estrangeira para o usuário mencionador
    FOREIGN KEY (id_usuario_mencionado) REFERENCES usuarios(id_usuario) -- Chave estrangeira para o usuário mencionado
);

-- Tabela sessoes: Armazena as sessões dos usuários
CREATE TABLE sessoes (
    id_sessao INT AUTO_INCREMENT PRIMARY KEY, -- ID único da sessão
    id_usuario INT NOT NULL, -- ID do usuário
    token VARCHAR(128) UNIQUE NOT NULL, -- Token de sessão único
    data_expiracao DATETIME NOT NULL, -- Data e hora de expiração da sessão
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario) -- Chave estrangeira para o usuário
);


/*
Resumo do Banco de Dados: Rede Social

Este banco de dados foi projetado para suportar as funcionalidades básicas de uma rede social, como cadastro de usuários, posts, comentários, curtidas, amizades, seguidores, grupos, mensagens privadas, notificações e mídias. Ele é estruturado de forma normalizada, com relacionamentos bem definidos entre as tabelas.
Tabelas e Relações:

    usuarios

        Armazena informações dos usuários (nome, email, senha, data de cadastro).

        Relacionada com: amizades, seguidores, posts, curtidas, comentarios, grupos, mensagens_privadas, notificacoes, midia.

    amizades

        Registra as relações de amizade entre usuários, com status (pendente, aceita, recusada).

        Relacionada com: usuarios (dois usuários por amizade).

    seguidores

        Armazena as relações de seguidores entre usuários.

        Relacionada com: usuarios (usuário seguido e seguidor).

    posts

        Armazena os posts feitos pelos usuários.

        Relacionada com: usuarios, post_imagens, curtidas, comentarios, post_tags.

    post_imagens

        Armazena as imagens associadas a um post.

        Relacionada com: posts.

    curtidas

        Registra as curtidas dos usuários em posts.

        Relacionada com: posts e usuarios.

    comentarios

        Armazena os comentários feitos pelos usuários em posts.

        Relacionada com: posts e usuarios.

    grupos

        Armazena os grupos criados pelos usuários.

        Relacionada com: usuarios (criador do grupo) e membros_grupo.

    membros_grupo

        Registra os membros de cada grupo.

        Relacionada com: grupos e usuarios.

    mensagens_privadas

        Armazena as mensagens privadas entre usuários.

        Relacionada com: usuarios (remetente e destinatário).

    notificacoes

        Armazena as notificações dos usuários (curtidas, comentários, amizades, etc.).

        Relacionada com: usuarios.

    midia

        Armazena mídias (fotos, vídeos) enviadas pelos usuários.

        Relacionada com: usuarios.

    tags

        Armazena as tags usadas nos posts.

        Relacionada com: post_tags.

    post_tags

        Relaciona posts com tags.

        Relacionada com: posts e tags.

    mencoes

        Armazena as menções de usuários em posts ou comentários.

        Relacionada com: usuarios (mencionador e mencionado).

    sessoes

        Armazena as sessões ativas dos usuários (tokens de autenticação).

        Relacionada com: usuarios.

Relações Principais:

    Usuários (usuarios) são o centro do sistema, interagindo com quase todas as tabelas.

    Posts (posts) são o principal conteúdo gerado pelos usuários, podendo ter imagens (post_imagens), tags (post_tags), curtidas (curtidas) e comentários (comentarios).

    Amizades (amizades) e Seguidores (seguidores) definem as relações sociais entre usuários.

    Grupos (grupos) e Membros de Grupos (membros_grupo) permitem a criação e participação em comunidades.

    Notificações (notificacoes) informam os usuários sobre interações relevantes.

    Mídias (midia) e Imagens de Posts (post_imagens) armazenam conteúdo multimídia.

    Tags (tags) e Menções (mencoes) ajudam a categorizar e mencionar usuários em conteúdos.

Funcionalidades Principais:

    Cadastro e Autenticação:

        Usuários podem se cadastrar e autenticar (usuarios e sessoes).

    Interações Sociais:

        Amizades (amizades), seguidores (seguidores), curtidas (curtidas) e comentários (comentarios).

    Conteúdo:

        Posts (posts) com suporte a imagens (post_imagens) e tags (post_tags).

    Comunicação:

        Mensagens privadas (mensagens_privadas) e notificações (notificacoes).

    Comunidades:

        Grupos (grupos) e membros (membros_grupo).

    Multimídia:

        Armazenamento de fotos e vídeos (midia).

Conclusão:

Este banco de dados é robusto e escalável, cobrindo as funcionalidades essenciais de uma rede social. Sua estrutura permite fácil expansão para novas funcionalidades, como stories, reações, ou até mesmo integração com APIs externas.

*/