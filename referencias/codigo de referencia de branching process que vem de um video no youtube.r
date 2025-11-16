library(data.table)

nsims <- 10 #numero de simulações
ngen <- 30 #numero de gerações

#uma distribuição por ai

offspring <- 0:3 # suporte = {0, 1, 2, 3}
probabilidade <- c(0.1, 0.2, 0.4, 0.3) #as probabilidades: P(X=0) = 0.1, P(X=1) = 0.2, P(X=2) = 0.4, P(X=3) = 0.3
#sum(offspring * probabilidade) #a esperança

dados <- data.table(trial = 1:nsims,
                    extincao = 0,
                    geracoes <- 0,
                    n = 0)

dados_historico <- matrix(0, nrow = ngen, ncol = nsims)
dados_historico[1, ] <- 1 #definir Z_0 como 1, ou seja a geração começa com uma pessoa

#head(dados_historico[1:5, 1:10])

for (i in 1:nsims) {
  populacao <- 1 #definir a população total de um processo, já que Z_0 é 1, total no começo é 1
  geracao <- 0
  for (j in 2:ngen) {

    populacao <- sum(sample(x = offspring,
                            size = populacao,
                            p = probabilidade,
                            replace = TRUE))
    dados_historico [j, i] <- populacao

    if (populacao == 0){
      dados$extincao[i] <- 1
      dados$geracoes[i] <- j
      dados$n[i] <- populacao
    }
  geracao <- geracao + 1
  }
}

head(dados_historico[1:5, 1:10])