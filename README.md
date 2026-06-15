# Instalar Homebrew

Este projeto existe para ajudar quem quer instalar o **Homebrew** de forma fácil.

O **Homebrew** é um gerenciador de pacotes. Na prática, ele facilita a instalação de ferramentas no computador usando comandos simples no terminal.

## O que este projeto faz

O script deste repositório:

- instala o Homebrew no `macOS` ou no `Linux`
- detecta automaticamente onde o `brew` foi instalado
- configura o terminal para reconhecer o comando `brew` nas p****róximas vezes que você abrir o terminal
- testa se a instalação funcionou

## Antes de começar

Você precisa:

- estar em um computador com `macOS` ou `Linux`
- ter acesso ao `Terminal`
- ter conexão com a internet

## Passo a passo

### 1. Abra o Terminal

No macOS:

- pressione `Command + Espaço`
- digite `Terminal`
- pressione `Enter`

No Linux:

- abra o aplicativo `Terminal` da sua distribuição

### 2. Execute o instalador direto no terminal

No terminal, rode:

```bash
curl -fsSL https://raw.githubusercontent.com/andersonpem/instalar-homebrew/master/homebrew.sh | bash
```

Esse comando:

- baixa o script deste projeto
- executa a instalação imediatamente

O script vai mostrar mensagens na tela enquanto trabalha.

### 3. Alternativa: baixar o projeto antes

Se preferir ver o arquivo antes de executar, você também pode baixar este repositório manualmente e depois rodar:

```bash
bash homebrew.sh
```

## O que pode acontecer durante a instalação

Em alguns casos, o sistema pode:

- pedir sua senha de usuário
- pedir confirmação para instalar dependências
- demorar alguns minutos

Isso é normal.

## Como saber se deu certo

No final, você pode testar com:

```bash
brew --version
```

Se aparecer a versão do Homebrew, a instalação funcionou.

Exemplo:

```bash
Homebrew 4.x.x
```

## Se o comando `brew` não funcionar

Feche o terminal, abra novamente e rode:

```bash
brew --version
```

O script já tenta configurar isso automaticamente nos arquivos:

- `~/.zshrc`
- `~/.bashrc`

## O que o script altera no seu computador

Este projeto:

- instala o Homebrew usando o instalador oficial
- adiciona uma pequena configuração ao seu terminal para ativar o `brew`

Ao usar o comando com `curl`, o script é executado diretamente a partir da internet.

Ele não substitui sua configuração inteira. Apenas adiciona um bloco identificado como:

```bash
# >>> homebrew setup >>>
# <<< homebrew setup <<<
```

## Problemas comuns

### O terminal diz que `curl` não existe

O script precisa do `curl` para baixar o instalador do Homebrew. Instale o `curl` e rode novamente.

### O script termina, mas `brew` ainda não existe

Abra uma nova janela do terminal e teste:

```bash
brew --version
```

Se ainda falhar, verifique se houve alguma mensagem de erro durante a instalação oficial do Homebrew.

## Para quem este projeto é indicado

Este projeto é útil para:

- iniciantes no terminal
- pessoas configurando um computador novo
- quem quer evitar lembrar os passos manuais de configuração do Homebrew

## Licença

Este projeto está licenciado sob a licença `AGPL-3.0`. Veja o arquivo [LICENSE](/Users/andy/repos/instalar-homebrew/LICENSE).
