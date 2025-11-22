document.addEventListener('DOMContentLoaded', () => {
    
    const nomeUsuarioEl = document.getElementById('nome-usuario');
    const handleUsuarioEl = document.getElementById('handle-usuario');
    const logoutBtn = document.getElementById('logout-btn');
    const feedContainer = document.getElementById('feed-content');
    const postForm = document.getElementById('post-form');

    // --- FUNÇÃO DE DECODIFICAÇÃO SEGURA ---
    function parseJwt(token) {
        try {
            if (!token) return null;
            const base64Url = token.split('.')[1];
            const base64 = base64Url.replace(/-/g, '+').replace(/_/g, '/');
            const jsonPayload = decodeURIComponent(window.atob(base64).split('').map(function(c) {
                return '%' + ('00' + c.charCodeAt(0).toString(16)).slice(-2);
            }).join(''));
            return JSON.parse(jsonPayload);
        } catch (e) {
            console.error("Erro ao decodificar token:", e);
            return null;
        }
    }

    // --- 1. IDENTIFICAÇÃO DO USUÁRIO ---
    const token = localStorage.getItem('jwt_token');
    let usuario = null;

    if (!token) {
        window.location.href = 'index.html';
        return;
    }

    // Tenta decodificar o token diretamente para garantir dados frescos
    const decoded = parseJwt(token);
    
    if (decoded && decoded.data) {
        usuario = decoded.data;
        console.log("Usuário identificado:", usuario); // Para debug no console
    } else {
        // Tenta pegar do sessionStorage como backup
        try {
            const sessionData = sessionStorage.getItem('usuarioLogado');
            if (sessionData) usuario = JSON.parse(sessionData);
        } catch(e) {}
    }

    // --- 2. ATUALIZA A TELA (HEADER) ---
    if (usuario && usuario.nome) {
        nomeUsuarioEl.textContent = usuario.nome;
        
        // Cria um @handle. Ex: "Maria Silva" vira "@maria"
        const primeiroNome = usuario.nome.split(' ')[0].toLowerCase();
        handleUsuarioEl.textContent = '@' + primeiroNome;
    } else {
        nomeUsuarioEl.textContent = "Usuário Nexus";
        console.warn("Nome do usuário não encontrado no Token.");
    }

    // --- 3. CARREGAR POSTS ---
    const carregarPosts = async () => {
        try {
            const response = await fetch('/api/posts');
            const posts = await response.json();
            
            feedContainer.innerHTML = '';

            if (!response.ok || posts.length === 0) {
                feedContainer.innerHTML = '<div style="text-align:center; padding:20px; color:#777">Nenhuma publicação ainda. Seja o primeiro!</div>';
                return;
            }

            posts.forEach(post => {
                const postDiv = document.createElement('div');
                postDiv.className = 'post-card';
                
                // Handle do autor do post
                const handleAutor = '@' + (post.nome_autor ? post.nome_autor.split(' ')[0].toLowerCase() : 'anonimo');

                postDiv.innerHTML = `
                    <div class="avatar-placeholder"></div>
                    <div class="post-content-wrapper">
                        <div class="post-header">
                            <span class="post-author">${post.nome_autor || 'Anônimo'}</span>
                            <span class="post-handle">${handleAutor}</span>
                            <span class="post-date">· ${new Date(post.data_publicacao).toLocaleDateString('pt-BR')}</span>
                        </div>
                        <div class="post-body">
                            ${post.conteudo}
                        </div>
                        <div class="post-actions">
                            <i class="fa-regular fa-comment"></i>
                            <i class="fa-solid fa-retweet"></i>
                            <i class="fa-regular fa-heart"></i>
                            <i class="fa-solid fa-share-nodes"></i>
                        </div>
                    </div>
                `;
                feedContainer.appendChild(postDiv);
            });
        } catch (error) {
            console.error("Erro ao carregar posts:", error);
        }
    };

    // --- 4. CRIAR POST ---
    postForm.addEventListener('submit', async (event) => {
        event.preventDefault();
        const conteudo = event.target.conteudo.value;
        const btn = event.target.querySelector('button');
        
        btn.textContent = "...";
        btn.disabled = true;

        try {
            const response = await fetch('/api/posts', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': `Bearer ${token}`
                },
                body: JSON.stringify({ conteudo: conteudo })
            });

            if (response.ok) {
                event.target.conteudo.value = '';
                carregarPosts();
            } else {
                alert('Erro ao publicar.');
            }
        } catch (error) {
            console.error(error);
        } finally {
            btn.textContent = "Publicar";
            btn.disabled = false;
        }
    });

    // Logout
    logoutBtn.addEventListener('click', () => {
        sessionStorage.clear();
        localStorage.clear();
        window.location.href = 'index.html';
    });

    carregarPosts();
});