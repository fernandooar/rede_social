document.addEventListener('DOMContentLoaded', () => {
    
    const loginForm = document.getElementById('login-form');
    const registerForm = document.getElementById('register-form');
    const loginToggle = document.getElementById('login-toggle');
    const registerToggle = document.getElementById('register-toggle');
    const feedbackMessage = document.getElementById('feedback-message');

    const toggleForms = (showLogin) => {
        if (showLogin) {
            loginForm.classList.add('active');
            registerForm.classList.remove('active');
            loginToggle.classList.add('active');
            registerToggle.classList.remove('active');
        } else {
            loginForm.classList.remove('active');
            registerForm.classList.add('active');
            loginToggle.classList.remove('active');
            registerToggle.classList.add('active');
        }
        feedbackMessage.style.display = 'none';
    };

    loginToggle.addEventListener('click', () => toggleForms(true));
    registerToggle.addEventListener('click', () => toggleForms(false));

    const showFeedback = (message, isError) => {
        feedbackMessage.textContent = message;
        feedbackMessage.className = 'feedback';
        feedbackMessage.classList.add(isError ? 'error' : 'success');
    };

    loginForm.addEventListener('submit', async (event) => {
    event.preventDefault();

    const formData = new FormData(loginForm);
    const data = Object.fromEntries(formData.entries());

    try {
        const response = await fetch('/api/login', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(data),
        });

        const result = await response.json();

        if (response.ok) {
            // --- ALTERAÇÃO AQUI ---
            // 'result' agora contém os dados do usuário (id, nome, email).

            // Salvamos o objeto do usuário no sessionStorage.
            // JSON.stringify é necessário porque o storage só guarda texto.
            sessionStorage.setItem('usuarioLogado', JSON.stringify(result));

            // Redireciona para o feed.
            window.location.href = 'feed.html';

        } else {
            showFeedback(result.erro, true);
        }
    } catch (error) {
        showFeedback('Erro de conexão. Tente novamente.', true);
    }
});

    registerForm.addEventListener('submit', async (event) => { // <-- ASYNC AQUI
        event.preventDefault();

        const formData = new FormData(registerForm);
        const data = Object.fromEntries(formData.entries());

        try {
            const response = await fetch('/api/usuarios', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(data),
            });
            const result = await response.json();
            if (response.ok) {
                showFeedback(result.mensagem, false);
                setTimeout(() => toggleForms(true), 2000);
            } else {
                showFeedback(result.erro, true);
            }
        } catch (error) {
            showFeedback('Erro de conexão. Tente novamente.', true);
        }
    });
});