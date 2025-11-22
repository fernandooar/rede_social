document.addEventListener('DOMContentLoaded', () => {
    
    const container = document.getElementById('container');
    const registerBtn = document.getElementById('register');
    const loginBtn = document.getElementById('login');
    
    const loginForm = document.getElementById('login-form');
    const registerForm = document.getElementById('register-form');
    
    const msgLogin = document.getElementById('msg-login');
    const msgRegister = document.getElementById('msg-register');

    // --- ANIMAÇÃO DO SLIDER ---
    if(registerBtn && loginBtn && container) {
        registerBtn.addEventListener('click', () => {
            container.classList.add("active");
            limparMensagens();
        });

        loginBtn.addEventListener('click', () => {
            container.classList.remove("active");
            limparMensagens();
        });
    }

    function limparMensagens() {
        if(msgLogin) { msgLogin.textContent = ''; msgLogin.className = 'message'; }
        if(msgRegister) { msgRegister.textContent = ''; msgRegister.className = 'message'; }
    }

    function mostrarMensagem(elemento, texto, tipo) {
        if(elemento) {
            elemento.textContent = texto;
            elemento.className = 'message ' + tipo;
        }
    }

    // --- FUNÇÃO ROBUSTA PARA LER O TOKEN ---
    function parseJwt(token) {
        try {
            const base64Url = token.split('.')[1];
            const base64 = base64Url.replace(/-/g, '+').replace(/_/g, '/');
            const jsonPayload = decodeURIComponent(window.atob(base64).split('').map(function(c) {
                return '%' + ('00' + c.charCodeAt(0).toString(16)).slice(-2);
            }).join(''));
            return JSON.parse(jsonPayload);
        } catch (e) {
            console.error("Erro ao decodificar:", e);
            return null;
        }
    }

    // --- LOGIN ---
    if(loginForm) {
        loginForm.addEventListener('submit', async (event) => {
            event.preventDefault();
            const formData = new FormData(loginForm);
            const data = Object.fromEntries(formData.entries());

            mostrarMensagem(msgLogin, 'Autenticando...', '');

            try {
                const response = await fetch('/api/login', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify(data),
                });

                const result = await response.json();

                if (response.ok) {
                    mostrarMensagem(msgLogin, 'Login OK! Redirecionando...', 'success');
                    
                    localStorage.setItem('jwt_token', result.token);

                    // Decodifica e salva os dados do usuário
                    const decoded = parseJwt(result.token);
                    
                    if (decoded && decoded.data) {
                        // Salva exatamente o objeto { id_usuario: 1, nome: "Fernando" }
                        sessionStorage.setItem('usuarioLogado', JSON.stringify(decoded.data));
                    } else {
                        // Fallback de segurança
                        sessionStorage.setItem('usuarioLogado', JSON.stringify({ nome: 'Usuário' }));
                    }

                    setTimeout(() => { window.location.href = 'feed.html'; }, 1000);
                } else {
                    mostrarMensagem(msgLogin, result.erro || 'Dados incorretos.', 'error');
                }
            } catch (error) {
                mostrarMensagem(msgLogin, 'Erro de conexão.', 'error');
            }
        });
    }

    // --- CADASTRO ---
    if(registerForm) {
        registerForm.addEventListener('submit', async (event) => {
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
                    mostrarMensagem(msgRegister, 'Sucesso! Faça login.', 'success');
                    registerForm.reset();
                    setTimeout(() => { container.classList.remove("active"); }, 1500);
                } else {
                    mostrarMensagem(msgRegister, result.erro || 'Erro ao cadastrar.', 'error');
                }
            } catch (error) {
                mostrarMensagem(msgRegister, 'Erro de conexão.', 'error');
            }
        });
    }
});