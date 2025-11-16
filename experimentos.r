# configurações dos experimentos
set.seed(114514)
M <- 100

#uma lista de regime, para cada regime faremos M simulações
regimes <- list(
  subcritico_poisson = list(dist = "poisson", p1 = 0.8, p2 = NULL), # m = 0.8
  critico_poisson = list(dist = "poisson", p1 = 1.0, p2 = NULL), # m = 0.8
  supercritico_1_2_poisson = list(dist = "poisson", p1 = 1.2, p2 = NULL), # m = 0.8
  supercritico_2_0_poisson = list(dist = "poisson", p1 = 2.0, p2 = NULL), # m = 0.8

  subcritico_binom = list(dist = "binomial", p1 = 2, p2 = 0.3), # m = 0.6
  critico_binom = list(dist = "binomial", p1 = 2, p2 = 0.5), # m = 1
  supercritico_1_2_binom = list(dist = "binomial", p1 = 2, p2 = 0.6), # m = 1.2
  supercritico_2_0_binom = list(dist = "binomial", p1 = 4, p2 = 0.5), # m = 2

  dist_personalizada_1 = list(dist = "personalizada",p1 = NULL, p2 = NULL, G_0 = 1, fp = list(suporte = 0:2, probabilidade = c(0.5, 0, 0.5))), # m = 1
  dist_personalizada_2 = list(dist = "personalizada",p1 = NULL, p2 = NULL, G_0 = 1, fp = list(suporte = 0:3, probabilidade = c(0.3, 0.2, 0.3, 0.2))) # m = 1.2
)

resultados_simulacoes <- list()

for (nome in names(regimes)) {
  cat("Simulando:", nome, "\n")
  config <- regimes[[nome]]
  resultados_simulacoes[[nome]] <- simular(dist = config$dist, p1 = config$p1, p2 = config$p2, G0 = 1, M = M, fp = config$fp)
}