library(dplyr)
library(ggplot2)
library(purrr)

freq <- sapply(resultados_simulacoes, function(x) sum(x$df$Extincao))
prob_extincao <- sapply(resultados_simulacoes, function(x) mean(x$df$Extincao))

#tempo_medio_extincao para cada regime que fizemos simulações
tempo_medio_extincao <- sapply(resultados_simulacoes, function(x) {
  tempos <- x$df$Tempo_Extincao
  tempos <- tempos[is.finite(tempos)]
  return (mean(tempos))
})

#metricas em um dataframe, para fazer plot_01
metricas <- data.frame(
  Regime = names(regimes),
  Prob_Extincao = prob_extincao,
  Tempo_Medio_Extincao = tempo_medio_extincao
)

#metricas em uma lista, para fazer plot_02
dados_extincao <- sapply(resultados_simulacoes, function(x) {
  tempos <- x$df$Tempo_Extincao
  tempos <- tempos[is.finite(tempos)]
  return (tempos)
})

#Gráfico 1: que mostra as frequências relativas vulgo as probabilidades de extinção por regime estabelecido
plot_01 <- ggplot(metricas, aes(x = Regime, y = Prob_Extincao, fill = Regime)) +
  geom_col(alpha = 0.8) +
  geom_text(aes(label = sprintf("%.2f", Prob_Extincao)), vjust = -0.5) +
  labs(title = "Probabilidade de Extinção por Regime",
       x = "Regimes", 
       y = "Probabilidade de Extinção") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Gráfico 2: que mostra a distribuição do tempo de extinção para cada regime (apenas para as extintas)
plot_02 <- ggplot(dados_tempos, aes(x = Tempo_Extincao, fill = Regime)) +
  geom_histogram(alpha = 0.7, bins = 50) +
  facet_wrap(~Regime, scales = "free") +
  labs(title = "Distribuição do Tempo até Extinção",
       x = "Tempo até Extinção (Gerações)",
       y = "Frequência") +
  theme_minimal() +
  theme(legend.position = "none")
