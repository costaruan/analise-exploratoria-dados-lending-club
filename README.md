# Análise Exploratória de Dados - Lending Club

[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=FFFFFF)](https://www.linkedin.com/in/costaruan/)
[![Udacity](https://img.shields.io/badge/Udacity-01B3E3?style=for-the-badge&logo=udacity&logoColor=FFFFFF)](https://graduation.udacity.com/confirm/3DPA9HFU/)

[![Repo size](https://img.shields.io/github/repo-size/costaruan/analise-exploratoria-dados-lending-club)](https://github.com/costaruan/analise-exploratoria-dados-lending-club/)
[![Languages](https://img.shields.io/github/languages/count/costaruan/analise-exploratoria-dados-lending-club)](https://github.com/costaruan/analise-exploratoria-dados-lending-club/)
[![License](https://img.shields.io/github/license/costaruan/analise-exploratoria-dados-lending-club)](https://github.com/costaruan/analise-exploratoria-dados-lending-club/blob/master/LICENSE.md)
[![Made by costaruan](https://img.shields.io/badge/made%20by-costaruan-green)](https://github.com/costaruan/analise-exploratoria-dados-lending-club/)

![Lending Club](./assets/images/logo/lending-club.png)

A Análise Exploratória de Dados é a análise numérica e visual das características dos dados e seus relacionamentos utilizando métodos formais e estratégias estatísticas. Possuindo a capacidade de nos conduzir a novas perguntas e, eventualmente, a modelos preditivos, sendo uma importante "linha de defesa" contra dados ruins e uma oportunidade de comprovar se determinadas suposições ou intuições sobre um conjunto de dados estão corretas.

## Introdução

A Lending Club é uma empresa de empréstimos peer-to-peer dos EUA, sediada em São Francisco, Califórnia. Foi o primeiro credor peer-to-peer a registrar suas ofertas como títulos na Securities and Exchange Commission (SEC) e a oferecer operações de empréstimo em um mercado secundário. A Lending Club opera em uma plataforma de empréstimo on-line que permite que os tomadores de empréstimos obtenham um empréstimo e que os investidores comprem títulos garantidos pelos pagamentos. A Lending Club é a maior plataforma de empréstimo peer-to-peer do mundo, reduzindo custos e fazendo empréstimos para indivíduos com análise avançada de dados. A função das empresas peer-to-peer é combinar pessoas que têm dinheiro com pessoas que necessitam de dinheiro. Como líder nesse setor, a Lending Club concluiu sua oferta pública inicial em dezembro de 2014, o que melhorou significativamente a confiança do público nessa empresa em rápido crescimento.

Neste projeto, vamos explorar os dados publicados pela Lending Club e tentar descobrir algumas ideias valiosas e inspiradoras.

## Visão geral

Neste projeto, será utilizada a linguagem de programação R e a aplicação de técnicas de análise exploratória de dados para verificar as relações em uma ou mais variáveis e explorar um conjunto de dados específico para encontrar distribuições, outliers e anomalias.

## O que é preciso instalar?

Para completar este projeto, você precisará do R. Você pode fazer o download e instalar o R a partir do [Comprehensive R Archive Network (CRAN)](http://cran.r-project.org/).

Após instalar o R, você precisará fazer o download e instalar o [R Studio](http://www.rstudio.com/products/rstudio/download/). Escolha a instalação apropriada de acordo com o seu sistema operacional.

Por fim, você precisará instalar alguns pacotes. Recomenda-se abrir o R Studio e instalar os seguintes pacotes usando a linha de comando:

``` R
library(dplyr)
library(ggmap)
library(ggplot2)
library(gridExtra)
library(maps)
library(mapdata)
library(reshape2)
library(stringr)
library(treemap)
```

Para mais instruções sobre como instalar pacotes R, veja a publicação [Installing R Packages](http://www.r-bloggers.com/installing-r-packages/) na página [R-bloggers](https://www.r-bloggers.com/).

## O que vou aprender?

Ao completar este projeto, você irá:

- Entender a distribuição de uma variável e como verificar a existência de anomalias e outliers;

- Aprender como quantificar e visualizar variáveis de um conjunto de dados usando os gráficos apropriados, como histogramas, gráficos de dispersão, gráficos de barra e box-plots;

- Explorar as variáveis para identificar quais são as mais importantes e os seus relacionamentos dentro de um conjunto de dados, antes de construir um modelo preditivo;

- Calcular correlações e conduzir investigações condicionais;

- Aprender métodos poderosos e visualizações para examinar o relacionamento entre múltiplas variáveis, como a reformatação de tabelas e o uso de cores e formas para descobrir ainda mais informações.

## Conjunto de dados

Lending Club - Empréstimos Peer-to-Peer e Investimento Alternativo

### Descrição dos dados

O conjunto de dados da Lending Club contêm informações completas para todos os empréstimos emitidos entre o período de 2007 até 2015, incluindo o status atual dos empréstimos e as informações mais recentes sobre pagamentos. Os recursos adicionais incluem pontuação de crédito, número de consultas financeiras, endereço, incluindo CEPs, estados, entre outros.

**O arquivo é uma matriz com cerca de 890 mil observações e 74 variáveis. O tamanho deste conjunto de dados é de aproximadamente 421MB.**

---

**Created by** [`costaruan`](https://costaruan.dev/)
