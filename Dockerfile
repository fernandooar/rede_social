# Dockerfile

# Usamos uma imagem oficial do PHP 8.2 com FPM (FastCGI Process Manager)
FROM php:8.2-fpm

# Define o diretório de trabalho padrão para /var/www/html
WORKDIR /var/www/html

# Instala as extensões PHP necessárias para se conectar ao MySQL
RUN docker-php-ext-install pdo_mysql

# --- INÍCIO DA INSTALAÇÃO DO COMPOSER ---

# Baixa o script de instalação oficial do Composer
RUN curl -sS https://getcomposer.org/installer -o composer-setup.php

# Executa o instalador
# E move o executável do composer para o diretório global /usr/local/bin/composer
# Isso torna o comando 'composer' acessível de qualquer lugar dentro do contêiner
RUN php composer-setup.php --install-dir=/usr/local/bin --filename=composer

# Remove o script de instalação (limpeza)
RUN rm composer-setup.php

# --- FIM DA INSTALAÇÃO DO COMPOSER ---