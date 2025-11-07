## Bot de Discord com Elixir

### 1. Tecnologias Utilizadas

• Linguagem: Elixir

• Biblioteca Discord: Nostrum

• Cliente HTTP: HTTPoison

• Parsing JSON: Jason

---

### 2. Descrição dos Comandos Desenvolvidos

Abaixo está o detalhamento de cada um dos 5 comandos implementados.

#### 2.1. Comando: !santododia

• Descrição: Busca a celebração litúrgica (santo do dia) e a cor litúrgica do calendário católico romano para o dia atual.

• Parâmetros: Nenhum (0 parâmetros).

• API Utilizada: Catholic Calendar API (calapi.inadiutorium.cz).

• Exemplo de Resposta:
Hoje celebramos: Friday, 31st week in Ordinary Time. Cor litúrgica: Verde.

#### 2.2. Comando: !crypto

• Descrição: Busca o preço atual de uma criptomoeda em Dólares (USD), formatando o valor com separadores de milhar e duas casas decimais.

• Parâmetros: 1 parâmetro (o ID da moeda, ex: bitcoin, ethereum).

• API Utilizada: CoinCap API V2 (api.coincap.io).

• Exemplo de Comando: !crypto bitcoin

• Exemplo de Resposta:
BTC: $ 102469.20 USD

#### 2.3. Comando: !encurtar

• Descrição: Envia uma URL longa para a API CleanURI e retorna uma URL encurtada.

• Parâmetros: 1 parâmetro (a URL longa a ser encurtada).

• API Utilizada: CleanURI (cleanuri.com).

• Exemplo de Comando: !encurtar https://pt.wikipedia.org/wiki/Elixir_(linguagem_de_programação)

• Exemplo de Resposta:
URL encurtdada: https://cleanuri.com/7d0EL9

#### 2.4. Comando: !lol

• Descrição: Busca o nível de um invocador (jogador) de League of Legends em uma região específica. Este comando demonstra o uso de autenticação via HTTP Headers, enviando a API Key da Riot no cabeçalho X-Riot-Token.

• Parâmetros: 2 parâmetros (a região, ex: br1, na1, e o nome do invocador).

• API Utilizada: Riot Games API (developer.riotgames.com).

• Exemplo de Comando: !lol br1 Kyohisuru#kyo

• Exemplo de Resposta:
🎮 Invocador: Kyohisuru#KYO (BR1) está no Nível 128.

#### 2.5. Comando: !poema

• Descrição: Busca um poema clássico (majoritariamente da língua inglesa) pelo nome do autor e título. Os parâmetros são separados por um ponto e vírgula (;) para permitir que autores e títulos contenham espaços.

• Parâmetros: 2 parâmetros (Autor; Título).

• API Utilizada: PoetryDB (poetrydb.org).

• Exemplo de Comando: !poema Shakespeare; Sonnet 18

• Exemplo de Resposta:
📖 Sonnet 18 por William Shakespeare
Shall I compare thee to a summer's day? Thou art more lovely and more temperate: ...

• Observação de Implementação: O comando falha silenciosamente (não responde) caso o poema retornado pela API seja muito longo (ex: !poema Poe; The Raven), pois a resposta excede o limite de 2.000 caracteres por mensagem da API do Discord.

Link de demonstração: https://www.youtube.com/watch?v=eYhx9NZVKjc&feature=youtu.be

Github: https://github.com/LuisEduardo100/bot-discord
