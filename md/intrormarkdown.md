---
title: "R markdown: comandos básicos"
author: "Dr. Wilson Frantine-Silva"
---

# R Markdown - Visão geral {#topico1}

Markdown é uma sintaxe de formatação simples para a criação de documentos HTML, PDF e MS Word. Para obter mais detalhes sobre o uso do R Markdown, visite <http://rmarkdown.rstudio.com>.

No Rstudio, vá em "file -> new file -> R markdown" e clique em `OK`. Ao clicar no botão **Knit** na parte superior dessa nova janela, um documento é gerado (geralmente HTML - página web), incluindo tanto o conteúdo quanto a saída de qualquer fragmento de código R embutido no documento.  

# Tabela de Conteúdo {#m1}

* [Tabela de Conteúdo](#m1)
  * [Inserindo blocos de código](#t1)
  * [Incluindo Plots](#t2)
* [Sintáxe básica e Elementos](#m2)
  * [Cabeçalho ou Tópicos](#t3)
  * [Outros elementos e Formatações](#t4)
    * [Inserindo imagens](#t5)
    * [Blocos de citação](#t6)
    * [Notas de rodapé e links internos](#t7)
      + [links para a mesma página](#s0)
    * [Listas](#t8)
      + [Listas não ordenadas](#s1)
      + [Listas listas ordenadas](#s2)
      + [Listas de tarefas](#s3)
   * [Tabelas](#t9)
  
## Inserindo bloco de código {#t1}

Você pode incorporar um fragmento de código R como este:  

```{r}
summary(cars)
```

## Incluindo Plots {#t2}

Você também pode incorporar gráficos, por exemplo:  

```{r pressure, echo=FALSE}
plot(pressure)
```

Observe que o parâmetro `echo = FALSE` foi adicionado ao fragmento de código para evitar a impressão do código R que gerou o gráfico.

# Sintaxe básica do R Markdown {#m2}

Texto normal  
Termine uma linha com dois espaços ou dois "enter" para iniciar um novo parágrafo.  

 
Elemento | Código | Saída  
-------- | ------ | ------  
Itálico | `*itálico* ou _itálico_` | *itálico* ou _itálico_  
Negrito | `**negrito** ou __negrito__` | `**negrito** ou __negrito__`  
Texto Tachado | `~~texto taxado~~` | ~~texto taxado~~  
sobrescrito | ` m^2^` |  m^2^  
subescrito | ` H~2~O  ` |  H~2~O  
  
`[link Rstudio](www.rstudio.com)` | [link Rstudio](www.rstudio.com)  

## Cabeçalhos ou Tópicos  {#t3}

```{r}
# Nível 1 
## Nível 2  
### Nível 3  
#### Nível 4  
##### Níve 5  
###### Nível 6  
```

# Nível 1 
## Nível 2  
### Nível 3  
#### Nível 4  
##### Níve 5  
###### Nível 6  

## Outras Formatações {#t4}

Elemento | Código | Saída  
-------- | ------ | -----------------------
traço | ` -- ` | --  
travesão | ` ---` | ---  
reticências | ` ...` | ...  
equação | ` $A = \pi*r^{2}$` | $A = \pi*r^{2}$ 

### Inserindo imagem: {#t5}  
Código:  
```{markdown}
![](RStudio-Ball.png){width=5%}
```
imagem:  
![text alt for the image](RStudio-Ball.png){width=5%}  

### Bloco de citação {#t6}
Código:  
```
> Este é um bloco que citação útil para citações diretas e observações
```
Renderização:  
> Este é um bloco que citação útil para citações diretas e observações

### Notas de rodapé e liks para o documento {#t7}

```
[^1]: Essa é uma sentença com nota de rodapé.
```
Essa é uma sentença com nota de rodapé.[^1]    

#### link para um documento {#s0}

```
#link a ser marcado
[Esse é o título](#ancora1)
#Esse é o link
[qualquer texto para clicar e voltar](#ancora1)
```

Você também pode criar links para sessões, como por exemplo para o primeiro tópico, [R markdown](#topico1)

### Listas {#t8}  

#### Lista não ordenada {#s1} 
```
* item
* item 2
  + sub-item 1
  + sub-item 2
```

* item
* item 2
  + sub-item 1
  + sub-item 2

#### Lista ordenada {#s2} 
```
1. item 1
2. item 2
    1. sub-item 1
    2. sub-item 2 

```

1. item 1
2. item 2
    1. sub-item 1
    2. sub-item 2 
    
    
#### Lista de tarefas {#s3}
```
- [x] Escrever o exercício
- [ ] Atualizar o site
- [ ] Salvar o vídeo

```
- [x] Escrever o exercício
- [ ] Atualizar o site
- [ ] Salvar o vídeo

### Tabelas {#t9}  
Código  
```
Campo 1 | Campo 2  
------------- | -------------
célula 1 | célula 2
célula 3 | célula 4
```
Saída:  

Campo 1 | Campo 2  
------------- | -------------
célula 1 | célula 2
célula 3 | célula 4  



---------
**Notas de rodapé: **

[^1]: Essa é a referência àquela nota de rodapé.
