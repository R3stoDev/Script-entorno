#!/bin/bash

# Moverse al directorio home
cd

# Función para verificar el estado del último comando y mostrar advertencia si falla
check_status() {
    if [ $? -ne 0 ]; then
        echo "ADVERTENCIA: Fallo en la instalación o ejecución de $1"
    fi
}

# Actualiza los paquetes del sistema
echo "Actualizando los paquetes del sistema..."
sudo apt update && sudo apt upgrade -y
check_status "actualización del sistema"

# Instalar fish si no está instalado
if command -v fish > /dev/null 2>&1; then
    echo "Fish ya está instalado"
else
    echo "Instalando fish"
    sudo apt install fish -y
    check_status "Fish"
fi

# Creación de carpeta de dev si no existe
if [ ! -d "dev" ]; then
    echo "Creando directorio 'dev'"
    mkdir dev
    check_status "creación de la carpeta dev"
fi

echo "Moviéndose al directorio 'dev'"
cd dev

# Instalar MySQL si no está instalado
if command -v mysql > /dev/null 2>&1; then
    echo "MySQL ya está instalado"
else
    echo "Instalando mysql-server"
    sudo apt install mysql-server -y
    check_status "MySQL"
fi

# Instalar PHP si no está instalado
if command -v php > /dev/null 2>&1; then
    echo "PHP ya está instalado"
else
    echo "Instalando php"
    sudo apt install php -y
    check_status "PHP"
    echo "Instalando php-mysql"
    sudo apt install php-mysql -y
    check_status "php-mysql"
fi

echo "Verificando la instalación de PHP"
php -v
check_status "verificación de PHP"

echo "Verificando la instalación de MySQL"
mysql --version
check_status "verificación de MySQL"

# Instalar Node.js y npm si no están instalados
if command -v node > /dev/null 2>&1; then
    echo "Node.js ya está instalado"
else
    echo "Instalando Node.js..."

    # Instalar NVM (Node Version Manager) si no está instalado
    if [ -z "$NVM_DIR" ]; then
        echo "Instalando NVM..."
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash
        check_status "NVM"

        # Recargar el entorno para usar NVM en el mismo script
        export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    fi

    # Instalar Node.js versión 20
    echo "Instalando Node.js v20"
    nvm install 20
    check_status "Node.js v20"
fi

echo "Verificando la instalación de Node.js y npm..."
node -v
check_status "Node.js"
npm -v
check_status "npm"

# Instalar Angular CLI si no está instalado
if command -v ng > /dev/null 2>&1; then
    echo "Angular CLI ya está instalado"
else
    echo "Instalando Angular CLI..."
    npm install -g @angular/cli
    check_status "Angular CLI"
fi

echo "Verificando la instalación de Angular CLI"
ng version
check_status "verificación de Angular CLI"

# Instalar Composer si no está instalado
if command -v composer > /dev/null 2>&1; then
    echo "Composer ya está instalado"
else
    echo "Instalando Composer..."
    sudo apt install composer -y
    check_status "Composer"

    # Añadir Composer al PATH en ~/.bashrc
    if ! grep -q 'export PATH="$HOME/.composer/vendor/bin:$PATH"' ~/.bashrc; then
        echo 'export PATH="$HOME/.composer/vendor/bin:$PATH"' >> ~/.bashrc
        echo "Recargando ~/.bashrc para aplicar cambios"
        source ~/.bashrc
        check_status "actualización del PATH para Composer"
    fi
fi

# Instalar las extensions que faltan
echo "Instalando extensiones"
sudo apt install php-mbstring php-xml php-bcmath php-zip -y


# Instalar Laravel si no está instalado
if command -v laravel > /dev/null 2>&1; then
    echo "Laravel ya está instalado"
else
    echo "Instalando Laravel"
    composer global require laravel/installer
    check_status "Laravel"
fi

echo "el script se ha completado"


