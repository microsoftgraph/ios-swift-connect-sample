# <a name="office-365-connect-sample-for-ios-using-the-microsoft-graph-sdk"></a>Office 365 Connect-Beispiel für iOS unter Verwendung des Microsoft Graph-SDKs

Microsoft Graph ist ein einheitlicher Endpunkt für den Zugriff auf Daten, Beziehungen und Erkenntnisse, die von der Microsoft-Cloud stammen. In diesem Beispiel wird gezeigt, wie Sie eine Verbindung damit herstellen und die Authentifizierung ausführen, und dann E-Mails und Benutzer-APIs über das [Microsoft Graph-SDK für iOS](https://github.com/microsoftgraph/msgraph-sdk-ios) aufrufen.

> Hinweis: Testen Sie die Seite des [App-Registrierungsportals von Microsoft Graph](https://graph.microsoft.io/en-us/app-registration), durch das die Registrierung erleichtert wird, sodass Sie schneller mit diesem Beispiel loslegen können.
 
## <a name="prerequisites"></a>Voraussetzungen
* [Xcode](https://developer.apple.com/xcode/downloads/) von Apple - Dieses Beispiel wird derzeit getestet und auf Version 7.3.1 von Xcode unterstützt.
* Installation von [CocoaPods](https://guides.cocoapods.org/using/using-cocoapods.html) als ein Abhängigkeits-Manager.
* Ein geschäftliches oder persönliches Microsoft-E-Mail-Konto, z. B. Office 365 oder outlook.com, hotmail.com usw. Sie können sich für ein [Office 365-Entwicklerabonnement](https://aka.ms/devprogramsignup) registrieren. Dieses umfasst die Ressourcen, die Sie zum Erstellen von Office 365-Apps benötigen.

     > Hinweis: Wenn Sie bereits über ein Abonnement verfügen, gelangen Sie über den vorherigen Link zu einer Seite mit der Meldung *Leider können Sie Ihrem aktuellen Konto diesen Inhalt nicht hinzufügen*. Verwenden Sie in diesem Fall ein Konto aus Ihrem aktuellen Office 365-Abonnement.    
* Eine Client-ID aus der registrierten App unter dem [App-Registrierungsportal von Microsoft Graph](https://graph.microsoft.io/en-us/app-registration)
* Um Anforderungen auszuführen, muss ein **MSAuthenticationProvider** bereitgestellt werden, der HTTPS-Anforderungen mit einem entsprechenden OAuth 2.0-Bearertoken authentifizieren kann. Wir verwenden [msgraph-sdk-ios-nxoauth2-adapter](https://github.com/microsoftgraph/msgraph-sdk-ios-nxoauth2-adapter) für eine Beispielimplementierung von MSAuthenticationProvider, die Sie für einen Schnelleinstieg in Ihr Projekt verwenden können. Weitere Informationen finden Sie im folgenden Abschnitt **Interessanter Code**.

       
## <a name="running-this-sample-in-xcode"></a>Ausführen dieses Beispiels in Xcode

1. Klonen dieses Repositorys
2. Verwenden Sie CocoaPods, um das Microsoft Graph-SDK und Authentifizierungsabhängigkeiten zu importieren:
        
        pod 'MSGraphSDK'
        pod 'MSGraphSDK-NXOAuth2Adapter'


 Diese Beispiel-App enthält bereits eine POD-Datei, die die Pods in das Projekt überträgt. Navigieren Sie einfach über das **Terminal** zum Projekt, und führen Sie Folgendes aus: 
        
        pod install
        
   Weitere Informationen finden Sie im Thema über das **Verwenden von CocoaPods** in [Zusätzliche Ressourcen](#AdditionalResources).
  
3. Öffnen Sie **Graph-iOS-Swift-Connect.xcworkspace**.
4. Öffnen Sie **AutheticationConstants.swift** unter dem Anwendungsordner. Sie werden sehen, dass die **clientId** aus dem Registrierungsprozess zu dieser Datei hinzugefügt werden kann.

   ```swift
        static let clientId = "ENTER_YOUR_CLIENT_ID"
   ```    
    > Hinweis: Sie sehen, dass die folgenden Berechtigungsbereiche für dieses Projekt konfiguriert wurden: **"https://graph.microsoft.com/Mail.Send", "https://graph.microsoft.com/User.Read", "Offline_access"**. Die in diesem Projekt verwendeten Dienstaufrufe, also das Senden einer E-Mail an Ihr E-Mail-Konto und das Abrufen einiger Profilinformationen (Anzeigename, E-Mail-Adresse) benötigen diese Berechtigungen, damit die App ordnungsgemäß ausgeführt wird.


5. Führen Sie das Beispiel aus. Sie werden aufgefordert, eine Verbindung zu einem geschäftlichen oder persönlichen E-Mail-Konto herzustellen oder zu authentifizieren. Dann können Sie eine E-Mail an dieses Konto oder an ein anderes ausgewähltes E-Mail-Konto senden.


##<a name="code-of-interest"></a>Interessanter Code

Der gesamte Authentifizierungscode kann in der Datei **Authentication.swift** angezeigt werden. Wir verwenden eine Beispielimplementierung von MSAuthenticationProvider, die über [NXOAuth2Client](https://github.com/nxtbgthng/OAuth2Client) hinaus erweitert wurde, um Anmeldeinformationen für registrierte systemeigene Apps, eine automatische Aktualisierung von Zugriffstoken sowie eine Abmeldefunktion bereitzustellen:
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


Nachdem der Authentifizierungsanbieter festgelegt wurde, können wir ein Clientobjekt (MSGraphClient) erstellen und initialisieren, das für Aufrufe des Microsoft Graph-Dienstendpunkts (E-Mail und Benutzer) verwendet wird. In **SendMailViewcontroller.swift** können wir eine E-Mail-Anforderung erstellen und diese mithilfe des folgenden Codes senden:

```swift
            let requestBuilder = graphClient.me().sendMailWithMessage(message, saveToSentItems: false)
            let mailRequest = requestBuilder.request()
            
            mailRequest.executeWithCompletion({
                (response: [NSObject : AnyObject]?, error: NSError?) in
                ...
            })

```

Weitere Informationen, einschließlich des Codes zum Aufrufen anderer Dienste wie OneDrive, finden Sie im [Microsoft Graph-SDK für iOS](https://github.com/microsoftgraph/msgraph-sdk-ios)

## <a name="questions-and-comments"></a>Fragen und Kommentare

Wir schätzen Ihr Feedback hinsichtlich des Office 365 iOS Microsoft Graph Connect-Projekts. Sie können uns Ihre Fragen und Vorschläge über den Abschnitt [Probleme]() dieses Repositorys senden.

Allgemeine Fragen zur Office 365-Entwicklung sollten in [Stack Overflow](http://stackoverflow.com/questions/tagged/Office365+API) gestellt werden. Stellen Sie sicher, dass Ihre Fragen oder Kommentare mit [Office365] und [MicrosoftGraph] markiert sind.

## <a name="contributing"></a>Mitwirkung
Vor dem Senden Ihrer Pull Request müssen Sie eine [Lizenzvereinbarung für Teilnehmer](https://cla.microsoft.com/) unterschreiben. Zum Vervollständigen der Lizenzvereinbarung für Teilnehmer (Contributor License Agreement, CLA) müssen Sie eine Anforderung über das Formular senden. Nachdem Sie die E-Mail mit dem Link zum Dokument empfangen haben, müssen Sie die CLA anschließend elektronisch signieren. 

In diesem Projekt wurden die [Microsoft Open Source-Verhaltensregeln](https://opensource.microsoft.com/codeofconduct/) übernommen. Weitere Informationen finden Sie unter [Häufig gestellte Fragen zu Verhaltensregeln](https://opensource.microsoft.com/codeofconduct/faq/), oder richten Sie Ihre Fragen oder Kommentare an [opencode@microsoft.com](mailto:opencode@microsoft.com).

## <a name="additional-resources"></a>Zusätzliche Ressourcen

* [Office Dev Center](http://dev.office.com/)
* [Microsoft Graph-Übersichtsseite](https://graph.microsoft.io)
* [Verwenden von CocoaPods](https://guides.cocoapods.org/using/using-cocoapods.html)

## <a name="copyright"></a>Copyright
Copyright (c) 2016 Microsoft. Alle Rechte vorbehalten.

