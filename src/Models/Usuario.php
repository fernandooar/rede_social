<?php

namespace App\Models;

use App\Core\Database;
use PDO;

class Usuario
{

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
