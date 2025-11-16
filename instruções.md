#Descrição do trabalho:

##1: Formato e critérios de avaliação
Cada projeto deve ser entregue em um único notebook R ou Python, com texto explicativo em formato relatório com código. Use semente fixa. O código usado deve ser colocado no github de forma organizada e clara. Reprodutibilidade é parte da nota. 2 dos grupos serão sorteados para apresentar os projetos e responder perguntas sobre o conteúdo e o código no dia 25/11.

Entrega sugerida

* Introdução breve com objetivo claro e perguntas.

* Descrição do modelo gerador dos dados.

* Metodologia de simulação, incluindo algoritmos.

* Experimentos com plano e métricas.

* Resultados com gráficos legíveis e tabelas simples, juntamente com suas interpretações.

**Problema dos sobrenomes de Galton**

**Introdução**

O problema da extinção de sobrenomes, popularizado por Francis Galton e Henry
William Watson no século XIX, é um dos exemplos canônicos de processos estocásticos de ramificação. O objetivo deste projeto é simular a evolução de uma linhagem (representada por um sobrenome) ao longo de gerações para estimar a probabilidade de sua extinção e o tempo esperado até que isso ocorra. As questões centrais são: Sob quais condições um sobrenome está destinado a desaparecer? Como a distribuição do número de descendentes de um indivíduo afeta essa probabilidade? Qual é a distribuição do tempo até a extinção
nos casos em que ela ocorre?

**Modelo Gerador**

O sistema é modelado como um processo de ramificação de Galton-Watson.
Começamos com uma única partícula (o ancestral) na geração $G_0$.

O número de descendentes (filhos) de cada partícula na geração $G_i$ pe uma variável aleatória independente e identicamente distribuída (i.i.d.) com uma distribuição de prole D.

Seja $Z_k$ o número de partículas na geração $G_k$. Então, $Z_{k+1}$ = $\sum_{j=1}^{Z_k} X_j$, onde cada $X_j ∼ D$ é o número de filhos do j-ésimo indivíduo da geração k. A linhagem se extingue se, para algum k, $Z_k = 0$.

Neste projeto, você deverá explorar diferentes distribuições para a prole D:
* Poisson($λ$): Um modelo clássico, onde o número médio de filhos é $λ$.
* Binomial(n, p): Representa um número máximo de filhos n, cada um com probabilidade p de ocorrer.

**Metodologia de Simulação**

A simulação de uma única trajetória do processo é feita iterativamente:
1. Inicie com $Z_0 = 1$ na geração $k = 0$.
2. Para cada geração k, enquanto Zk > 0:
* Gere $Z_k$ números aleatórios da distribuição de prole D.
* Calcule a nova população $Z_k+1$ como a soma desses números.
* Incremente k.
3. Se $Z_k = 0$, a linhagem se extinguiu na geração k. Registre o tempo de extinção. Se a população crescer além de um limiar muito grande (por exemplo: $10^6$), a trajetória pode ser considerada como não extinta e truncada.
A probabilidade de extinção é estimada pela frequência de trajetórias que se extinguiram em um grande número de simulações.

Plano de Experimentos e Métricas
O comportamento do processo depende crucialmente do número médio de descendentes, m = E[X]. Os experimentos devem investigar os três regimes:

* Subcrítico (m < 1): A extinção é garantida. Use uma distribuição com média menor que 1 (e.g., Poisson(0.8)).

* Crítico (m = 1): A extinção também é garantida, mas o processo pode demorar mais. Use Poisson(1).

* Supercrítico (m > 1): Há uma probabilidade positiva de sobrevivência eterna.
Use Poisson(1.2) e Poisson(2.0).

Para cada regime:
* Realize M = 10000 simulações.
* Métricas:
(a) Frequência de extinção (para estimar a probabilidade).
(b) Para as linhagens extintas, colete o tempo até a extinção.