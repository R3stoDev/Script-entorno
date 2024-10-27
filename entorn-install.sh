#!/bin/bash

set -e

# Función para verificar el estado del último comando
check_status() {
    if [ $? -ne 0 ]; then
        echo "ADVERTENCIA: Fallo en la instalación o ejecución de $1"
        exit 1
    fi
}

# Actualiza los paquetes del sistema
echo "Actualizando los paquetes del sistema..."
sudo apt update && sudo apt upgrade -y
check_status "actualización del sistema"

# Instalar fish
if ! command -v fish > /dev/null 2>&1; then
    echo "Instalando fish..."
    sudo apt install fish -y
    check_status "Fish"
fi

# Crear carpeta de dev
if [ ! -d "$HOME/dev" ]; then
    echo "Creando directorio 'dev'..."
    mkdir "$HOME/dev"
    check_status "creación de la carpeta dev"
fi

cd "$HOME/dev"

# Instalar MySQL
if ! command -v mysql > /dev/null 2>&1; then
    echo "Instalando mysql-server..."
    sudo apt install mysql-server -y
    check_status "MySQL"
fi

# Instalar PHP
if ! command -v php > /dev/null 2>&1; then
    echo "Instalando php..."
    sudo apt install php php-mysql -y
    check_status "PHP"
fi

# Verificar PHP
php -v
check_status "verificación de PHP"

# Instalar curl
if ! command -v curl > /dev/null 2>&1; then
    echo "Instalando curl..."
    sudo apt install curl -y
    check_status "curl"
fi

# Instalar Node.js y NVM
if ! command -v node > /dev/null 2>&1; then
    echo "Instalando Node.js..."
    if [ -z "$NVM_DIR" ]; then
        echo "Instalando NVM..."
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash
        check_status "NVM"
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    fi
    nvm install 20
    check_status "Node.js"
fi

# Verificar Node.js y npm
node -v
check_status "Node.js"
npm -v
check_status "npm"

# Instalar Angular CLI
if ! command -v ng > /dev/null 2>&1; then
    echo "Instalando Angular CLI..."
    npm install -g @angular/cli
    check_status "Angular CLI"
fi

# Instalar Composer
if ! command -v composer > /dev/null 2>&1; then
    echo "Instalando Composer..."
    sudo apt install composer -y
    check_status "Composer"
    
    # Añadir Composer al PATH en ~/.bashrc
    if ! grep -q 'export PATH="$HOME/.composer/vendor/bin:$PATH"' ~/.bashrc; then
        echo 'export PATH="$HOME/.composer/vendor/bin:$PATH"' >> ~/.bashrc
    fi

    if ! grep -q 'export PATH="$HOME/.config/composer/vendor/bin:$PATH"' ~/.bashrc; then
        echo 'export PATH="$HOME/.config/composer/vendor/bin:$PATH"' >> ~/.bashrc
    fi

    echo "Recargando ~/.bashrc para aplicar cambios"
    source ~/.bashrc
    check_status "actualización del PATH para Composer"
fi

# Instalar extensiones de PHP
echo "Instalando extensiones de PHP..."
sudo apt install php-mbstring php-xml php-bcmath php-zip -y
check_status "extensiones de PHP"

# Instalar Laravel
if ! command -v laravel > /dev/null 2>&1; then
    echo "Instalando Laravel..."
    composer global require laravel/installer
    check_status "Laravel"
fi

echo "El script se ha completado"
