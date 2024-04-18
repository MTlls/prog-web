#!/bin/bash

# Verifica se o banco de dados existe
if [ ! -f Biblioteca.sqlite3 ]; then
    echo "O banco de dados não existe."
else
    # Remove o banco de dados se existe
    echo "Removendo o banco de dados..."

    rm Biblioteca.sqlite3*
    echo "Conluído."
fi
