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
}
