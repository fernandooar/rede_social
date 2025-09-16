<?php

namespace App\Controllers;

use App\Models\Usuario;

/**
 * Controller para gerenciar as operações relacionadas a usuários.
 */
class UsuarioController
{
    /**
     * Lista todos os usuários.
     * Busca os dados através do Model e os retorna como JSON.
     */
    public function index(): void
    {
        // Pede ao Model para buscar todos os usuários
        $usuarios = \App\Models\Usuario::buscarTodos();
        // Define o cabeçalho da resposta como JSON
        header('Content-Type: application/json');
        // Converte o array de usuários para o formato JSON e o exibe
        echo json_encode($usuarios);
    }

    public function cadastrar(): void
    {
        //Pega os dados do corpo da requisição (enviados como JSON)
        $dados = json_decode(file_get_contents('php://input'));

        //Valida os dados recebidos
        if (!isset($dados->nome) || !isset($dados->email) || !isset($dados->senha)) {
            http_response_code(400); //Página não encontrada
            echo json_encode(['erro' => 'Dados incompletos']);
            return;
        }

        //Verifica se o email já está cadastrado
        if (Usuario::buscarPorEmail($dados->email)) {
            http_response_code(409); // Conflito
            echo json_encode(['erro' => 'Email já cadastrado.']);
            return;
        }

        //Cria um novo objeto Usuario e preenche com os dados recebidos
        $usuario = new Usuario();
        $usuario->nome = $dados->nome;
        $usuario->email = $dados->email;
        $usuario->senha = $dados->senha;

        // Tenta salvar o novo usuário  no banco de dados
        if ($usuario->salvar()) {
            http_response_code(201); // Usuário criado com sucesso
            echo json_encode(['mensagem' => 'Usuário cadastrado com sucesso!']);
        } else {
            http_response_code(500); // Erro interno do servidor
            echo json_encode(['erro' => 'Erro ao cadastrar usuário.']);
        }
    }


    public function login(): void
    {
        $dados = json_decode(file_get_contents('php://input'));

        if (!isset($dados->email) || !isset($dados->senha)) {
            http_response_code(400);
            echo json_encode(['erro' => 'E-mail e senha são obrigatórios']);
            return;
        }

        $usuario = Usuario::buscarPorEmail($dados->email);

        // Se o usuário não foi encontrado OU a senha não corresponder...
        // password_verify() compara a senha enviada com o hash salvo no banco.
        if (!$usuario || !password_verify($dados->senha, $usuario['senha'])) {
            http_response_code(401); // Unauthorized
            echo json_encode(['erro' => 'E-mail ou senha inválidos']);
            return;
        }

        // Remove o hash da senha da resposta por segurança.
    unset($usuario['senha']);

    http_response_code(200);
    // Retorna os dados do usuário como JSON.
    echo json_encode($usuario);
    }
}
