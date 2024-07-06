const area_grade = document.getElementById("grade");
const area_grade_opt = document.getElementById("grade-opt");
const area_grade_tg = document.querySelectorAll("#grade-tg1, #grade-tg2");
const area_outras = document.getElementById("grade-outras");
// Seleciona todos os botões das grades
var todosBotoes = [];

class Aluno {
    constructor(nome, matricula, materias) {
        if (!arguments.length) { nome = null, matricula = null, materias = null; }
        this._nome = nome;
        this._materias = materias;
        this._matricula = matricula;
    }

    get nome() {
        return this._nome; // Usar _nome dentro do getter
    }

    set nome(nome) {
        this._nome = nome; // Usar _nome dentro do setter
    }

    get materias() {
        return this._materias; // Usar _materias dentro do getter
    }

    set materias(materias) {
        this._materias = materias; // Usar _cursos dentro do setter
    }

    get matricula() {
        return this._matricula; // Usar _matricula dentro do getter
    }

    set matricula(matricula) {
        this._matricula = matricula; // Usar _matricula dentro do setter
    }

    imprimeDados() {
        console.log(`Nome: ${this._nome}`);
        console.log(`Matrícula: ${this._matricula}`);
        console.log("Matérias:");
        this._materias.forEach((materia) => {
            console.log(`\t${materia.nome}`);
            console.log(`\tPeríodo: ${materia.ano}/${materia.periodo}`);
        });
    }

    static criaAluno(xml, codigo) {
        var $xml = $(xml), nome, matricula;
        var materiasArray = [];

        var $materias = $xml.find("ALUNO").filter(function () {
            return $(this).find("MATR_ALUNO").text() == "GRR" + codigo;
        });

        if ($materias.length == 0) {
            alert("Aluno não encontrado.");
            return;
        }

        nome = $materias.first().children("NOME_ALUNO").text();
        matricula = $materias.first().children("MATR_ALUNO").text();

        $materias.each(function () {
            var nome_materia = $(this).children("NOME_ATIV_CURRIC").text();
            var situacao = $(this).children("SIGLA").text();
            var periodo = $(this).children("PERIODO").text()[0];
            var codigo = $(this).children("COD_ATIV_CURRIC").text();
            var tipo = $(this).children("DESCR_ESTRUTURA").text();
            var ano = $(this).children("ANO").text();
            var nota = $(this).children("MEDIA_FINAL").text();
            var frequencia = $(this).children("FREQUENCIA").text();

            // Cria o objeto matéria
            var materia = {
                nome: nome_materia,
                situacao: situacao,
                periodo: periodo,
                ano: ano,
                nota: nota,
                codigo: codigo,
                tipo: tipo,
                frequencia: frequencia
            };

            // Encontra a matéria existente no array
            var materiaExistenteArray = materiasArray.find(m => m[0].codigo === codigo);
            if (!materiaExistenteArray) {
                // Se não existir, adiciona um novo array com a matéria
                materiasArray.push([materia]);
            } else {
                // Se existir, insere a nova matéria ao final do array correspondente
                materiaExistenteArray.push(materia);

                // Ordena o array interno pelo ano e período
                materiaExistenteArray.sort((a, b) => {
                    if (a.ano !== b.ano) {
                        return a.ano - b.ano; // Ordem crescente do ano
                    }
                    return a.periodo - b.periodo; // Ordem crescente do período
                });
            }
        });

        // Ordena o array externo pelo ano e, em seguida, pelo período da mais recente de cada array interno
        materiasArray.sort((a, b) => {
            const aRecent = a[a.length - 1]; // O mais recente é o último no array interno
            const bRecent = b[b.length - 1];
            if (aRecent.ano !== bRecent.ano) {
                return bRecent.ano - aRecent.ano; // Ordem decrescente do ano
            }
            return bRecent.periodo - aRecent.periodo; // Ordem decrescente do período
        });

        // Converte o array ordenado de volta para um Map com o código como chave
        var materiasMap = new Map(materiasArray.map(materiaArr => [materiaArr[0].codigo, materiaArr]));

        return new Aluno(nome, matricula, materiasMap);
    }
}


// importar o json grade-default
var data = await fetch("grade-default.json")
    .then((response) => response.json());


// se houver algum evento de submit no #form, chama a função pesquisaAluno
$(document).ready(function () {
    ativaTooltips();

    $('#form').submit(function (event) {
        event.preventDefault();
        pesquisaAluno();
    });
});



function verificaEntrada(entrada) {
    // verifica se o campo de entrada está vazio
    if (entrada == "") {
        alert("O campo de entrada não pode estar vazio.");
        return false;
    }
    // verifica se o número de entrada possui apenas números
    else if (/\D/.test(entrada)) {
        alert("O código do aluno deve ser apenas digitos.");
        return false;
    }
    // verifica se o número de entrada possui 9 dígitos
    else if (entrada.length != 8) {
        alert("O código do aluno deve ter 9 dígitos.");
        return false;
    }

    return true;
}

// funcao que gera a grade inicial
function geraGrade(tipo) {
    // para cada periodo, insere na grade a coluna das materias
    for (let periodo in data) {
        if (periodo == "OPT" || periodo == "TG") {
            continue;
        }

        const index = data[periodo];

        const col = document.createElement("div");
        col.classList.add("col", "col-flex", "d-flex", "flex-column", "justify-content-center", "text-center", "gap-3", "p-3", "mb-3", "mt-3");
        const h2 = document.createElement("h2");

        // Limpa o conteúdo anterior do elemento col, se necessário
        col.innerHTML = '';

        // Título do período
        h2.classList.add("text-center");
        h2.innerHTML = periodo;
        col.appendChild(h2);

        // Para cada matéria no período, criar um botão com o código da matéria
        data[periodo].forEach((materia) => {
            const span = document.createElement("span");
            //<span class="d-inline-block" tabindex="0" data-bs-toggle="tooltip" data-bs-title="Disabled tooltip">
            span.classList.add("d-inline-block");
            span.setAttribute("tabindex", "0");
            span.setAttribute("data-bs-toggle", "tooltip");
            span.setAttribute("data-bs-title", `${materia.nome}`);
            span.setAttribute("data-bs-trigger", "hover");

            const button = document.createElement("button");
            button.setAttribute("type", "button");

            button.classList.add("btn", "btn-none", "btn-lg", "btn-block", "w-100", "h-100");
            button.id = `${materia.codigo}`;
            button.innerHTML = `${materia.codigo}`;

            button.disabled = tipo == "none" ? true : false;

            // adiciona o atributo data-status com o status da matéria
            button.setAttribute("data-status", STATUS.NONE);

            // aqui cria o atributo data-toggle e data-target para abrir o modal/pop-up
            button.setAttribute("data-bs-toggle", "modal");
            button.setAttribute("data-bs-target", `#modal-${materia.codigo}`);
            criaModal(materia);

            span.setAttribute("tabindex", "0");
            span.appendChild(button);

            col.appendChild(span);
        });
        area_grade.appendChild(col);
    }


    ativaTooltips();
}

// funcao que gera a grade de optativas
function geraGradeOptTG(tipo) {
    data["OPT"].forEach((materia) => {
        const span = document.createElement("span");
        //<span class="d-inline-block" tabindex="0" data-bs-toggle="tooltip" data-bs-title="Disabled tooltip">
        span.setAttribute("tabindex", "0");
        span.setAttribute("data-bs-toggle", "tooltip");
        span.setAttribute("data-bs-title", `${materia.nome}`);
        span.setAttribute("data-bs-trigger", "hover");

        const button = document.createElement("button");
        button.setAttribute("type", "button");

        button.classList.add("btn", "btn-none", "btn-lg");
        button.id = `${materia.codigo}`;
        button.innerHTML = `${materia.codigo}`;

        button.disabled = tipo == "none" ? true : false;

        // adiciona o atributo data-status com o status da matéria
        button.setAttribute("data-status", STATUS.NONE);

        // aqui cria o atributo data-toggle e data-target para abrir o modal/pop-up
        button.setAttribute("data-bs-toggle", "modal");
        button.setAttribute("data-bs-target", `#modal-${materia.codigo}`);
        criaModal(materia);

        span.setAttribute("tabindex", "0");
        span.appendChild(button);

        area_grade_opt.appendChild(span);
    });

    data["TG"].forEach((materia) => {
        const span = document.createElement("span");
        //<span class="d-inline-block" tabindex="0" data-bs-toggle="tooltip" data-bs-title="Disabled tooltip">
        span.setAttribute("tabindex", "0");
        span.setAttribute("data-bs-toggle", "tooltip");
        span.setAttribute("data-bs-title", `${materia.nome}`);
        span.setAttribute("data-bs-trigger", "hover");

        const button = document.createElement("button");
        button.setAttribute("type", "button");

        button.classList.add("btn", "btn-none", "btn-lg");
        button.id = `${materia.codigo}`;
        button.innerHTML = `${materia.codigo}`;

        button.disabled = tipo == "none" ? true : false;

        // adiciona o atributo data-status com o status da matéria
        button.setAttribute("data-status", STATUS.NONE);

        // aqui cria o atributo data-toggle e data-target para abrir o modal/pop-up
        button.setAttribute("data-bs-toggle", "modal");
        button.setAttribute("data-bs-target", `#modal-${materia.codigo}`);
        criaModal(materia);

        span.setAttribute("tabindex", "0");
        span.appendChild(button);

        // insere o botao na grade-tg1 ou grade-tg2, dependendo do ultimo caractere
        // elas sao filhas de area_grade_tg
        if (materia.nome.substring(materia.nome.length - 2) == " I") {
            area_grade_tg[0].appendChild(span);
        } else if (materia.nome.substring(materia.nome.length - 2) == "II") {
            area_grade_tg[1].appendChild(span);
        }
    });
    ativaTooltips();
}

// evento que é chamado quando o botão de pesquisa é clicado
document.getElementById("botao-pesquisar").addEventListener("click", pesquisaAluno, false);

function pesquisaAluno() {
    let entrada = (document.getElementById("fGRRAluno")).value;
    let aluno;

    // verifica se a entrada é válida
    if (!verificaEntrada(entrada))
        return false;

    else if (area_grade.getAttribute("name") == entrada) {
        return false;
    }

    // se a entrada for válida, altera a grade para a grade do aluno
    $.ajax({
        url: "alunos.xml",
        type: "GET",
        dataType: "xml",
        success: function (xml) {
            alteraSiglas(xml);
            aluno = Aluno.criaAluno(xml, entrada);
            aluno.imprimeDados();
            atualizaGrade(aluno);
            atualizaGradeOptTG(aluno);
            atualizaGradeOutras(aluno);
            ativaTooltips();

            // listener contextmenu para os botões
            todosBotoes = Array.from(area_grade.querySelectorAll("button"));
            todosBotoes = todosBotoes.concat(Array.from(area_grade_opt.querySelectorAll("button")));
            todosBotoes = todosBotoes.concat(Array.from(area_grade_tg[0].querySelectorAll("button")));
            todosBotoes = todosBotoes.concat(Array.from(area_grade_tg[1].querySelectorAll("button")));
            todosBotoes = todosBotoes.concat(Array.from(area_outras.querySelectorAll("button")));

            // faz o display do modal-hist-<codigo> quando o botão é clicado com o botao direito
            todosBotoes.forEach((botao) => {
                botao.addEventListener("contextmenu", function (event) {
                    event.preventDefault();
                    var modal = document.getElementById("modal-hist-" + botao.id);
                    var bsModal = new bootstrap.Modal(modal);
                    bsModal.show();
                });
            });


        }
    });



    // retornamos falso para não recarregar a página
    return false;
}

function atualizaGrade(aluno) {
    var quantidadeOptativas = 0;
    var quantidadeTG1 = 0, quantidadeTG2 = 0;
    var materias = aluno.materias;
    // aluno.imprimeDados();
    // muda o name da grade para o grr do aluno
    area_grade.setAttribute("name", aluno.matricula);

    // Para cada materia do aluno, altera o status do botão correspondente
    let optInseridas = 0, tgInseridas = 0;
    limpaGrades();

    materias.forEach((historico) => {
        // Pega o último histórico da matéria (o mais recente)
        var materia = historico[historico.length - 1];
        var button;
        // Como o XML tem dados desatualizados e não temos o currículo de 1998, podemos procurar diretamente no documento se a matéria existe ainda no currículo de 2011
        if (!(button = area_grade.querySelector(`#${materia.codigo}`))) {
            if (materia.tipo === "Optativas" &&
                (button = area_grade.querySelector("#OPT" + (optInseridas + 1))) && (materia.situacao == STATUS.APROVADO || materia.situacao == STATUS.MATRICULADO)) {

                button.innerText = materia.codigo;
                trocaStatus(button, materia);
                atualizaTooltip(button, materia);
                optInseridas++;
                let modal = document.getElementById(button.getAttribute("data-bs-target").slice(1));
                vinculaGradeOpt(materia, modal);
            }
            // dependendo insere no tg1 ou no tg2
            // includes("Trabalho de Graduação") &&
            //     (button = area_grade.querySelector("#TG" + (tgInseridas + 1))) && (materia.situacao == STATUS.APROVADO || materia.situacao == STATUS.MATRICULADO)) {

            //     button.innerText = materia.codigo;
            //     trocaStatus(button, materia);
            //     atualizaTooltip(button, materia);
            //     tgInseridas++;
            //     let modal = document.getElementById(button.getAttribute("data-bs-target").slice(1));
            //     vinculaGradeTG(materia, modal);
            // }
            else if (materia.tipo === "Trabalho de Graduação I" &&
                (button = area_grade.querySelector("#TG1")) && (materia.situacao == STATUS.APROVADO || materia.situacao == STATUS.MATRICULADO) && quantidadeTG1 < 1) {

                button.innerText = materia.codigo;
                trocaStatus(button, materia);
                atualizaTooltip(button, materia);
                quantidadeTG1++;
                let modal = document.getElementById(button.getAttribute("data-bs-target").slice(1));
                vinculaGradeTG(materia, modal);
            }
            else if (materia.tipo === "Trabalho de Graduação II" &&
                (button = area_grade.querySelector("#TG2")) && (materia.situacao == STATUS.APROVADO || materia.situacao == STATUS.MATRICULADO) && quantidadeTG2 < 1) {

                button.innerText = materia.codigo;
                trocaStatus(button, materia);
                atualizaTooltip(button, materia);
                quantidadeTG2++;
                let modal = document.getElementById(button.getAttribute("data-bs-target").slice(1));
                vinculaGradeTG(materia, modal);
            }
            else if (materia.tipo !== "Optativas" && !(materia.tipo.includes("Trabalho de Graduação"))) {
                // Se a matéria não existe no currículo de 2011, cria um novo botão
                criaMateria(area_outras, materia);
                atualizaModal(document.getElementById("modal-" + materia.codigo), materia);
            }
        } else {
            button = document.getElementById(materia.codigo);
            trocaStatus(button, materia);
        }


        // junto a isso, cria um modal para cada materia, mostrando o historico da mesma
        criaHistoricoModal(historico);


    });

    ativaTooltips();
}


// função que limpa a grade, deixando todos os botões em branco
function limpaGrades() {
    // para todas as grades, junta em um HTMLelement e altera o status
    var buttons = Array.from(area_grade.querySelectorAll("button"));
    buttons = buttons.concat(Array.from(area_grade_opt.querySelectorAll("button")));
    buttons = buttons.concat(Array.from(area_grade_tg[0].querySelectorAll("button")));
    buttons = buttons.concat(Array.from(area_grade_tg[1].querySelectorAll("button")));

    buttons.forEach((button) => {
        trocaStatus(button, { nome: button.parentElement.getAttribute("data-bs-title"), situacao: STATUS.NAO_CURSADO, periodo: null, ano: null, nota: null, codigo: button.id, tipo: null });
    });

    area_outras.innerHTML = '';
}

// enums de status
// "Cada disciplina deve estar pintada com uma cor indicando a situação da última matrícula do aluno (aprovado em verde, reprovado em vermelho, matriculado em azul, equivalência em amarelo e não cursado em branco)."
const STATUS = {
    APROVADO: "aprovado",
    REPROVADO_NOTA: "reprovado",
    REPROVADO_FREQUENCIA: "repr-freq",
    MATRICULADO: "matricula",
    CANCELADO: "cancelado",
    EQUIVALENCIA: "equivale",
    DISPENSA_DE_DISCIPLINA: "dispensa",
    TRANCAMENTO_TOTAL: "trancamento",
    NAO_CURSADO: "default",
    NONE: "none"
}

// função que troca o status da materia
function trocaStatus(button, materia) {
    // captura o ultimo status da matéria e remove o btn-"status" do botão
    var statusAnterior = button.getAttribute("data-status");
    var modalId, modal;

    // Se o status fornecido for o mesmo que o status anterior, não faz nada
    if (statusAnterior === materia.situacao) {
        return;
    }
    // Se o status fornecido for NONE, desabilita o botão
    else if (materia.situacao === STATUS.NONE) {
        button.disabled = true;
    } else {
        button.disabled = false;
    }

    // Atualiza o status do botão para o status fornecido
    button.setAttribute("data-status", materia.situacao);

    // Remove a classe do status anterior e adiciona a classe do novo status
    button.classList.remove("btn-" + statusAnterior);
    button.classList.add("btn-" + materia.situacao);

    // acha o modal vinculado
    modalId = button.getAttribute("data-bs-target");
    modal = document.querySelector(modalId);

    atualizaModal(modal, materia);
}

// funcao que altera as siglas para facilitar ao mexer com os dados
function alteraSiglas(xml) {
    var $xml = $(xml);

    /* o campo <SIGLA> pode ser 
    Disp. c/nt
    Repr. Freq
    Reprovado
    Tr. Total
    Aprovado
    Cancelado
    Equivale
    */

    // para cada materia, altera a sigla para a sigla padronizada
    var siglas = xml.getElementsByTagName("SIGLA");
    var sigla, novaSigla;
    for (let i = 0; i < siglas.length; i++) {
        if (siglas[i].childNodes.length > 0)
            sigla = siglas[i].childNodes[0].nodeValue;
        else
            siglas[i].textContent = STATUS.NONE

        novaSigla = "";

        switch (sigla) {
            case "Disp. c/nt":
                novaSigla = STATUS.DISPENSA_DE_DISCIPLINA;
                break;
            case "Repr. Freq":
                novaSigla = STATUS.REPROVADO_FREQUENCIA;
                break;
            case "Reprovado":
                novaSigla = STATUS.REPROVADO_NOTA;
                break;
            case "Tr. Total":
                novaSigla = STATUS.TRANCAMENTO_TOTAL;
                break;
            case "Aprovado":
                novaSigla = STATUS.APROVADO;
                break;
            case "Cancelado":
                novaSigla = STATUS.CANCELADO;
                break;
            case "Equivale":
                novaSigla = STATUS.EQUIVALENCIA;
                break;
            case "Matricula":
                novaSigla = STATUS.MATRICULADO;
                break;
            default:
                novaSigla = STATUS.NAO_CURSADO
                break;
        }
        siglas[i].childNodes[0].nodeValue = novaSigla;
    }
}

// função que cria um popup basico para cada materia
function criaModal(materia) {
    // coloca o modal no nivel dos modals
    document.getElementById("modals").innerHTML += `
    <div class="modal fade" id="modal-${materia.codigo}">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header text-light bg-${materia.situacao}">
                    <h5 class="modal-title">${materia.nome}</h5>
                </div>
                <div class="modal-body">
                    <p>Código: ${materia.codigo}</p>
                    <p>Nome: ${materia.nome}</p>
                </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Fechar</button>
            </div>
        </div>
    </div>`;


    if (materia.situacao == STATUS.NAO_CURSADO) {
        // remove o background color do header
        let header = document.getElementById("modal-" + materia.codigo).querySelector(".modal-header");
        header.classList.remove("text-light");
        header.classList.add("text-dark");
    }
}

// função que atualiza o modal com as informações da materia
function atualizaModal(modal, materia) {
    // altera a cor da header do modal de acordo com a situação da materia
    var header = modal.querySelector(".modal-header");

    // verifica se tem algum bg- e remove
    header.classList.forEach((classe) => {
        if (classe.includes("bg-")) {
            header.classList.remove(classe);
        }
    });

    if (materia.situacao == STATUS.NAO_CURSADO)
        header.classList.add("bg-dark");
    else
        header.classList.add("bg-" + materia.situacao);

    // insere o nome da materia em tipografia h5
    header.querySelector("h5").innerHTML = materia.nome;

    // pega o corpo do modal
    var modalBody = modal.querySelector(".modal-body");

    // limpa o corpo do modal
    modalBody.innerHTML = '';

    // se for nao cursado, o modal fica apenas com a informação de nao cursado, o header fica com o texto da materia
    if (materia.situacao == STATUS.NAO_CURSADO) {
        modalBody.innerHTML = "<p>Não cursado</p>";
        return;
    }

    // adiciona as informações da materia no corpo do modal
    modalBody.innerHTML += `
    <p>Código: ${materia.codigo}</p>
    <p>Nome: ${materia.nome}</p>
    <p>Situação: ${materia.situacao}</p>
    <p>Ano: ${materia.ano}</p>
    <p>Período: ${materia.periodo}</p>
    <p>Nota: ${materia.nota}</p>
    <p>Frequência: ${materia.frequencia}</p>
    `;
}

function atualizaTooltip(button, materia) {
    button.parentElement.setAttribute("data-bs-title", materia.nome);
}

function ativaTooltips() {
    $(function () {
        $('[data-toggle="tooltip"]').tooltip()
    });

    let tooltipTriggerList = document.querySelectorAll('[data-bs-toggle="tooltip"]');
    let tooltipList = [...tooltipTriggerList].map(tooltipTriggerEl => new bootstrap.Tooltip(tooltipTriggerEl));
}

// insere a materia optativa na grade de optativas
function atualizaGradeOptTG(aluno) {
    var materias = aluno.materias;
    var materiasArray = Array.from(materias.values()).filter(historico => {
        var materia = historico[historico.length - 1]; // Pega o último histórico (o mais recente)
        return materia.tipo === "Optativas" || materia.tipo.includes("Trabalho de Graduação");
    });

    // Todos os botões de optativas e TG
    var buttonsOpt = Array.from(area_grade_opt.querySelectorAll("button"));
    var buttonsTG1 = Array.from(area_grade_tg[0].querySelectorAll("button"));
    var buttonsTG2 = Array.from(area_grade_tg[1].querySelectorAll("button"));
    var buttons = buttonsOpt.concat(buttonsTG1).concat(buttonsTG2);

    materiasArray.forEach((historico) => {
        var materia = historico[historico.length - 1]; // Pega o último histórico (o mais recente)

        // Verifica se a matéria já está na grade principal
        if (area_grade.querySelector("#" + materia.codigo)) {
            return;
        }

        // Procura o botão da matéria em buttons
        var button = buttons.find(button => button.id === materia.codigo);

        // Se não tem, cria
        if (!button) {
            let grade;

            if (materia.tipo === "Optativas") {
                grade = area_grade_opt;
            } else if (materia.tipo.includes("Trabalho de Graduação")) {
                if (materia.tipo === "Trabalho de Graduação I") {
                    grade = area_grade_tg[0];
                } else if (materia.tipo === "Trabalho de Graduação II") {
                    grade = area_grade_tg[1];
                }
            }

            criaMateria(grade, materia);
            atualizaModal(document.getElementById("modal-" + materia.codigo), materia);
            return;
        }

        // Atualiza o status do botão conforme o último histórico da matéria
        trocaStatus(button, materia);
    });

}


// vincula uma materia optativa na grade principal para a grade de optativas
function vinculaGradeOpt(materia, modal) {
    var buttonOpt = area_grade_opt.querySelector("#" + materia.codigo);

    // a matéria optativa era de outro currilo, então não existe na grade de optativas
    if (!buttonOpt)
        return;

    trocaStatus(buttonOpt, materia);

    // troca o modal da materia optativa para o modal da materia principal
    buttonOpt.setAttribute("data-bs-target", `#${modal.id}`);
}

// vincula uma materia optativa na grade principal para a grade de trabalho de graduacao
function vinculaGradeTG(materia, modal) {
    var buttonTG = null;
    var grade;
    if (materia.tipo === "Trabalho de Graduação I") {
        grade = area_grade_tg[0];
        buttonTG = area_grade_tg[0].querySelector("#" + materia.codigo);
    }
    else if (materia.tipo === "Trabalho de Graduação II") {
        grade = area_grade_tg[1];
        buttonTG = area_grade_tg[1].querySelector("#" + materia.codigo);
    }
    if (buttonTG) {
        trocaStatus(buttonTG, materia);
        // troca o modal da materia optativa para o modal da materia principal
        buttonTG.setAttribute("data-bs-target", `#${modal.id}`);
    } else {
        criaMateria(grade, materia);
    }
}

// função que cria um botao, modal, popup e o insere na grade
function criaMateria(grade, materia) {
    // cria o span
    var span = document.createElement("span");
    span.classList.add("d-inline-block");
    span.setAttribute("tabindex", "0");
    span.setAttribute("data-bs-toggle", "tooltip");
    span.setAttribute("data-bs-title", `${materia.nome}`);
    span.setAttribute("data-bs-trigger", "hover");


    // cria o botao
    var button = document.createElement("button");
    button.setAttribute("type", "button");
    button.classList.add("btn", ("btn-" + materia.situacao), "btn-lg");
    button.innerHTML = materia.codigo;
    button.id = materia.codigo;
    if (materia.situacao == STATUS.NONE)
        button.disabled = true;


    // adiciona o atributo data-status com o status da matéria
    button.setAttribute("data-status", materia.situacao);

    // aqui cria o atributo data-toggle e data-target para abrir o modal/pop-up
    button.setAttribute("data-bs-toggle", "modal");
    button.setAttribute("data-bs-target", `#modal-${materia.codigo}`);
    criaModal(materia);

    // adiciona o botao ao span
    span.appendChild(button);

    // insere o span na grade
    grade.appendChild(span);

    ativaTooltips();
}

function atualizaGradeOutras(aluno) {
    var materias = aluno.materias;
    var materiasArray = Array.from(materias.values());

    materiasArray.forEach((historico) => {
        // Pega o último histórico da matéria (o mais recente)
        var materia = historico[historico.length - 1];

        // Verifica se a matéria já está no documento
        if (document.querySelector("#" + materia.codigo)) {
            return;
        }

        // Como não existe, cria o modal e o botão
        criaMateria(area_outras, materia);
        criaModal(materia);

    });

    // Faz uma animação de accordion na grade e após isso troca o display para flex
    $(area_outras).collapse('show');
    area_outras.style.display = "flex";
}

// função que cria um modal com uma tabela com histórico da matéria
function criaHistoricoModal(materia) {
    // Extrai o código e o nome da matéria a partir do primeiro item do histórico
    var materiaAtual = materia[0];
    var codigo = materiaAtual.codigo;
    var nome = materiaAtual.nome;

    // Cria o id do modal a partir do código da matéria
    var modalId = 'modal-hist-' + codigo;

    // Imprime o histórico da matéria no console (apenas para depuração)
    materia.forEach(h => {
        console.log(h.ano + "/" + h.periodo + " - " + h.situacao + " - " + (h.nota !== undefined ? h.nota : 'N/A') + " - " + (h.frequencia !== undefined ? h.frequencia : 'N/A'));
    });

    // Cria o modal usando Bootstrap
    var modalHTML = `
        <div class="modal fade" id="${modalId}" tabindex="-1" aria-labelledby="${modalId}Label" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="${modalId}Label">Histórico de ${nome} (${codigo})</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <table class="table table-striped">
                            <thead>
                                <tr>
                                    <th>Ano/Semestre</th>
                                    <th>Frequência</th>
                                    <th>Nota</th>
                                    <th>Situação</th>
                                </tr>
                            </thead>
                            <tbody>
                                ${materia.map(h => `
                                    <tr>
                                        <td>${h.ano}/${h.periodo}</td>
                                        <td>${h.frequencia}</td>
                                        <td>${h.nota}</td>
                                        <td>${h.situacao}</td>
                                    </tr>`).join('')}
                            </tbody>
                        </table>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Fechar</button>
                    </div>
                </div>
            </div>
        </div>
    `;

    // Insere o modal no corpo do documento
    document.body.insertAdjacentHTML('beforeend', modalHTML);

}
