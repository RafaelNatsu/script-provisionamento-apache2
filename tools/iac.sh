#! /bin/bash

# Atualiza a lista de pacotes e instala o Apache, unzip e wget (por conta do docker)
echo "Iniciando a instalação..."
apt-get update
apt-get upgrade -y
apt-get install -y wget
apt-get install -y apache2 unzip

# Verifica se o Apache foi instalado com sucesso
if [ $? -ne 0 ]; then
  echo "A instalação do Apache falhou. Verifique o sistema e tente novamente."
  exit 1
fi

echo "Baixando arquivo..."
# Cria um diretório temporário para o site
cd /tmp
# Baixa a aplicação
wget https://github.com/denilsonbonatti/linux-site-dio/archive/refs/heads/main.zip

# Verifica se o download foi concluído com sucesso
if [ $? -ne 0 ]; then
  echo "Falha ao baixar o arquivo ZIP do site. Verifique a URL e a conectividade com a Internet."
  exit 1
fi

echo "Unzip do arquivo..."
# Unzip da aplicação
unzip main.zip
# Copia do zip para a pasta destino no apache
cd linux-site-dio-main
cp -R /tmp/linux-site-dio-main/ /var/www/linux-site-dio-main/

# Configure as permissões corretas para os arquivos
chown -R www-data:www-data /var/www/linux-site-dio-main/
chmod -R 755 /var/www/linux-site-dio-main/

# Remover os arquivos de configuração default
rm -rf /etc/apache2/sites-available/*

# Removendo arquivos temporarios.
rm -rf /tmp

echo "Inserindo configurações do apache..."
# Cria um arquivo de configuração para o site
cat <<EOL > /etc/apache2/sites-available/linux-site-dio-main.conf
<VirtualHost *:80>
    ServerAdmin webmaster@localhost
    DocumentRoot /var/www/linux-site-dio-main
    DirectoryIndex index.html
    ErrorLog \${APACHE_LOG_DIR}/error.log
    CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOL

# Ativa o site (vhost)
a2ensite linux-site-dio-main.conf

# Inicia o processo do Apache
service apache2 start

# Reinicie o Apache para aplicar as configurações
service apache2 reload

echo "O Apache foi instalado e o site configurado com sucesso!"
exit 0