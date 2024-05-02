'use strict';

// Obtém o elemento canvas do HTML pelo id "myCanvas"
var html_canvas = document.getElementById("myCanvas");

// Obtém o contexto 2D do canvas com uma otimização para leitura frequente
var canvas = html_canvas.getContext("2d", { willReadFrequently: true });

// Variável que indica se houve clique sobre um ponto
var cliqueSobrePonto = false;

// Variável que indica se houve clique sobre uma linha
var cliqueSobreLinha = false;

// Objeto que armazena as coordenadas do ponto arrastado
var coordArrastada = { x: 0, y: 0, cor: "black" };

// Variável que armazena a linha que está sendo arrastada
var linhaArrastada;

// Variável para armazenar a instância da classe CanvasClass
var canvasClass;

// ajusta o tamanho do canvas toda vez que for carregado
window.onload = function () {
    html_canvas.width = window.innerWidth;
    html_canvas.height = window.innerHeight;
    canvasClass = new CanvasClass(html_canvas.width, html_canvas.height, [], []);
    geraReta();
};


// Eventos de clique no canvas
html_canvas.addEventListener("mousedown", (event) => {
    // verifica se o clique foi com o botão direito, se for não faz nada
    if (event.button == 2) return;

    // pega o ponto clicado
    let ponto = achaClique(event);

    // verifica se o clique foi em cima de um ponto ou de uma linha, ou de nada
    if (!ponto) return;
    else if (ponto[0] === "ponto") {
        cliqueSobrePonto = true;
        coordArrastada = ponto[1];

        // atualiza a cor do ponto, pois pontos clicados mudam de cor
        ponto[1].cor = "red";
        canvasClass.atualizaPonto(ponto[1]);
        canvasClass.desenhaPonto(ponto[1]);
    } else if (ponto[0] === "linha") {
        cliqueSobreLinha = true;
        coordArrastada = ponto[1];

        // pega a linha clicada e a atualiza, pois linhas clicadas mudam de cor
        linhaArrastada = canvasClass.getLinha({ x: event.offsetX, y: event.offsetY });
        ponto[1].cor = "orange";
        canvasClass.atualizaPonto(ponto[1]);
        canvasClass.desenhaLinha(ponto[1]);
    }
});

// Eventos de movimento do mouse no canvas
html_canvas.addEventListener("mousemove", (event) => {
    // verifica se o mouse está pressionado, e se for verifica se o clique foi em um ponto ou em uma linha
    if (cliqueSobrePonto) {
        // arrasta o ponto clicado
        canvasClass.arrastaPonto(event, coordArrastada);
    } else if (cliqueSobreLinha) {
        // arrasta a linha clicada
        linhaArrastada.cor = "orange";
        canvasClass.moverLinha(event, linhaArrastada);
    } else {
        return;
    }

    // desenha o caminho, atualizando o canvas
    canvasClass.desenhaCaminho();
});

// Evento de soltar o mouse
html_canvas.addEventListener("mouseup", function () {
    // verifica se o clique foi em um ponto ou em uma linha
    if (cliqueSobrePonto) {
        // se for em um ponto, atualiza a cor do ponto
        coordArrastada.cor = "black";
        canvasClass.atualizaPonto(coordArrastada);
    } else if (cliqueSobreLinha) {
        // se for em uma linha, atualiza a cor da linha 
        linhaArrastada.cor = "blue";
        canvasClass.atualizaLinha(linhaArrastada);
    }

    // desenha o caminho, atualizando o canvas
    cliqueSobrePonto = false;
    cliqueSobreLinha = false;
    canvasClass.desenhaCaminho();
});

// Evento de clique com o botão direito do mouse
html_canvas.addEventListener('contextmenu', function (event) {
    // pega a linha clicada
    let linha = achaClique(event);

    // verifica se o clique foi em algo ou em nada
    if (!linha) {
        return;
    }

    // verifica se o clique foi em uma linha
    if (linha[0] === "linha") {
        let coords = linha[1];
        // segmenta em duas linhas a linha clicada
        segmentaLinha(coords.x, coords.y);

        // por via das duvidas.
        cliqueSobreLinha = false;
    }

    // previne o menu de contexto padrão
    event.preventDefault();
    return false;
}, false);

/**
 * Função que gera um polígono com o número de lados especificado
 * */
function geraPoligono() {
    let lados = parseInt((document.getElementById("fLados")).value);

    // verifica se o número de lados é válido
    if (isNaN(lados)) {
        alert("O número de lados deve ser um número.");
        return;
    } else if (lados < 3 || lados > 8) {
        alert("O número de lados deve ser maior que 3 e menor que 8.");
        return;
    }

    // primeiro, limpamos o canvas
    canvasClass.limpaCanvas();

    // agora, desenhamos o polígono
    // o raio do polígono é 1/6 do tamanho da tela
    let raio = window.innerWidth / 6;
    // o centro do polígono é o centro da tela
    let x = window.innerWidth / 2;
    // a altura do polígono é 1/2 do tamanho da tela
    let y = window.innerHeight / 2;

    // calculamos o ângulo entre os lados, que é 2pi / lados devido a simetria do polígono
    let angulo = 2 * Math.PI / lados;

    // criamos os pontos do polígono, que serão reutilizados para fechar o polígono
    let inicio, ponto1, ponto2;
    let cos = [];
    let sin = [];

    // calculamos os valores de cosseno e seno para cada vértice, economizando processamento (bem pouco, mas é legal)
    for (let i = 0; i < lados; i++) {
        cos[i] = Math.cos(angulo * i);
        sin[i] = Math.sin(angulo * i);
    }

    // aqui, criamos o primeiro ponto do polígono, que será o ponto inicial também
    inicio = ponto1 = new Ponto(x + raio * cos[0], y + raio * sin[0], "black");

    // agora, criamos os outros pontos do polígono
    for (let i = 1; i < lados; i++) {
        // calculamos as coordenadas do próximo ponto, com um mod por segurança
        let x2 = x + raio * cos[i % lados];
        let y2 = y + raio * sin[i % lados];

        // criamos o ponto e a linha
        ponto2 = new Ponto(x2, y2, "black");
        new Linha(ponto1, ponto2, "blue");

        // pra nao ferrar com o loop, atualizamos o ponto1
        ponto1 = ponto2;
    }

    // fechamos o polígono, pois o último ponto não foi conectado ao primeiro
    new Linha(inicio, ponto2, "blue");

    // desenhamos o caminho, que por sinal é fechado! :D
    canvasClass.desenhaCaminho();

    // retornamos falso para não recarregar a página
    return false;
}

/**
 * Função que gera uma reta horizontal no centro da tela
 */
function geraReta() {
    // obtemos as dimensões da tela
    let largura = window.innerWidth;
    let y = window.innerHeight / 2;

    // obtemos as coordenadas iniciais e finais da reta
    let x_inicial = largura / 4;
    let x_final = largura * (3 / 4);

    // estilo do contorno ser azul
    canvas.strokeStyle = "blue";

    // criamos os pontos da reta na instância do canvasClass, para que possamos manipulá-los
    let ponto1 = new Ponto(x_inicial, y, "black");
    let ponto2 = new Ponto((x_inicial + x_final) / 2, y, "black");
    let ponto3 = new Ponto(x_final, y, "black");
    new Linha(ponto1, ponto2, "blue");
    new Linha(ponto2, ponto3, "blue");

    // desenhamos o caminho
    canvasClass.desenhaCaminho();
}

/**
 * Função que segmenta uma linha em dois pontos pela coordenada x e y do mouse, que é para estar sendo clicado em cima de uma linha (nao use fora disso por favor, não faz sentido)
 * @param {*} x coordenada x do ponto
 * @param {*} y coordenada y do ponto
 * */
function segmentaLinha(x, y) {
    // obtemos as coordenadas do ponto clicado
    let coords = { x: x, y: y };

    // cria um novo ponto
    let ponto = new Ponto(coords.x, coords.y, "black");

    // obtemos a linha clicada
    let linha = canvasClass.getLinha({ x: x, y: y });

    // removemos a linha clicada da instância do canvasClass
    canvasClass.removeLinha(linha);

    // criamos duas novas linhas com o ponto clicado
    new Linha(linha.u, ponto, "blue");
    new Linha(ponto, linha.v, "blue");

    // desenhamos o caminho
    canvasClass.desenhaCaminho();
}

/**
 * Função que calcula uma função da reta
 * @param {*} a coeficiente angular
 * @param {*} b coeficiente linear
 * @param {*} x coordenada x
 * */
function f(a, b, x) {
    return a * x + b;
}

/**
 * Função que retorna os a e b da função da reta
 * @param {*} ponto1 ponto inicial da reta
 * @param {*} ponto2 ponto final da reta
 * @returns um array contendo os coeficientes a e b da função da reta
 * */
function achaCoeficientes(ponto1, ponto2) {
    let x1 = ponto1.x;
    let y1 = ponto1.y;

    let x2 = ponto2.x;
    let y2 = ponto2.y;

    // somatórios...
    let sx = x1 + x2;
    let sx2 = (x1 ** 2) + (x2 ** 2);
    let sy = y1 + y2;
    let sxy = (x1 * y1) + (x2 * y2);

    // denominador
    let denominador = ((2 * sx2) - (sx * sx));

    // aqui usamos a regra de cramer para resolver o sistema linear
    let a = ((2 * sxy) - (sx * sy)) / denominador;
    let b = (((sy) * (sx2)) - ((sx * sxy))) / denominador;

    // retornamos os coeficientes
    return [a, b];
}

/**
 * Função que calcula a distancia entre dois pontos
 * @param {*} a ponto inicial
 * @param {*} b ponto final
 * @returns a distancia entre os dois pontos
 * */
function getDistance(a, b) {
    return Math.sqrt((a.x - b.x) ** 2 + (a.y - b.y) ** 2);
}

/**
 * Função que verifica se o ponto está dentro de um poligono
 * @param {*} event evento do mouse
 * @returns uma dupla no qual achaCLique[0] é uma string contendo o tipo do clique e achaClique[1] é o ponto ou linha clicado
 * */
function achaClique(event) {
    let x = event.offsetX;
    let y = event.offsetY;

    // Verifica se algum ponto foi clicado
    let ponto = canvasClass.pontos.find(p => {
        return p.x - 6 < x && p.x + 6 > x && p.y - 6 < y && p.y + 6 > y;
    });

    // verifica se o ponto clicado é um ponto né
    if (ponto) {
        return ["ponto", ponto];
    } else {
        // verifica se o pixel clicado não está em cima de uma linha, verificando a cor do pixel
        let pixel = canvas.getImageData(x - 3, y - 3, 6, 6).data;

        // verifica se algum pixel não é branco
        if (pixel) {
            // verifica se algum pixel não é branco
            if (pixel.some(p => p != 0)) {
                return ["linha", { x: x, y: y }];
            }
        }
    }

    // caso não tenha clicado em nada
    return null;
}

$(document).ready(function () {
    $('#form').submit(function (event) {
        event.preventDefault(); // Cancela o evento de submit

        // Chama a função geraPoligono
        geraPoligono();
    });
});

/**
 * Classe que representa o próprio canvas
 */
class CanvasClass {
    // construtor
    constructor(altura, largura, pontos, linhas) {
        this.largura = largura;
        this.altura = altura;
        this.pontos = pontos;
        this.linhas = linhas;
    }

    /**
     * Método que remove um ponto no canvas e o apaga da lista de pontos 
     * @param {*} x coordenada x do ponto
     * @param {*} y coordenada y do ponto
     */
    removePonto(x, y) {
        // muda a composição para apagar o ponto
        canvas.globalCompositeOperation = 'destination-out';
        canvas.beginPath();
        canvas.arc(x, y, 7, 0, 2 * Math.PI);
        canvas.fill();
        canvas.closePath();

        // volta a composição padrão
        canvas.globalCompositeOperation = "source-over";

        // apaga o ponto da lista
        this.pontos = this.pontos.filter(p => {
            return !(p.x === x && p.y === y);
        });
    }

    /**
     * Método que desenha um ponto no canvas
     * @param {*} p ponto a ser desenhado
     * */
    desenhaPonto(p) {
        canvas.beginPath();
        canvas.fillStyle = p.cor;

        canvas.arc(p.x, p.y, 6, 0, 2 * Math.PI);
        canvas.fill();
        canvas.closePath();
    }

    /**
     * Função que apaga um ponto e cria um novo ponto no lugar, retorna o novo ponto
     * @param {*} pontoAntigo ponto a ser movido
     * @param {*} pontoNovo ponto para onde o ponto antigo será movido
     * */
    moverPonto(pontoAntigo, pontoNovo) {
        let novoX = pontoNovo.x;
        let novoY = pontoNovo.y;

        // procura os vizinhos do pontoAntigo
        let vizinhos = this.linhas.filter(l => {
            return ((l.u.x === pontoAntigo.x && l.u.y === pontoAntigo.y) ||
                (l.v.x === pontoAntigo.x && l.v.y === pontoAntigo.y));
        });

        // apaga o ponto antigo
        this.removePonto(pontoAntigo.x, pontoAntigo.y);

        // atualiza as linhas
        vizinhos.forEach(vizinho => {
            if (vizinho.u.x === pontoAntigo.x && vizinho.u.y === pontoAntigo.y) {
                vizinho.u.x = novoX;
                vizinho.u.y = novoY;
            }
            else {
                vizinho.v.x = novoX;
                vizinho.v.y = novoY;
            }
        });

        // seleção de cor (se um ponto novo não tiver cor, ele herda a cor do ponto antigo)
        if (!pontoNovo.cor) {
            return new Ponto(novoX, novoY, pontoAntigo.cor);
        }
        return new Ponto(novoX, novoY, pontoNovo.cor);
    }

    /**
     * Método que arrasta um ponto no canvas
     * @param {*} event evento do mouse
     * @param {*} pontoAntigo ponto a ser arrastado
     * */
    arrastaPonto(event, pontoAntigo) {
        var x = event.offsetX;
        var y = event.offsetY;

        console.log("mouseX: " + x + " mouseY: " + y);
        canvasClass.moverPonto(pontoAntigo, { x: x, y: y, cor: "red" });
        pontoAntigo.cor = "red";
        this.atualizaPonto(pontoAntigo);
        coordArrastada.x = x;
        coordArrastada.y = y;
    }

    /**
     * Método que move uma linha no canvas
     * @param {*} event evento do mouse
     * @param {*} linhaAntiga linha a ser movida
     * */
    moverLinha(event, linhaAntiga) {
        let x = event.offsetX;
        let y = event.offsetY;

        let u = linhaAntiga.u;
        let v = linhaAntiga.v;

        // calcula o deslocamento do mouse
        let deltaX = x - coordArrastada.x;
        let deltaY = y - coordArrastada.y;

        // Move os pontos da linha de acordo com a diferença calculada
        u = this.moverPonto(u, { x: u.x + deltaX, y: u.y + deltaY, cor: u.cor });
        v = this.moverPonto(v, { x: v.x + deltaX, y: v.y + deltaY, cor: v.cor });

        // Atualiza a posição inicial do mouse
        coordArrastada.x = x;
        coordArrastada.y = y;
    }

    /**
     * Método que desenha uma linha no canvas
     * @param {*} pontoInicial ponto inicial da linha
     * @param {*} pontoFinal ponto final da linha
     * @param {*} cor cor da linha
     * */
    desenhaLinha(pontoInicial, pontoFinal, cor) {
        if (!pontoInicial || !pontoFinal) {
            return;
        }

        canvas.strokeStyle = cor;
        canvas.beginPath();
        canvas.moveTo(pontoInicial.x, pontoInicial.y);
        canvas.lineWidth = 3;
        canvas.lineTo(pontoFinal.x, pontoFinal.y);
        canvas.stroke();
        canvas.closePath();
    }

    /**
     * Método que desenha o caminho no canvas
     * */
    desenhaCaminho() {
        // limpa o canvas
        canvas.clearRect(0, 0, html_canvas.width, html_canvas.height);

        // insere no novo caminho cada ponto
        canvasClass.linhas.forEach(l => {
            this.desenhaLinha(l.u, l.v, l.cor);
            this.desenhaPonto(l.u);
            this.desenhaPonto(l.v);
        });
    }

    /**
     * Método que remove uma linha do canvas
     * @param {*} linha linha a ser removida
     * */
    removeLinha(linha) {
        this.linhas = this.linhas.filter(l => {
            return !(l.u.x === linha.u.x && l.u.y === linha.u.y && l.v.x === linha.v.x && l.v.y === linha.v.y);
        });
    }

    /**
     * Método que retorna a linha que contém a coordenada clicada
     * @param {*} coords coordenadas do ponto clicado
     * */
    getLinha(coords) {
        let linha = null;
        // procura a linha que contém o ponto clicado calculando a distancia de dois pontos
        let linhas = this.linhas.filter(l => {
            let [a, b] = achaCoeficientes(l.u, l.v);
            return (Math.abs(f(a, b, coords.x) - coords.y) < 6) || (Math.abs(f(a, b, coords.x) - coords.y) > 6);
        });

        // pega a linha em que a distancia do ponto é menor
        linhas.forEach(l => {
            // pega a menor distancia entre os dois pontos
            let dpu = getDistance(l.u, coords);
            let dpv = getDistance(l.v, coords);
            let dLuv = getDistance(l.u, l.v);

            // calcula com erro de 2 casas decimais
            if (Math.abs(dpu + dpv - dLuv) < 1) {
                console.log("Linha encontrada");
                linha = l;
            }
        });

        // caso a linha não seja encontrada
        if (!linha) {
            console.error("Linha não encontrada");
            return;
        }

        return linha;
    }

    /**
     * Método que atualiza um ponto na instância do canvasClass e o retorna
     * @param {*} p ponto a ser atualizado
     * */
    atualizaPonto(p) {
        // remove o ponto antigo
        this.pontos = this.pontos.map(ponto => {
            if (ponto.x === p.x && ponto.y === p.y) {
                return p;
            }
            return ponto;
        });

        // insere o novo ponto
        this.linhas = this.linhas.map(linha => {
            if (linha.u.x === p.x && linha.u.y === p.y) {
                linha.u = p;
            }
            if (linha.v.x === p.x && linha.v.y === p.y) {
                linha.v = p;
            }
            return linha;
        });

        return p;
    }

    /**
     * Método que atualiza a linha no canvas e a retorna
     * @param {*} l linha a ser atualizada
     * */
    atualizaLinha(l) {
        this.linhas = this.linhas.map(linha => {
            if (linha.u.x === l.u.x && linha.u.y === l.u.y && linha.v.x === l.v.x && linha.v.y === l.v.y) {
                return l;
            }
            return linha;
        });
        return l;
    }

    /**
     * Função que apaga todos os pontos e linhas da instância CanvasClass, não é o mesmo que apagar o desenho.
     * */
    limpaCanvas() {
        this.pontos = [];
        this.linhas = [];
    }

}

/**
 * Classe que representa um ponto no plano cartesiano
 */
class Ponto {
    // construtor
    constructor(x, y, cor) {
        this.x = x;
        this.y = y;
        this.cor = cor;

        // insere o ponto na lista de pontos
        canvasClass.pontos.push({ x: x, y: y, cor: cor });
    }
}


/**
 * Classe que representa uma linha no plano cartesiano
 */
class Linha {
    // construtor
    constructor(pontoInicial, pontoFinal, cor) {
        this.v = pontoInicial;
        this.u = pontoFinal;
        this.cor = cor;

        // insere a linha na lista de linhas
        canvasClass.linhas.push({ v: this.v, u: this.u, cor: this.cor });
    }
}
