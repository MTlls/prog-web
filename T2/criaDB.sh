#!/bin/bash

# Cria o banco de dados
echo "Criando o banco de dados..."
# Comandos para criar o banco de dados

# Executa arquivos Ruby que começam com "cria"
echo "Executando arquivos Ruby..."
for file in ./cria*.rb; do
    if [ -f "$file" ]; then
        echo "Executando $file..."
        ruby "$file"
    fi
done

echo "Concluído."
