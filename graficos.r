library(dplyr)
library(ggplot2)
library(data.table)
library(ggpmisc)

freq <- sapply(resultados_simulacoes, function(x) sum(x$df$Extincao))
prob_extincao <- sapply(resultados_simulacoes, function(x) mean(x$df$Extincao))

#tempo_medio_extincao para cada regime que fizemos simulações
tempo_medio_extincao <- sapply(resultados_simulacoes, function(x) {
  tempos <- x$df$Tempo_Extincao
  tempos <- tempos[is.finite(tempos)]
  return (mean(tempos))
})

tempo_medio_extincao <- sapply(resultados_simulacoes, function(x) {
  tempos <- x$df$Tempo_Extincao
  tempos <- tempos[is.finite(tempos)]
  return (mean(tempos))
})

tempo_max_extincao <- sapply(resultados_simulacoes, function(x) {
  tempos <- x$df$Tempo_Extincao
  tempos <- tempos[is.finite(tempos)]
  return (max(tempos))
})

mediana_tempo_extincao <- sapply(resultados_simulacoes, function(x) {
  tempos <- x$df$Tempo_Extincao
  tempos <- tempos[is.finite(tempos)]
  return (median(tempos))
})

#metricas em um dataframe, para fazer plot_01 e plot02
metricas <- data.frame(
  Regimes = names(regimes),
  Frequencia_absoluta = freq,
  Prob_Extincao = prob_extincao,
  Tempo_Medio_Extincao = tempo_medio_extincao,
  Tempo_max_Extincao = tempo_max_extincao,
  Mediana_Tempo_Extincao = mediana_tempo_extincao
)

tabela_dados_de_interesse <- ggplot() +
  geom_table(
    data = metricas,
    aes(x = 0, y = 0, label = list(metricas)),
    size = 4
  ) +
  theme_void() +
  ggtitle("Métricas dos Processos de Ramificação")
print(tabela_dados_de_interesse)
#metricas em uma dataframe, para fazer plot_03
dados_tempos <- data.frame()
for (nome in names(resultados_simulacoes)) {
  tempos <- resultados_simulacoes[[nome]]$df$Tempo_Extincao
  # Filtrar apenas os tempos finitos (onde houve extinção)
  tempos_finite <- tempos[is.finite(tempos)]
  if (length(tempos_finite) > 0) {
    dados_tempos <- rbind(dados_tempos, 
                         data.frame(Regime = nome, Tempo_Extincao = tempos_finite))
  }
}
#dados_tempos <- sapply(resultados_simulacoes, function(x) {
#  tempos <- x$df$Tempo_Extincao
#  tempos <- tempos[is.finite(tempos)]
#  return (tempos)
#})

#Gráfico 1: que mostra as frequências relativas vulgo as probabilidades de extinção por regime estabelecido
plot_01 <- ggplot(metricas, aes(x = Regime, y = Prob_Extincao, fill = Regime)) +
  geom_col(alpha = 0.9) + #transparência nas barras
  geom_text(aes(label = sprintf("%.3f", Prob_Extincao)), vjust = -0.5) +
  labs(title = "Probabilidade de Extinção por Regime",
       x = "Regimes", 
       y = "Probabilidade de Extinção") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 30, hjust = 1))
print(plot_01)

#Gráfico 2: que mostra as médios de tempo de extinção por regime estabelecido, considerando apenas processos
plot_02 <- ggplot(metricas, aes(x = Regime, y = tempo_medio_extincao, fill = Regime)) +
  geom_col(alpha = 0.9) +
  geom_text(aes(label = sprintf("%.2f", tempo_medio_extincao)), vjust = -0.5) +
  labs(title = "Tempo Médio de Extinção por Regime",
       x = "Regimes", 
       y = "Tempo Médio de Extinção por Regime") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 30, hjust = 1))
print(plot_02)

# Gráfico 3: que mostra a distribuição do tempo de extinção para cada regime (apenas para as extintas)
plot_03 <- ggplot(dados_tempos, aes(x = Tempo_Extincao, fill = Regime)) +
  geom_histogram(alpha = 0.9, bins = 20) +
  facet_wrap(~Regime, scales = "free") +
  labs(title = "Distribuição do Tempo até Extinção",
       x = "Tempo até Extinção (Gerações)",
       y = "Frequência") +
  theme_minimal() +
  theme(legend.position = "none",
        axis.text.x = element_text(angle = 0, hjust = 1))
print(plot_03)

#uma lista de gráficos das trajetórias dos processos:
trajetorias <- list()

for (nome in names(regimes)) {
  historias <- resultados_simulacoes[[nome]]$historias
  n_trajetorias <- min(1000, length(historias))
  max_tamanho <- max(sapply(historias[1:n_trajetorias], length))

  # Converter a lista para data.table no formato adequado
  data <- rbindlist(

    lapply(1:n_trajetorias, function(i) {
      trajetoria <- historias[[i]]
  # se o processo extinguiu, estender a trajetória com zeros até max_length
  if (resultados_simulacoes[[nome]]$df$Extincao[i]) {
    trajetoria_completa <- c(trajetoria, rep(0, max_tamanho - length(trajetoria)))
  }
  # se não extinguiu, preencher com NA
  else {
    trajetoria_completa <- c(trajetoria, rep(NA, max_tamanho - length(trajetoria)))
  }
  data.table(
    t = 1:max_tamanho,
    value = trajetoria_completa,
    variable = paste0("sim", i)
      )
    })

  )
  # criar os gráficos (usando código desse blog: https://bookdown.org/probability/bookdown-demo/branching-processes.html)
  trajetorias[[nome]] <- ggplot(data, aes(x = t, y = value, col = variable)) +
    geom_line(alpha = 0.6) +
    theme_bw() +
    theme(legend.position = "none") +
    ggtitle(paste("Processo de Ramificação - ", nome)) +
    xlab("Tempo") + 
    ylab("Tamanho da população no tempo i (Z_i)")
}

print(trajetorias[["subcritico_poisson"]])
print(trajetorias[["critico_poisson"]])
print(trajetorias[["supercritico_1_2_poisson"]])
print(trajetorias[["supercritico_2_0_poisson"]])
print(trajetorias[["subcritico_binom"]])
print(trajetorias[["critico_binom"]])
print(trajetorias[["supercritico_1_2_binom"]])
print(trajetorias[["supercritico_2_0_binom"]])
print(trajetorias[["dist_personalizada_1"]])
print(trajetorias[["dist_personalizada_2"]])
print(trajetorias[["dist_personalizada_3"]])
