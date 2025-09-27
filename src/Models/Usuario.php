<?php

namespace App\Models;

use App\Core\Database;
use PDO;
use DateTime;

class Usuario
{

    //Propriedades do usuário
    public ?int $id_usuario;
    public string $nome;
    public string $email;
    public string $senha;
    public ?DateTime $data_cadastro = null;

    /**
     * Salva um novo usuário no banco de dados.
     * A senha é criptografada antes de ser salva.
     *
     * @return bool True se salvou com sucesso, false caso contrário.
     */
    public function salvar(): bool
    {
        $pdo = Database::getInstance();

        $senhaHash = password_hash($this->senha, PASSWORD_BCRYPT);
        $stmt = $pdo->prepare("INSERT INTO usuarios (nome, email, senha, data_cadastro) VALUES (:nome, :email, :senha, NOW())");
        return $stmt->execute([
            ':nome' => $this->nome,
            ':email' => $this->email,
            ':senha' => $senhaHash
        ]);
    }

    /**
     * Busca um usuário pelo email.
     * @param string $email O email do usuário a ser buscado.
     * @return Usuario|null mixed O usuário encontrado (como array) ou false se não encontrar.
     */

    public static function buscarPorEmail(string $email) {
        $pdo = Database::getInstance();
        $stmt = $pdo->prepare("SELECT id_usuario, nome, email, senha, data_cadastro FROM usuarios WHERE email = :email");
        $stmt->execute([':email' => $email]);
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }


    /**
     * Busca todos os usuários cadastrados no banco de dados.
     *
     * @return array Uma lista de todos os usuários.
     */
    public static function buscarTodos(): array
    {
        // Verifique se esta linha está exatamente assim, com 'getInstance'
        $pdo = Database::getInstance();

        $stmt = $pdo->query("SELECT id_usuario, nome, email, data_cadastro FROM usuarios");
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }
}
