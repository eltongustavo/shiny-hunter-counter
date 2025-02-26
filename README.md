
# Shiny Hunt Counter

## Descrição

O Shiny Hunt Counter é um aplicativo para rastrear e gerenciar a contagem de encontros em caçadas de Pokémon Shiny. Ele também funciona como uma biblioteca de Shinies capturados, permitindo que os usuários registrem e visualizem os Pokémon que foram capturados durante suas aventuras.

O app foi desenvolvido para dispositivos Android com um design minimalista inspirado na Pokédex, mas com cores um pouco mais escuras e um estilo de terminal preto. O aplicativo possui funcionalidade offline para as funções principais.
## Funcionalidades

- **Contador de Encontros:** Registra o número de encontros feitos em cada hunt.
- **Biblioteca de Shinies:** Exibe todos os Shinies capturados pelo usuário, com sprites de Pokémon e informações associadas.
- **Offline:** Funciona de maneira totalmente offline para o gerenciamento dos encontros e a visualização da biblioteca.
- **Design Minimalista:** Inspirado na Pokédex, com um tema escuro estilo terminal.

## Obtendo o Aplicativo
- **Download:** As versões do aplicativo serão disponibilizadas no Release do repositório.

## Tecnologias Utilizadas

- **Flutter**: Framework de desenvolvimento para o aplicativo mobile.
- **SQLite**: Banco de dados local para persistência dos dados de hunts e biblioteca de Shinies.
- **Dart**: Linguagem de programação utilizada para o desenvolvimento do app.

## Estrutura do Projeto

O projeto é composto pelas seguintes principais funcionalidades:

- **Banco de Dados (SQLite):**
  - Tabela de *Shiny Hunts* para registrar as caçadas, com ID do Pokémon, número de encontros e índice do Pokémon capturado.
  - Funções para inserir, atualizar e recuperar dados das hunts.
  
- **Interface de Usuário (UI):**
  - Tela inicial com a lista de hunts em andamento.
  - Tela de biblioteca para visualizar os Shinies capturados.
  - Formulário de adição de novos Pokémon e novas hunts.
  
- **Persistência de Dados:**
  - Utiliza SQLite para manter os dados de hunts e Shinies de maneira persistente, mesmo após o fechamento do aplicativo.

## Contribuindo

Contribuições são bem-vindas! Se você tem uma melhoria ou correção de bug, siga as etapas abaixo para contribuir:

1. Fork o repositório.
2. Crie uma nova branch para sua feature ou correção.
3. Faça suas mudanças e adicione testes se necessário.
4. Envie um pull request com a descrição das mudanças.

## Licença

Este projeto está licenciado sob a [Licença MIT](LICENSE).
