document.addEventListener('DOMContentLoaded', () => {
    // Pega a string JSON do sessionStorage
    const usuarioString = sessionStorage.getItem('usuarioLogado');

    // Se não houver dados, o usuário não está logado. Redireciona de volta.
    if (!usuarioString) {
        window.location.href = 'index.html';
        return;
    }

    // Converte a string de volta para um objeto
    const usuario = JSON.parse(usuarioString);

    // Encontra os elementos na página para exibir os dados
    const nomeUsuarioEl = document.getElementById('nome-usuario');
    const emailUsuarioEl = document.getElementById('email-usuario');
    const logoutBtn = document.getElementById('logout-btn');

    // Preenche os elementos com os dados do usuário
    nomeUsuarioEl.textContent = usuario.nome;
    emailUsuarioEl.textContent = usuario.email;

    // Adiciona a funcionalidade de logout
    logoutBtn.addEventListener('click', () => {
        // Remove os dados do usuário do sessionStorage
        sessionStorage.removeItem('usuarioLogado');
        // Redireciona para a página de login
        window.location.href = 'index.html';
    });
});