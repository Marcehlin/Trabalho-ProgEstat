#Lara Fernandes Andreu Guillo
#Marcelo Xinhong Huang
processo_de_ramificacao <- function(dist, p1, p2, G_0 = 1,fp = NULL){
  #abaixo é uma variável que armazena os dados que estamos interessados em um processo de ramificação
  #Extinção é booleana, 0 se o processo não extinto, 1 caso contrário
  #Tempo de Extinção: um numero inteiro que armazena o tempo de extinção do processo
  #Total do Processo: um numero inteiro que armazena o total de descendentes do processo
  #Historia: um vetor numerico que armazena a quantidade de filhos de cada geração, ou seja, os Z_i's
  resultado_processo <- list(Extincao = FALSE, Tempo_Extincao = NA, Total_do_Processo = 1, Historia = numeric())
  
  resultado_processo$Historia[1] <- G_0 # A familia começa com um Acestral
  k <- 1 #indice para iterar o processo

  #em vez de verificar o total, agora se verifica a ultima geração ultrapassa  1e6
  while (resultado_processo$Historia[k] > 0 && resultado_processo$Historia[k] < 1000000){
    if (dist == "poisson"){
      incremento <- rpois(resultado_processo$Historia[k], p1)
    }

    else if (dist == "binomial"){
      incremento <- rbinom(resultado_processo$Historia[k], size = p1, prob = p2)
    }
    else if (dist == "personalizada"){
      incremento <- sum(sample(size = resultado_processo$Historia[k],
                            x = fp$suporte,
                            p = fp$probabilidade,
                            replace = TRUE))
    }
    else
    {
      return(-1)
    }
    resultado_processo$Historia[k+1] <- sum(incremento)
    resultado_processo$Total_do_Processo <- resultado_processo$Total_do_Processo + resultado_processo$Historia[k+1]
    k <- k + 1
  }
  if (resultado_processo$Historia[k] == 0){
    resultado_processo$Extincao <- TRUE
    resultado_processo$Tempo_Extincao <- k - 1
  }
return (resultado_processo) #retornar a lista que tem os dados
}

teste = processo_de_ramificacao("poisson", p1 = 1.2, p2 = 0)
print(teste)


simular <- function(dist, p1, p2, G0, M, fp = NULL) {
    resultados <- list() #criar uma lista vazia para colocar resultado de cada simulação

    for (i in 1:M){
      resultados[[i]] <- processo_de_ramificacao(dist, p1, p2, G_0 = G0, fp)

      if (i %% 100 == 0) { #só pra ver o progresso
        cat("Simulação", i, "de", M, "\n")
      }
    }
    
    # extrair apenas as metricas numericas para o dataframe, porque se colocar a historia junto vai ficar pesado
    df <- data.frame(
      Extincao = sapply(resultados, function(x) x$Extincao),
      Tempo_Extincao = sapply(resultados, function(x) x$Tempo_Extincao),
      Total_do_Processo = sapply(resultados, function(x) x$Total_do_Processo)
    )
    
    # manter as histórias como lista separada
    historias <- lapply(resultados, function(x) x$Historia)
    
    return (list(df = df,historias = historias)) #retornar uma lista de 2 elementos, primeiro é o dataframe das metricas, segundo é o vetor
}
