# 💰 Flutter Byte Bank

Aplicação mobile desenvolvida em **Flutter** para controle de transações financeiras, permitindo:

-   Cadastro de transações (Depósito e Transferência)
-   Upload de comprovantes (imagens) via **Firebase Storage**
-   Autenticação de usuários com **Firebase Authentication**
-   Persistência de dados no **Cloud Firestore**
-   Filtros, paginação e edição/exclusão de transações

Projeto focado em **Flutter Mobile (Android)**.

------------------------------------------------------------------------

## 🚀 Tecnologias Utilizadas

-   Flutter (SDK estável)
-   Dart
-   Firebase (Authentication, Cloud Firestore, Storage)
-   Provider
-   Image Picker

------------------------------------------------------------------------

## 📋 Pré-requisitos

-   Flutter SDK
-   Android Studio
-   Android SDK configurado
-   Emulador Android ou dispositivo físico
-   Conta no Firebase


------------------------------------------------------------------------

## 🔥 Configuração do Firebase

### Android

-   Crie um projeto no Firebase
-   Adicione um app Android com o applicationId:
    `com.example.mobile_byte_bank`
-   Baixe o arquivo `google-services.json`
-   Salve em: `android/app/google-services.json`

------------------------------------------------------------------------

## 🔐 Firebase Authentication

-   Ative **Email/Senha** em Authentication

------------------------------------------------------------------------

## 📦 Cloud Firestore

### Estrutura utilizada

    users
     └── {uid}
          └── transactions
               └── {transactionId}

### Exemplo de documento

``` json
{
  "type": "Depósito",
  "value": 150.75,
  "date": "2025-06-20T14:32:00.000",
  "receiptUrl": "https://..."
}
```

### Regras

``` js
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId}/transactions/{docId} {
      allow read, write: if request.auth != null
        && request.auth.uid == userId;
    }
  }
}
```

------------------------------------------------------------------------

## 🖼 Firebase Storage

Estrutura:

    receipts/{uid}/{transactionId}.jpg

Regras:

``` js
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /receipts/{userId}/{allPaths=**} {
      allow read, write: if request.auth != null
        && request.auth.uid == userId;
    }
  }
}
```

------------------------------------------------------------------------

## 📦 Dependências

``` yaml
firebase_core
firebase_auth
cloud_firestore
firebase_storage
provider
image_picker
```

------------------------------------------------------------------------

## ▶️ Executar o projeto

``` bash
git clone https://github.com/gioniemeyer/flutter_byte_bank
cd flutter_byte_bank
flutter pub get
flutter run
```

------------------------------------------------------------------------

## 📱 Observações Importantes

Teste final realizado em dispositivo físico.

Recomenda-se validar funcionalidades em dispositivo real.

O comportamento de teclado e foco pode variar entre emulador e dispositivo físico.