-- Insere usuários na tabela 'usuarios'
-- NOTA: Por enquanto, vamos usar senhas de texto simples. No futuro,
-- substituiremos isso por senhas criptografadas (hashes).

INSERT INTO usuarios (nome, email, senha, data_cadastro) VALUES
('Ana Silva', 'ana.silva@email.com', 'senha_hash_123', NOW()),
('Bruno Costa', 'bruno.costa@email.com', 'senha_hash_456', NOW()),
('Carla Dias', 'carla.dias@email.com', 'senha_hash_789', NOW());