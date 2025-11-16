set.seed(114514)
library(data.table)
simulação_poisson <- simular("poisson", 1.2, NULL, 1, 1000)

dados1 <- simulação_poisson$df
a_hisitoria <- simulação_poisson$historias
print(dados1)

dados1$Extincao

dados1$Tempo_Extincao
hist(dados1$Tempo_Extincao)
dados1[1]
str(dados1)

summary(dados1)

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


# generate data and visualize
data <- data.table(t = 1:index, 
                   replicate(FUN_branch(index), n = nsims))
data <- melt(data, id.vars = "t")
plot <- ggplot(data, aes(x = t, y = value, col = variable)) +
  geom_line(alpha = 1 / 4) +
  theme_bw() +
  theme(legend.position = "none") +
  ggtitle("Simple Branching Process") +
  xlab("t") + ylab("size of population")
