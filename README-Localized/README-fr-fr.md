# <a name="office-365-connect-sample-for-ios-using-the-microsoft-graph-sdk"></a>Exemple de connexion d’Office 365 pour iOS avec le kit de développement logiciel Microsoft Graph

Microsoft Graph est un point de terminaison unifié pour accéder aux données, aux relations et aux connaissances fournies à partir du cloud Microsoft. Cet exemple montre comment se connecter et s’authentifier, puis appeler les API de messagerie et utilisateur via le [kit de développement logiciel Microsoft Graph pour iOS](https://github.com/microsoftgraph/msgraph-sdk-ios).

> Remarque : Consultez la page relative au [portail d’inscription de l’application Microsoft Graph](https://graph.microsoft.io/en-us/app-registration) pour enregistrer plus facilement votre application et exécuter plus rapidement cet exemple.
 
## <a name="prerequisites"></a>Conditions préalables
* [Xcode](https://developer.apple.com/xcode/downloads/) d’Apple - Cet exemple est actuellement testé et pris en charge sous la version 7.3.1 de Xcode.
* Installation de [CocoaPods](https://guides.cocoapods.org/using/using-cocoapods.html) comme gestionnaire de dépendances.
* Un compte de messagerie professionnel ou personnel Microsoft comme Office 365 ou outlook.com, hotmail.com, etc. Vous pouvez vous inscrire à [Office 365 Developer](https://aka.ms/devprogramsignup) pour accéder aux ressources dont vous avez besoin afin de commencer à créer des applications Office 365.

     > Remarque : Si vous avez déjà un abonnement, le lien précédent vous renvoie vers une page avec le message suivant : *Désolé, vous ne pouvez pas ajouter ceci à votre compte existant*. Dans ce cas, utilisez un compte lié à votre abonnement Office 365 existant.    
* Un ID client de l’application enregistrée auprès du [portail d’inscription de l’application Microsoft Graph](https://graph.microsoft.io/en-us/app-registration)
* Pour effectuer des requêtes, vous devez fournir un élément **MSAuthenticationProvider** capable d’authentifier les requêtes HTTPS avec un jeton de support OAuth 2.0 approprié. Nous allons utiliser [msgraph-sdk-ios-nxoauth2-adapter](https://github.com/microsoftgraph/msgraph-sdk-ios-nxoauth2-adapter) pour un exemple d’implémentation de MSAuthenticationProvider qui peut être utilisé pour commencer rapidement votre projet. Voir la section **Code d’intérêt** ci-dessous pour plus d’informations.

       
## <a name="running-this-sample-in-xcode"></a>Exécution de cet exemple dans Xcode

1. Cloner ce référentiel
2. Utilisez CocoaPods pour importer les dépendances d’authentification et le kit de développement logiciel Microsoft Graph :
        
        pod 'MSGraphSDK'
        pod 'MSGraphSDK-NXOAuth2Adapter'


 Cet exemple d’application contient déjà un podfile qui recevra les pods dans le projet. Ouvrez simplement le projet à partir de **Terminal** et exécutez : 
        
        pod install
        
   Pour plus d’informations, consultez **Utilisation de CocoaPods** dans [Ressources supplémentaires](#AdditionalResources).
  
3. Ouvrez **Graph-iOS-Swift-Connect.xcworkspace**.
4. Ouvrez **AutheticationConstants.swift** sous le dossier Application. Vous verrez que l’**ID client** du processus d’inscription peut être ajouté à ce fichier.

   ```swift
        static let clientId = "ENTER_YOUR_CLIENT_ID"
   ```    
    > Remarque : Vous remarquerez que les étendues d’autorisations suivantes ont été configurées pour ce projet : **« https://graph.microsoft.com/Mail.Send », « https://graph.microsoft.com/User.Read », « offline_access »**. Les appels de service utilisés dans ce projet, l’envoi d’un courrier électronique à votre compte de messagerie et la récupération des informations de profil (nom d’affichage, adresse e-mail) ont besoin de ces autorisations pour que l’application s’exécute correctement.


5. Exécutez l’exemple. Vous êtes invité à vous connecter/authentifier à un compte de messagerie personnel ou professionnel, puis vous pouvez envoyer un message à ce compte ou à un autre compte de messagerie sélectionné.


##<a name="code-of-interest"></a>Code d’intérêt

Tout le code d’authentification peut être affiché dans le fichier **Authentication.swift**. Nous utilisons un exemple d’implémentation de MSAuthenticationProvider étendu de [NXOAuth2Client](https://github.com/nxtbgthng/OAuth2Client) pour prendre en charge la connexion des applications natives inscrites, l’actualisation automatique des jetons d’accès et la fonctionnalité de déconnexion :
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


Une fois le fournisseur d’authentification défini, nous pouvons créer et initialiser un objet client (MSGraphClient) qui sert à effectuer des appels par rapport au point de terminaison du service Microsoft Graph (courrier et utilisateurs). Dans **SendMailViewcontroller.swift**, nous pouvons assembler une requête de messagerie et l’envoyer en utilisant le code suivant :

```swift
            let requestBuilder = graphClient.me().sendMailWithMessage(message, saveToSentItems: false)
            let mailRequest = requestBuilder.request()
            
            mailRequest.executeWithCompletion({
                (response: [NSObject : AnyObject]?, error: NSError?) in
                ...
            })

```

Pour plus d’informations, y compris le code d’appel à d’autres services, tels que OneDrive, voir la section [Kit de développement logiciel Microsoft Graph pour iOS](https://github.com/microsoftgraph/msgraph-sdk-ios).

## <a name="questions-and-comments"></a>Questions et commentaires

Nous serions ravis de connaître votre opinion sur le projet de connexion d’iOS à Office 365 avec Microsoft Graph. Vous pouvez nous faire part de vos questions et suggestions dans la rubrique [Problèmes]() de ce référentiel.

Si vous avez des questions sur le développement d’Office 365, envoyez-les sur [Stack Overflow](http://stackoverflow.com/questions/tagged/Office365+API). Veillez à poser vos questions ou à rédiger vos commentaires avec les tags [MicrosoftGraph] et [Office 365].

## <a name="contributing"></a>Contribution
Vous devrez signer un [Contrat de licence de contributeur](https://cla.microsoft.com/) avant d’envoyer votre requête de tirage. Pour compléter le contrat de licence de contributeur (CLA), vous devez envoyer une requête en remplissant le formulaire, puis signer électroniquement le CLA quand vous recevrez le courrier électronique contenant le lien vers le document. 

Ce projet a adopté le [code de conduite Microsoft Open Source](https://opensource.microsoft.com/codeofconduct/). Pour plus d’informations, reportez-vous à la [FAQ relative au code de conduite](https://opensource.microsoft.com/codeofconduct/faq/) ou contactez [opencode@microsoft.com](mailto:opencode@microsoft.com) pour toute question ou tout commentaire.

## <a name="additional-resources"></a>Ressources supplémentaires

* [Centre de développement Office](http://dev.office.com/)
* [Page de présentation de Microsoft Graph](https://graph.microsoft.io)
* [Utilisation de CocoaPods](https://guides.cocoapods.org/using/using-cocoapods.html)

## <a name="copyright"></a>Copyright
Copyright (c) 2016 Microsoft. Tous droits réservés.

