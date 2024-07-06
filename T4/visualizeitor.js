const area_grade = document.getElementById("grade");
const area_grade_opt = document.getElementById("grade-opt");
const area_grade_tg = document.querySelectorAll("#grade-tg1, #grade-tg2");
const area_outras = document.getElementById("grade-outras");

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

            // Cria o objeto matéria
            var materia = {
                nome: nome_materia,
                situacao: situacao,
                periodo: periodo,
                ano: ano,
                nota: nota,
                codigo: codigo,
                tipo: tipo
            };

            // Encontra a matéria existente no array
            var materiaExistente = materiasArray.find(m => m.codigo === codigo);

            if (!materiaExistente) {
                // Se não existir, adiciona a nova matéria
                materiasArray.push(materia);
            } else {
                // Se existir, atualiza se a nova é mais recente
                if (materiaExistente.ano < ano || (materiaExistente.ano == ano && materiaExistente.periodo < periodo)) {
                    var index = materiasArray.indexOf(materiaExistente);
                    materiasArray[index] = materia;
                }
            }
        });

        // Ordena o array pelo ano e, em seguida, pelo período
        materiasArray.sort((a, b) => {
            if (a.ano !== b.ano) {
                return a.ano - b.ano;
            }
            return a.periodo - b.periodo;
        });

        // Converte o array ordenado de volta para um Map
        var materiasMap = new Map(materiasArray.map(materia => [materia.codigo, materia]));

        return new Aluno(nome, matricula, materiasMap);
    }
}


// importar o json grade-default
var data = await fetch("grade-default.json")
    .then((response) => response.json());


// se houver algum evento de submit no #form, chama a função pesquisaAluno
$(document).ready(function () {
    ativaTooltips();    
    // geraGrade("none");
    // geraGradeOptTG("none");
    $('#form').submit(function (event) {
        event.preventDefault(); // Cancela o evento de submit
        // Chama a função pesquisaAluno
        pesquisaAluno();
    });
})


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
        }
    });

    // retornamos falso para não recarregar a página
    return false;
}

function atualizaGrade(aluno) {
    var quantidadeOptativas = 0;
    var quantidadeTG = 0;
    var materias = aluno.materias;
    // aluno.imprimeDados();
    // muda o name da grade para o grr do aluno
    area_grade.setAttribute("name", aluno.matricula);

    // imprime o nome e a data da materia cursada
    // materias.forEach((materia) => {
    //     console.log(`Matéria: ${materia.nome}`);
    //     console.log(`Período: ${materia.ano}/${materia.periodo}`);
    //     console.log("\n");
    // });

    // Para cada materia do aluno, altera o status do botão correspondente
    let optInseridas = 0, tgInseridas = 0;
    limpaGrades();
    materias.forEach((materia) => {
        var button;
        // como o xml tem dados desatualizados e nao temos o curriculo de 1998, podemos procurar diretamente no document se a materia existe ainda no curriculo de 2011
        if (!(button = area_grade.querySelector(`#${materia.codigo}`))) {
            if (materia.tipo === "Optativas" &&
                (button = area_grade.querySelector("#OPT" + (optInseridas + 1))) && (materia.situacao == STATUS.APROVADO || materia.situacao == STATUS.MATRICULADO)) {

                button.innerText = materia.codigo;
                trocaStatus(button, materia);
                atualizaTooltip(button, materia);
                optInseridas++;
                let modal = document.getElementById(button.getAttribute("data-bs-target").slice(1));
                vinculaGradeOpt(materia, modal);
            } else if (materia.tipo.includes("Trabalho de Graduação") && (button = area_grade.querySelector("#TG" + (tgInseridas + 1))) && (materia.situacao == STATUS.APROVADO || materia.situacao == STATUS.MATRICULADO)) {
                button.innerText = materia.codigo;
                trocaStatus(button, materia);
                atualizaTooltip(button, materia);
                tgInseridas++;
                let modal = document.getElementById(button.getAttribute("data-bs-target").slice(1));
                vinculaGradeTG(materia, modal);
            } else {
                return;
            }
        } else {
            button = document.getElementById(materia.codigo);
            trocaStatus(button, materia);
        }

        // Atualiza o modal da matéria
        // Altera o status do botão para o status da matéria

        // Se a matéria for optativa, incrementa a quantidade de optativas
        if (materia.tipo === "Optativas") {
            quantidadeOptativas++;
        }

        // Se a matéria for TG, incrementa a quantidade de TGs
        if (materia.tipo === ("Trabalho de Graduação")) {
            quantidadeTG++;
        }
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

    // se a situação nao existir, usa a cor #6f42c1 como background color header, como !important
    if (materia.situacao == STATUS.NAO_CURSADO){
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
    <p>Período: ${materia.periodo}</p>
    <p>Ano: ${materia.ano}</p>
    <p>Nota: ${materia.nota}</p>
    <p>Tipo: ${materia.tipo}</p>
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
    var materiasArray = Array.from(materias.values()).filter(materia => materia.tipo === "Optativas" || materia.tipo.includes("Trabalho de Graduação"));

    // todos os botoes de optativas e TG
    var buttons = Array.from(area_grade_opt.querySelectorAll("button"));
    buttons = buttons.concat(Array.from(area_grade_tg[0].querySelectorAll("button")));
    buttons = buttons.concat(Array.from(area_grade_tg[1].querySelectorAll("button")));

    materiasArray.forEach((materia) => {
        // verifica se a materia ja nao esta na grade principal
        if (area_grade.querySelector("#" + materia.codigo))
            return;

        // procura o botao da materia em buttons
        var button = buttons.find(button => button.id === materia.codigo);

        // se nao tem, cria
        if (!button) {
            let grade;

            if (materia.tipo === "Optativas") {
                grade = area_grade_opt;
            }
            else if (materia.tipo === "Trabalho de Graduação I") {
                grade = area_grade_tg[0];
            } else if (materia.tipo === "Trabalho de Graduação II") {
                grade = area_grade_tg[1];
            }
            criaMateria(grade, materia);
            return;
        }
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

// insere nessa grade todas as materias que nao foram inseridas
function atualizaGradeOutras(aluno) {
    var materias = aluno.materias;
    var materiasArray = Array.from(materias.values());

    // todos os botoes de optativas e TG
    var buttons = Array.from(area_outras.querySelectorAll("button"));

    materiasArray.forEach((materia) => {
        // verifica se a materia ja nao esta no documento
        if (document.querySelector("#" + materia.codigo))
            return;

        // como nao existe, cria o modal e o botao
        criaMateria(area_outras, materia);
        criaModal(materia);

    });

    // faz uma animação de accordeon na grade e após isso troca o display pra flex
    $(area_outras).collapse('show');
    area_outras.style.display = "flex";
}