<?php

namespace App\Core;

use PDO;
use PDOException;

/**
 * Classe de conexão com o banco de dados usando o padrão Singleton.
 * Garante que apenas uma instância da conexão PDO seja criada.
 */
class Database
{
    /** @var PDO|null A única instância da conexão PDO. */
    private static ?PDO $instance = null;

    /**
     * O construtor é privado para prevenir a criação de novas instâncias
     * com o operador 'new'.
     */
    private function __construct() {}

    /**
     * O método clone é privado para prevenir a clonagem da instância.
     */
    private function __clone() {}

    /**
     * Retorna a instância única da conexão PDO.
     * Se a instância ainda não existir, ela é criada.
     *
     * @return PDO A instância do PDO.
     */
    public static function getInstance(): PDO
    {
        if (self::$instance === null) {
            // Credenciais do banco de dados (as mesmas do docker-compose.yml)
            $host = 'db';
            $dbname = 'rede_social';
            $user = 'user';
            $pass = 'password';
            $dsn = "mysql:host=$host;dbname=$dbname;charset=utf8mb4";

            try {
                self::$instance = new PDO($dsn, $user, $pass, [
                    PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION, // Lança exceções em caso de erro
                    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC, // Retorna resultados como arrays associativos
                    PDO::ATTR_EMULATE_PREPARES => false, // Usa prepared statements nativos
                ]);
            } catch (PDOException $e) {
                // Em um ambiente de produção, você deveria logar este erro, não exibi-lo.
                die("Erro na conexão com o banco de dados: " . $e->getMessage());
            }
        }

        return self::$instance;
    }
}