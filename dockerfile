FROM ubuntu

WORKDIR /app

# Libera a porta
EXPOSE 80
# Copia o script pro container
COPY ./tools/iac.sh ./tools/iac.sh
RUN chmod +x ./tools/iac.sh
# Executar o codigo de provisionamento
RUN /app/tools/iac.sh

# Inicia o processo em primeiro plano para o funcionamento do serviço
ENTRYPOINT ["/usr/sbin/apachectl","-D","FOREGROUND"]