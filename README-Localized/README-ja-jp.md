# Microsoft Graph SDK を使用した iOS 用 Office 365 Connect サンプル

Microsoft Graph は、Microsoft Cloud からのデータ、リレーションシップおよびインサイトにアクセスするための統合エンドポイントです。 このサンプルでは、これに接続して認証し、[Microsoft Graph SDK for iOS](https://github.com/microsoftgraph/msgraph-sdk-ios) 経由でメールとユーザーの API を呼び出す方法を示します。

> 注:このサンプルをより迅速に実行するため、登録手順が簡略化された「[Microsoft Graph アプリ登録ポータル](https://graph.microsoft.io/en-us/app-registration)」ページをお試しください。
 
## 前提条件
* Apple 社の [Xcode](https://developer.apple.com/xcode/downloads/)。
* 依存関係マネージャーとしての [CocoaPods](https://guides.cocoapods.org/using/using-cocoapods.html) のインストール。
* Office 365、outlook.com、hotmail.com などの、Microsoft の職場または個人用のメール アカウント。Office 365 アプリのビルドを開始するために必要なリソースを含む、[Office 365 Developer サブスクリプション](https://aka.ms/devprogramsignup)にサインアップできます。

     > 注:サブスクリプションをすでにお持ちの場合、上記のリンクをクリックすると、「*申し訳ございません。現在のアカウントに追加できません*」というメッセージが表示されるページに移動します。 その場合は、現在使用している Office 365 サブスクリプションのアカウントをご利用いただけます。    
* [Microsoft Graph アプリ登録ポータル](https://graph.microsoft.io/en-us/app-registration) で登録済みのアプリのクライアント ID
* 要求を実行するには、適切な OAuth 2.0 ベアラー トークンを使用して HTTPS 要求を認証できる **MSAuthenticationProvider** を指定する必要があります。 プロジェクトのジャンプ スタート用に使用できる MSAuthenticationProvider をサンプル実装するために、[msgraph-sdk-ios-nxoauth2-adapter](https://github.com/microsoftgraph/msgraph-sdk-ios-nxoauth2-adapter) を使用します。 詳細については、以下の「**目的のコード**」セクションをご覧ください。

       
## Xcode でこのサンプルを実行する

1. このリポジトリの複製を作成する
2. CocoaPods を使用して、Microsoft Graph SDK と認証の依存関係をインポートします:
        
        pod 'MSGraphSDK'
        pod 'MSGraphSDK-NXOAuth2Adapter'


 このサンプル アプリには、プロジェクトに pod を取り込む podfile が既に含まれています。 **ターミナル**からプロジェクトに移動して次を実行するだけです: 
        
        pod install
        
   詳細については、[その他の技術情報](#その他の技術情報)の「**CocoaPods を使う**」を参照してください
  
3. **Graph-iOS-Swift-Connect.xcworkspace** を開きます
4. アプリケーション フォルダーで、**AutheticationConstants.swift** を開きます。 登録プロセスの **clientID** がこのファイルに追加されていることが分かります。

   ```swift
        static let clientId = "ENTER_YOUR_CLIENT_ID"
   ```    
    > 注:次のアクセス許可の適用範囲がこのプロジェクトに対して構成されていることが分かります。: **"https://graph.microsoft.com/Mail.Send"、"https://graph.microsoft.com/User.Read"、"offline_access"**。 このプロジェクトで使用されるサービス呼び出し、メール アカウントへのメールの送信、および一部のプロファイル情報 (表示名、メール アドレス) の取得では、アプリが適切に実行するためにこれらのアクセス許可が必要です。


5. サンプルを実行します。 職場または個人用のメール アカウントに接続または認証するように求められ、そのアカウントか、別の選択したメール アカウントにメールを送信することができます。


##目的のコード

すべての認証コードは、**Authentication.swift** ファイルで確認することができます。 [NXOAuth2Client](https://github.com/nxtbgthng/OAuth2Client) から拡張された MSAuthenticationProvider のサンプル実装を使用して、登録済みのネイティブ アプリのログインのサポート、アクセス トークンの自動更新、およびログアウト機能を提供します:
```swift
        NXOAuth2AuthenticationProvider.setClientId(clientId, scopes: scopes)
        
        if NXOAuth2AuthenticationProvider.sharedAuthProvider().loginSilent() == true {
            completion(error: nil)
        }
        else {
            NXOAuth2AuthenticationProvider.sharedAuthProvider()
                .loginWithViewController(nil) { (error: NSError?) in
                    
                    if let nserror = error {
                        completion(error: MSGraphError.NSErrorType(error: nserror))
                    }
                    else {
                        completion(error: nil)
                    }
            }
        }
        ...
        func disconnect() {
             NXOAuth2AuthenticationProvider.sharedAuthProvider().logout()
        }

```


認証プロバイダーを設定すると、Microsoft Graph サービス エンドポイント (メールとユーザー) に対して呼び出しを実行するために使用されるクライアント オブジェクト (MSGraphClient) の作成と初期化が行えます。 **SendMailViewcontroller.swift** では、次のコードを使用して、メール要求をアセンブルし、送信できます:

```swift
            let requestBuilder = graphClient.me().sendMailWithMessage(message, saveToSentItems: false)
            let mailRequest = requestBuilder.request()
            
            mailRequest.executeWithCompletion({
                (response: [NSObject : AnyObject]?, error: NSError?) in
                ...
            })

```

OneDrive のような他のサービスへの呼び出しを行うコードなどの詳細については、「[Microsoft Graph SDK for iOS](https://github.com/microsoftgraph/msgraph-sdk-ios)」を参照してください

## 質問とコメント

Office 365 iOS Microsoft Graph Connect プロジェクトに関するフィードバックをお寄せください。 質問や提案につきましては、このリポジトリの「[問題]()」セクションで送信できます。

Office 365 開発全般の質問につきましては、「[スタック オーバーフロー](http://stackoverflow.com/questions/tagged/Office365+API)」に投稿してください。質問またはコメントには、必ず [Office365] および [MicrosoftGraph] のタグを付けてください。

## 投稿
プル要求を送信する前に、[投稿者のライセンス契約](https://cla.microsoft.com/)に署名する必要があります。 投稿者のライセンス契約 (CLA) を完了するには、ドキュメントへのリンクを含むメールを受信した際に、フォームから要求を送信し、CLA に電子的に署名する必要があります。 

このプロジェクトでは、[Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/) が採用されています。詳細については、「[規範に関する FAQ](https://opensource.microsoft.com/codeofconduct/faq/)」を参照してください。または、その他の質問やコメントがあれば、[opencode@microsoft.com](mailto:opencode@microsoft.com) までにお問い合わせください。

## その他のリソース

* [Office デベロッパー センター](http://dev.office.com/)
* [Microsoft Graph の概要ページ](https://graph.microsoft.io)
* [CocoaPods を使う](https://guides.cocoapods.org/using/using-cocoapods.html)

## 著作権
Copyright (c) 2016 Microsoft. All rights reserved.
