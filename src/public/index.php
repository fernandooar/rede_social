<?php

// Exibe todos os erros (útil para o ambiente de desenvolvimento)
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

// Carrega o autoloader do Composer
require __DIR__ . '/../vendor/autoload.php';

// Importa as classes que vamos usar
use App\Core\Database;
use App\Controllers\UsuarioController;
use Bramus\Router\Router;

// Cria a instância do roteador
$router = new Router();

// Define um namespace para os Controllers (opcional, mas boa prática)
 //$router->setNamespace('\App\Controllers');

// --- DEFINIÇÃO DAS ROTAS ---

// Rota de teste para verificar a conexão com o banco de dados
$router->get('/ping', function() {
    try {
        // Tenta obter a instância do banco de dados
        $pdo = Database::getInstance();
        // Se não houver exceção, a conexão foi bem-sucedida
        echo "Pong! Conexão com o banco de dados bem-sucedida.";
    } catch (\Exception $e) {
        // Captura qualquer erro e exibe a mensagem
        http_response_code(500); // Internal Server Error
        echo "Erro ao conectar com o banco de dados: " . $e->getMessage();
    }
});

// Define um "agrupamento" de rotas para a API
$router->mount('/api', function() use ($router) {

    // Rota: GET /api/usuarios
    // Mapeia para o método 'index' da classe 'UsuarioController'
    $router->get('/usuarios', UsuarioController::class . '@index');

});
// Rota para a raiz da aplicação
$router->get('/', function() {
    echo 'Bem-vindo à API da Rede Social!';
});


// --- FIM DAS ROTAS ---

// Inicia o roteador
$router->run();