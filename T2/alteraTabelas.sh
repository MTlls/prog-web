#!/bin/bash

# Obtém o comando e seus argumentos
comando="$1"
entrada="$@"

# Cria uma variavel que armazena a tabela
tabela="$2"

# Como a tabela eh no plural, o queremos acessar o .rb no singular
# se for autores queremos acessar autor.rb
if [ "$tabela" == "autores" ]; then
    tabela="autor"
# se for carteirinhasLivros queremos acessar carteirinhasLivros.rb
elif [ "$tabela" == "carteirinhasLivros" ]; then
    tabela="carteirinhasLivros"
# se nao apenas retiramos o ultimo caractere
else
    tabela="${tabela%?}"
fi


# Explica os comandos se o comando for desconhecido
if [ "$#" -lt 2 ]; then
    echo "Erro: o comando é ./alteraTabelas.sh <comando> <tabela> {atributo=valor} {atributo=valor, ...}"
    exit 1
fi

# Verifica o comando
case "$comando" in
insere)
    # echo "ruby "$tabela".rb "--$comando" "${@:3}""

    # dependendo da tabela, o comando muda

    ruby "$tabela".rb "--$comando" "${@:3}"
    ;;
atualiza)
    # verifica se o comando atualiza tem mais de 3 argumentos
    if [ "$#" -lt 3 ]; then
        echo "Erro: o comando atualiza é ./alteraTabelas.sh atualiza <tabela> <id> {atributo=valor} {atributo=valor, ...}"
        exit 1
    fi


    for arg in "$@"; do
        # Verifica se o argumento começa com "nome="
        if [[ $arg == nome=* ]]; then
            # Extrai o valor do argumento e remove o prefixo "nome="
            nome="${arg#nome=}"
        fi

        # Verifica se o argumento começa com "endereco="
        if [[ $arg == endereco=* ]]; then
            # Extrai o valor do argumento e remove o prefixo "endereco="
            endereco="${arg#endereco=}"
        fi

        # Verifica se o argumento começa com "cpf="
        if [[ $arg == cpf=* ]]; then
            # Extrai o valor do argumento e remove o prefixo "cpf="
            cpf="${arg#cpf=}"
        fi

        # Verifica se o argumento começa com "email="
        if [[ $arg == email=* ]]; then
            # Extrai o valor do argumento e remove o prefixo "email="
            email="${arg#email=}"
        fi

        # Verifica se o argumento começa com "telefone="
        if [[ $arg == telefone=* ]]; then
            # Extrai o valor do argumento e remove o prefixo "telefone="
            telefone="${arg#telefone=}"
        fi
    done

    # echo "ruby "$tabela".rb "--$comando" "${@:3}""

    # dependendo da tabela, o comando muda
    ruby "$tabela".rb "--$comando" "${@:3}"
    ;;

lista)
    # se a tabela for carteirinhasLivros temos que passar o id do autor ou do livro
    if [ "$tabela" == "carteirinhasLivros" ]; then
        # Chama o script Ruby com os argumentos ordenados
        # echo "ruby "$tabela".rb "--$comando" "${@:3}""
        ruby "$tabela".rb "--$comando" "${@:3}"
    else
        # Verifica se há mais do que os argumentos de atualiza <tabela>
        if [ "$#" -gt 2 ]; then
            echo "Erro: o comando lista é ./alteraTabelas.sh lista <tabela>"
            exit 1
        fi
        # Chama o script Ruby com os argumentos ordenados
        # echo "ruby "$tabela".rb "--$comando""
        ruby "$tabela".rb "--$comando"
    fi
    ;;

exclui)
    # Chama o script Ruby com os argumentos ordenados
    # echo "ruby "$tabela".rb "--$comando" "${@:3}""
    ruby "$tabela".rb "--$comando" "${@:3}"
    ;;
*)
    echo "Comando desconhecido: $comando"
    exit 1
    ;;
esac
