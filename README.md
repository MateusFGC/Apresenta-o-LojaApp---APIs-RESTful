# 📱 LojaApp — Consumo de APIs RESTful no Flutter

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![HTTP](https://img.shields.io/badge/API-RESTful-green?style=for-the-badge)

Projeto desenvolvido para a disciplina de Desenvolvimento Mobile no curso de **Análise e Desenvolvimento de Sistemas (ADS)**.

O objetivo deste projeto é substituir a lista estática do **LojaApp** pelo consumo dinâmico e assíncrono de uma API RESTful externa, garantindo fluidez na interface sem travamentos de tela (*UI non-blocking*).

---

## 🎯 Problema Resolvido

No modelo inicial, o catálogo de produtos era uma lista *hardcoded* (fixa no código). Em um ambiente real de produção:
1. Os dados residem em servidores remotos.
2. A latência da rede é imprevisível.
3. A interface não pode congelar esperando a resposta do servidor.

**Solução adotada:** Implementação de chamadas assíncronas utilizando `Future`, `async/await`, o pacote `http` e componentes reativos (`FutureBuilder`), tratando cenários de carregamento, falhas de conexão e sucesso de requisição.

---

## 🛠️ Tecnologias e Recursos

- **Linguagem:** [Dart](https://dart.dev/)
- **Framework:** [Flutter](https://flutter.dev/)
- **Pacote HTTP:** [http](https://pub.dev/packages/http)
- **API Pública Consumida:** [FakeStoreAPI](https://fakestoreapi.com/) (`GET /products`)

---

## 🏗️ Estrutura do Projeto

O código foi desacoplado seguindo o princípio da responsabilidade única:

```text
loja_app_api/
├── android/
│   └── app/src/main/AndroidManifest.xml   # Permissão de internet declarada
├── lib/
│   ├── models/
│   │   └── produto.dart                   # Modelo de dados e conversão JSON (factory)
│   ├── services/
│   │   └── produto_service.dart           # Camada de requisição HTTP e regras de erro
│   └── main.dart                          # Interface de catálogo e manipulação de estado
├── pubspec.yaml                           # Dependências do projeto
└── README.md                              # Documentação
```

---

## ⚙️ Pré-requisitos

Antes de iniciar, certifique-se de ter instalado em sua máquina:
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (versão `>= 3.0.0`)
- [Dart SDK](https://dart.dev/get-dart)
- Emulador Android/iOS ou Google Chrome configurado para testes

---

## 🚀 Como Rodar o Projeto

Siga os passos abaixo no seu terminal:

1. **Clone o repositório:**
   ```bash
   git clone https://github.com/seu-usuario/loja_app_api.git
   ```

2. **Acesse a pasta do projeto:**
   ```bash
   cd loja_app_api
   ```

3. **Instale as dependências:**
   ```bash
   flutter pub get
   ```

4. **Execute o aplicativo:**
   ```bash
   # Para rodar no emulador/dispositivo conectado
   flutter run

   # Ou para rodar diretamente no navegador Chrome
   flutter run -d chrome
   ```

---

## 🔐 Configurações Adicionais (Android)

Para que o app realize requisições HTTP no sistema Android (dispositivo físico ou emulador), foi adicionada a seguinte permissão no arquivo `android/app/src/main/AndroidManifest.xml`:

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <!-- Permissão necessária para requisições de rede -->
    <uses-permission android:name="android.permission.INTERNET" />
    
    <application
        ...
```

---

## 🧪 Cenários de Teste Demonstrados

- **Cenário de Sucesso:**
  - O aplicativo inicia mostrando um indicador de carregamento (`CircularProgressIndicator`).
  - Os produtos da FakeStoreAPI são decodificados via `jsonDecode` e renderizados na `ListView`.
- **Cenário de Falha/Offline:**
  - Caso o dispositivo fique sem conexão, ocorra um `timeout` (estipulado em 10 segundos) ou a API retorne um status diferente de `200 OK`, o erro é capturado via `try/catch`.
  - A interface exibe uma mensagem amigável ao usuário com o botão **"Tentar Novamente"**, evitando que a aplicação quebre inesperadamente (*crash*).

---

## 📌 Boas Práticas Adotadas

1. **Isolamento de Camadas:** As chamadas de rede nunca são feitas dentro do método `build()` dos widgets, evitando requisições desnecessárias em cada redesenho de tela.
2. **Tratamento de Exceções:** Uso de `SocketException` e validação do `statusCode` antes de converter o corpo da resposta (`body`).
3. **Imutabilidade e Tipagem Estrita:** Modelos de dados com campos tipados e construtores imutáveis.