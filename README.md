#  Projeto Final — Programação Estatística e Simulação  
## **Simulação do Problema dos Sobrenomes de Galton (Processo de Galton–Watson)**

**Integrantes:** Lara & Marcelo  
**Repositório:** https://github.com/Marcehlin/Trabalho-ProgEstat  

---

##  **Introdução**

Este trabalho tem como objetivo estudar o **problema da extinção de sobrenomes** proposto originalmente por **Galton e Watson**, simulando o comportamento de processos de ramificação sob diferentes distribuições de probabilidade para o número de descendentes.

Por meio de simulações computacionais em R, investigamos:

- Sob quais condições um sobrenome está destinado a desaparecer;  
- Como a distribuição da prole influencia a probabilidade de extinção;  
- Como se comporta a distribuição do **tempo até a extinção** em diferentes regimes (subcrítico, crítico e supercrítico).

O notebook principal do trabalho é:

 **`Trabalho_Prog_Estat_Tema_Galton_Grupo_Lara_e_Marcelo.ipynb`**

---

##  **Modelo: Processo de Galton–Watson**

O processo é definido por:

- População inicial: **$Z_0 = 1$**
- Para cada geração *$k$*, enquanto \( 0 < $Z_k$ < 10^6 \):  $Z_{k+1} = \sum_{j=1}^{Z_k} X_j, \quad X_j \sim D$

- A distribuição da prole \(D\) pode ser:
  - $Poisson(λ)$ 
  - $Binomial(n, p)$  
  - Uniforme discreta
  - Distribuições discretas customizadas  

A linhagem se extingue quando **$Z_k = 0$**, e registramos o **tempo de extinção**.  
Se ($Z_k$ > 10^6), a trajetória é considerada **não extinta** e **truncada**.

A probabilidade de extinção é estimada pela proporção de simulações que atingem extinção.

---

##  **Metodologia**

A análise utiliza duas funções principais:

### **Função que simula um único processo de ramificação**
Ela devolve uma lista contendo:

- Extinção (TRUE/FALSE)  
- Tempo de extinção (se ocorrer)  
- Soma total das populações (embora não tenhamos usado essa variável no trabalho, decidimos manter) 
- Histórico do tamanho populacional por geração  

---

### **Função para múltiplas simulações (M repetições)**
Para cada regime:

- Executa M processos de Galton–Watson  
- Armazena o resultado em um **data.frame**  
- Mantém uma lista com as trajetórias (histórias)  
- Calcule estatísticas de interesse  

---

## **Experimentos Realizados**

Utilizamos diferentes distribuições classificadas entre:

- **Subcrítico (média < 1)** → extinção garantida  
- **Crítico (média = 1)** → extinção garantida, mas mais lenta  
- **Supercrítico (média > 1)** → extinção não é garantida  

### Distribuições simuladas

| Distribuição | Média | Regime |
|-------------|-------|--------|
| $Poisson(0.8)$ | 0.8 | Subcrítico |
| $Poisson(1.0)$ | 1.0 | Crítico |
| $Poisson(1.2)$ | 1.2 | Supercrítico |
| $Poisson(2.0)$ | 2.0 | Supercrítico |
| $Binomial(2, 0.3)$ | 0.6 | Subcrítico |
| $Binomial(2, 0.5)$ | 1.0 | Crítico |
| $Binomial(2, 0.6)$ | 1.2 | Supercrítico |
| $Binomial(4, 0.5)$ | 2.0 | Supercrítico |
| Discreta {0,2} prob= {0.5,0.5} | 1.0 | Crítico |
| Discreta {0,1,2,3} probs = (0.3,0.2,0.3,0.2) | 1.2 | Supercrítico |
| Discreta {0,2,100} probs = (0.5,0.49,0.01) | 1.98 | Supercrítico |

---