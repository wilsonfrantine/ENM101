---
title: "Exercício 1 - carregando e limpando dados"
author: Dr. Wilson Frantine-Silva - UENF-RJ
---

*Por: Dr. Wilson Frantine-Silva - UENF-RJ*

# 0. Preparando pacotes
 **Caso essa seja a sua primeira vez utilizando esses pacotes, talvez seja necessário instalar alguns deles:** 
```{r}
  #Pacotes necessários
  package_list<-c("rgbif", "maptools")
  #instala pacotes se não estiverem instalados

for(i in package_list){
  if(!require(i, character.only = T)){
    
    install.packages(i, character=T) #realmente demora!
    install.packages("maptools")
  }else{
    
    library(i, character.only = T)
  }
}
```


# 1. Buscando e carregando dados
Primeiramente, vamos setar o diretório onde iremos trabalhar
```{r}
#setando diretório
setwd("/media/wilson/MIDGARD/Documents/AARE - MNE/Aula 4 - Load and Data Cleaning/")
```

Neste exerício vamos importar dados diretamente do Global Biodiversity Information Facility (gbif.org) através do pacote rgbif
```{r}
species <- "Euglossa annectans"
occs <- occ_search(scientificName = species, 
                   return = "data")
occs
```

Note que o objeto **"occs"** é um tipo complexo, constituído por cinco listas ou slots. Uma delas (**"data"**) é uma tabela especial chamada _tibble_ (Tyddiverse) que estoca dados e metadados e pode também ser coercida à dataframe.

## Checando o tamanho do dataset

Uma função básica para checar tabelas de dados é a função dim(). Ela retorna número de linhas e colunas em uma tabela / dataset.
```{r}
dim(occs$data)
```

Também podemos checar a lista de colunas no documento:
```{r}
head(colnames(occs$data)) #Padrão Darwin Core
#Note que utilizei aqui a função head() que retorna as primeiras 10 linhas da tabela. Caso queira ver todas, apenas remova o bloco colnames(occs$data) de dentro da função head().
```

### Salvando dados originais
Documentar todos os passos é fundamental. 
Neste ponto, salvar os dados originais é mandatório.

As próximas linhas de código, primeiro criam a pasta _"data"_ (caso ela não exista) e em seguida salvam os dados 'occs$data' como arquivo csv:

```{r}
dir.create("data")
write.csv(occs$data, 
          "data/raw_data.csv", 
          row.names = FALSE)

```

# 2. Checando dados da espécie
Uma vez que temos os dados brutos, um passo importante é checar a consistência do nome específico. 

Primeiro vamos checar quantos nomes científicos foram importados. Note que a função unique() retorna todos os nomes únicos para a coluna indicada:

```{r}
sort(unique(occs$data$scientificName))
```
**Neste caso, temos apenas um nome, então estamos bem para prosseguir.**

Também podemos checar outros campos do banco de dados:
```{r}
sort(unique(occs$data$species))
sort(unique(occs$data$speciesKey))
```
Veja que para os dois comandos, foram retornados dados únicos. Assim, podemos seguir sem precisar consolidar esses dados.

**Embora simples esse passos são fundamentais e pode interferir em toda modelagem. Gaste o tempo que for necessário aqui para confirmar se a espécie está corretamente anotada.**

**Dica importante: caso note que é necessário alterar algo em relação ao nome da espécie, nunca faça isso no objeto original, crie um objeto novo, algo como:**

`dados<-occs$data`

Em seguida edite faça as alterações sobre o objeto `dados`

# 3. Checando coordenadas

Uma vez que definimos que não há problemas com a espécie, podemos seguir adiante.

Vamos primeiro plotar a latitude e longitude para observar seu padrão:

```{r}
plot(decimalLatitude ~ decimalLongitude, data = occs$data)

```
Observe que como temos várias ocorrências sobrepostas entre -20S e -35W. Essas sobreposições são certamente duplicatas e precisaremos remove-las. Do mesmo modo, temos outlyers próximo à `0` graus de latitude e longitude, além de um dado entre -50S e -25W. Certamente esses dados são erros e precisaremos corrigí-los.

### Primero checaremos a unicidade dos dados...

Para esse exercício não precisaremos de redundância, portanto trabalharemos apenas com registros únicos, que não se repetem tampouco em Lat ou Long.

Aplicaremos a função "levels" que retorna os níveis (elementos únicos) dos fatores (variável categórica). A função "as.factor" transforma em fator (categorias) o parâmetro que é passado, neste caso, os dados da coluna `decimalLatitude`

```{r}
levels(as.factor(occs$data$decimalLatitude))
```
Fazemos o mesmo para longitude
```{r}
levels(as.factor(occs$data$decimalLongitude))
```
Aqui fica claro que temos alguns dados imprecisos (-55 em Long ou -26 em Lat) e alguns que foram erroneamente setados como 0.

**Note ainda que, embora temos checado os dados, ainda não os alteramos de forma direta, faremos isso a partir de agora**

### Corrigindo os dados

Primeiramente, removeremos os valores tidos como não disponíveis, ou NA.
```{r}
occs.coord <- occs$data[!is.na(occs$data$decimalLatitude) 
                   & !is.na(occs$data$decimalLongitude),]

head(occs.coord)

print(paste("com NA:", nrow(occs$data))) #com NA
print(paste("sem NA:", nrow(occs.coord))) #sem NA

```

Após remover os `NA`, podemos salvar os dados em um novo objeto (chamado aqui "gbif") que será um dataframe com três colunas:
`species`, `decimalLongitude` e `decimalLatitude`. Note que a ordem desses campos é importate. Devem corresponder à *nome da espécie*, *valor para o eixo X* e *valor para o eixo Y*
   + PS: _alterei a ordem dos campos em relação à aula, agora estão como deveriam estar_
   
**Note que aqui não utilizaremos os dados adicionais da tabela, por isso nos damos ao luxo de descartar as demais.**

```{r}
#Criando uma tabela nova apenas com spp, long e lat.
gbif<-data.frame("species" = occs.coord$species,
                 "decimalLongitude" = occs.coord$decimalLongitude,
                  "decimalLatitude" = occs.coord$decimalLatitude
                 )
head(gbif) #primeiras 10 linhas
tail(gbif) #últimas 10 linhas
```

Há formas alternativas de visualizar os dados no Rstudio:

```{r}
#vizualizando os dados no Rstudio
View(gbif)
```

Podemos contar os registros:
```{r}
#contando quantas linhas há na tabela gbif
nrow(gbif)
```

E quantos restaram após remover os dados não disponíveis:
```{r}
#Numero de linhas no dado original
nrow(occs$data)
#Original menos o modificado
nrow(occs$data)-nrow(gbif)
```

Podemos novamente visualizar as latitudes.
```{r}
#Visual checking
plot(gbif$decimalLongitude)
plot(gbif$decimalLatitude)
```
Plots de Latitude e longitude. Note que estes plots são diferentes daqueles onde plotamos Latitude contra longitude. Aqui podemos ver a repetição dos valores (em Y) ao longo dos registros (em X).

#### Checando os dados no mapa:
As próximas linhas de código vão importar os dados de vetor do pacote `maptools` de um conjunto chamado `wrld_simpl` que possue as fronteiras dos países do mundo.

```{r}
#data from maptools
data("wrld_simpl")
```

Em seguida, plotamos o mapa.
```{r}
#plotando o mapa
plot(wrld_simpl, xlim=c(-90, 90), ylim=c(-60,60), axes=T, col='olivedrab3',bg='lightblue')
#Para aproximar o plot mude xlim para: xlim=c(-60, -55)
#                           ylim para: ylim=c(-40,-15)
points(gbif[ ,c(2,3)], col="#FF0000")
#Note que em pontos, as colunas 2, 3 devem representar Long e Lat, nessa ordem. Vídeo possui ordem desses fatores trocada.
```
Este plot gera a distribuição dos pontos de coleta sobre o sul do Brasil. Note que é possível mudar o intervalo de plot alterando os parâmetros `xlim` e `ylim`

### Remover os pontos com valor zero ou fora do "range"

As linhas a seguir executam uma série de códigos para manter os pontos entre -40 e -18 de Lat(Sul e Norte) e -40 e -60 Long (Leste - Oeste) 

```{r}
#Mantendo dados diferentes de 0 em lat e long
gbif <- gbif[gbif$decimalLatitude != 0 & gbif$decimalLongitude != 0, ]

#Mantendo registros em Lat maior que -40S **ou** maior q long -40W
gbif <- gbif[gbif$decimalLatitude > -40 | gbif$decimalLongitude > -40, ]

#Mantendo dados menores que -18S **ou** -60W
gbif <- gbif[gbif$decimalLatitude < -18 | gbif$decimalLongitude < -60, ]

#Mantendo valores diferentes de valores específicos 
gbif <- gbif[gbif$decimalLatitude != 55.000 -18 & gbif$decimalLongitude != -26.00000, ]

```

Podemos agora, plotar os pontos apenas para ver sua distribuição:

```{r}
#checking again
plot(gbif$decimalLongitude)
plot(gbif$decimalLatitude)

```
Note aqui que plotamos tanto latitude quanto longitude no eixo `Y` de seus respectivos gráficos, enquanto seus registros ou linhas da tabela são representados em `X`. Logo, cada ponto em `x` corresponde à uma linha e cada valor correspondente em `y` uma latitude ou longitude, respectivamente no primeiro e segundo gráfico de saída. Repare em como os dados se repetem. É necessário remover as duplicatas.


### Removendo duplicatas

Remover duplicatas no R é fácil. Basta usar a função nativa `unique`. Essa função retarna apenas valores únicos, ou seja, que não possuem a mesma combinação de campos (`species | decimalLongitude | decimalLatitude`). Lembre-se de executar essa função em um objeto novo para não sobrescrever nada.

```{r}
gbif.unique <- unique(gbif)
gbif.unique

```

Plotando no mapa novamente
```{r}
plot(wrld_simpl, xlim=c(-60, -55), ylim=c(-40,-15), axes=T, col='olivedrab3',bg='lightblue')
points(gbif.unique[ ,c(2,3)], col="#FF0000")#lembre-se, pontos devem ser long e lat, nessa ordem. Ou seja, as colunas em gbif.unique devem ser "species", "decimalLong", "decimalLat".

```

#Salvando os dados trabalhados

Uma vez que os dados foram corrigidos, podemos salvá-los como entrada para os algoritmos de modelagem.

```{r}
#Creating an input for modelling
input <- gbif.unique

#saving the input table
write.table(input, "input.coordinates.txt", quote=F, row.names=F, sep = "\t")

```

#Verificando se os dados foram salvos:

Vamos agora importar os dados para checar se foram salvos corretamente:

```{r}
input.test <- read.csv("input.coordinates.txt", header = T, sep = "\t")
head(input.test)

nrow(input.test)
plot(input.test[,2:3])

```
![Se tudo correu bem, o gráfico deve ser como o da figura, mostrando como as ocorrências se distribuem em lat e long]


Como ultima checagem, podemos olhar as ocorrências importadas em um mapa:

```{r}
plot(wrld_simpl, xlim=c(-60, -55), ylim=c(-40,-15), axes=T, col='olivedrab3',bg='lightblue')
points(input.test[ ,c(2,3)], col="#FF0000")#lembre-se, pontos devem ser long e lat, nessa ordem. Ou seja, as colunas em gbif.unique devem ser "species", "decimalLong", "decimalLat".


```
*Pontos plotados sobre o mapa cobrindo a porção sul da Mata Altântica.*

Espero que tenha aproveitado o tutorial. Vimos um pouco sobre como os erros dos bancos de dados podem "sujar" nossas análises, e que esses podem estar incompletos. Em breve veremos como aglutinar dados de diferentes bancos de dados para as análises.

Bons estudos!

*Prof. Dr. Wilson Frantine-Silva - UENF-RJ*

*email: wilsonfrantine@gmail.com*
