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


set.seed(0)
nsims <- 500
index <- 50

# function to generate paths
FUN_branch <- function(index) {
  population <- 1
  for (i in 2:index) {
    population <- c(population, sum(sample(0:2, 
                                    population[length(population)],
                                    replace = TRUE,
                                    prob = c(1 / 4, 1 / 2, 1 / 4))))
  }
  population
}

library(data.table)
# generate data and visualize
data <- data.table(t = 1:index, 
                   replicate(FUN_branch(index), n = nsims))
data <- melt(data, id.vars = "t")
ggplot(data, aes(x = t, y = value, col = variable)) +
  geom_line(alpha = 0.5) +
  theme_bw() +
  theme(legend.position = "none") +
  ggtitle("Simple Branching Process") +
  xlab("t") + ylab("size of population")


# Sua lista de histórias
historias <- resultados_simulacoes$critico_binom$historias

# Converter a lista para data.table no formato adequado
data <- rbindlist(
  lapply(seq_along(historias), function(i) {
    trajetoria <- historias[[i]]
    # Estender a trajetória com zeros até max_length
    trajetoria_completa <- c(trajetoria, rep(0, max_length - length(trajetoria)))
    
    data.table(
      t = 1:max_length,
      value = trajetoria_completa,
      variable = paste0("sim", i)
    )
  })
)

# Criar o gráfico (código muito similar ao original)
ggplot(data, aes(x = t, y = value, col = variable)) +
  geom_line(alpha = 0.6) +
  theme_bw() +
  theme(legend.position = "none") +
  ggtitle("Processo de Ramificação - Subcrítico Poisson") +
  xlab("Tempo") + 
  ylab("size of population")