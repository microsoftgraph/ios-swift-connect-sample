# <a name="office-365-connect-sample-for-ios-using-the-microsoft-graph-sdk"></a>Приложение Office 365 Connect для iOS, использующее Microsoft Graph SDK

Microsoft Graph — единая конечная точка для доступа к данным, отношениям и статистике из Microsoft Cloud. В этом примере показано, как подключиться к ней и пройти проверку подлинности, а затем вызывать почтовые и пользовательские API через [Microsoft Graph SDK для iOS](https://github.com/microsoftgraph/msgraph-sdk-ios).

> Примечание. Воспользуйтесь упрощенной регистрацией на [портале регистрации приложений Microsoft Graph](https://graph.microsoft.io/en-us/app-registration), чтобы ускорить запуск этого примера.
 
## <a name="prerequisites"></a>Необходимые компоненты
* [Xcode](https://developer.apple.com/xcode/downloads/) от Apple. Этот пример в настоящее время проверяется и поддерживается в Xcode версии 7.3.1.
* Установка [CocoaPods](https://guides.cocoapods.org/using/using-cocoapods.html) в качестве диспетчера зависимостей.
* Рабочая или личная учетная запись Майкрософт, например Office 365, outlook.com или hotmail.com. Вы можете [подписаться на план Office 365 для разработчиков](https://aka.ms/devprogramsignup), который включает ресурсы, необходимые для создания приложений Office 365.

     > Примечание. Если у вас уже есть подписка, при выборе приведенной выше ссылки откроется страница с сообщением *К сожалению, вы не можете добавить это к своей учетной записи*. В этом случае используйте учетную запись, связанную с текущей подпиской на Office 365.    
* Идентификатор клиента из приложения, зарегистрированного на [портале регистрации приложений Microsoft Graph](https://graph.microsoft.io/en-us/app-registration)
* Чтобы отправлять запросы, необходимо указать протокол **MSAuthenticationProvider**, который способен проверять подлинность HTTPS-запросов с помощью соответствующего маркера носителя OAuth 2.0. Для реализации протокола MSAuthenticationProvider и быстрого запуска проекта мы будем использовать [msgraph-sdk-ios-nxoauth2-adapter](https://github.com/microsoftgraph/msgraph-sdk-ios-nxoauth2-adapter). Дополнительные сведения см. в разделе **Полезный код**.

       
## <a name="running-this-sample-in-xcode"></a>Запуск этого примера в Xcode

1. Клонируйте этот репозиторий.
2. Импортируйте зависимости пакета SDK Microsoft Graph и проверки подлинности с помощью CocoaPods:
        
        pod 'MSGraphSDK'
        pod 'MSGraphSDK-NXOAuth2Adapter'


 Этот пример приложения уже содержит podfile, который добавит компоненты pod в проект. Просто перейдите к проекту из раздела **Терминал** и выполните следующую команду: 
        
        pod install
        
   Для получения дополнительных сведений выберите ссылку **Использование CocoaPods** в разделе [Дополнительные ресурсы](#AdditionalResources).
  
3. Откройте **Graph-iOS-Swift-Connect.xcworkspace**.
4. Откройте **AutheticationConstants.swift** в папке "Приложение". Вы увидите, что в этот файл можно добавить идентификатор клиента **clientId**, скопированный в ходе регистрации.

   ```swift
        static let clientId = "ENTER_YOUR_CLIENT_ID"
   ```    
    > Примечание. Вы заметите, что для этого проекта настроены следующие разрешения: **"https://graph.microsoft.com/Mail.Send", "https://graph.microsoft.com/User.Read", "offline_access"**. Эти разрешения необходимы для правильной работы приложения, в частности отправки сообщения в учетную запись почты и получения сведений профиля (отображаемое имя, адрес электронной почты).


5. Запустите приложение. Вам будет предложено подключить рабочую или личную учетную запись почты и войти в нее, после чего вы сможете отправить сообщение в эту или другую учетную запись.


##<a name="code-of-interest"></a>Полезный код

Весь код для проверки подлинности можно найти в файле **Authentication.swift**. Мы используем протокол MSAuthenticationProvider из файла [NXOAuth2Client](https://github.com/nxtbgthng/OAuth2Client) для поддержки входа в зарегистрированных собственных приложениях, автоматического обновления маркеров доступа и выхода:
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


Если поставщик проверки подлинности настроен, мы можем создать и инициализировать объект клиента (MSGraphClient), который будет использоваться для вызова службы Microsoft Graph (почта и пользователи). Мы можем собрать почтовый запрос в **SendMailViewcontroller.swift** и отправить его с помощью следующего кода:

```swift
            let requestBuilder = graphClient.me().sendMailWithMessage(message, saveToSentItems: false)
            let mailRequest = requestBuilder.request()
            
            mailRequest.executeWithCompletion({
                (response: [NSObject : AnyObject]?, error: NSError?) in
                ...
            })

```

Дополнительные сведения, в том числе код для вызова других служб, например OneDrive, см. в статье [Microsoft Graph SDK для iOS](https://github.com/microsoftgraph/msgraph-sdk-ios)

## <a name="questions-and-comments"></a>Вопросы и комментарии

Мы будем рады узнать ваше мнение о проекте Office 365 Connect для iOS, использующем Microsoft Graph. Вы можете отправлять нам вопросы и предложения на вкладке [Issues]() этого репозитория.

Общие вопросы о разработке решений для Office 365 следует публиковать на сайте [Stack Overflow](http://stackoverflow.com/questions/tagged/Office365+API). Обязательно помечайте свои вопросы и комментарии тегами [Office365] и [MicrosoftGraph].

## <a name="contributing"></a>Добавление кода
Прежде чем отправить запрос на включение внесенных изменений, необходимо подписать [лицензионное соглашение с участником](https://cla.microsoft.com/). Чтобы заполнить лицензионное соглашение с участником (CLA), вам потребуется отправить запрос с помощью формы, а затем после получения электронного сообщения со ссылкой на этот документ подписать CLA с помощью электронной подписи. 

Этот проект соответствует [правилам поведения Майкрософт, касающимся обращения с открытым кодом](https://opensource.microsoft.com/codeofconduct/). Читайте дополнительные сведения в [разделе вопросов и ответов по правилам поведения](https://opensource.microsoft.com/codeofconduct/faq/) или отправляйте новые вопросы и замечания по адресу [opencode@microsoft.com](mailto:opencode@microsoft.com).

## <a name="additional-resources"></a>Дополнительные ресурсы

* [Центр разработки для Office](http://dev.office.com/)
* [Страница с общими сведениями о Microsoft Graph](https://graph.microsoft.io)
* [Использование CocoaPods](https://guides.cocoapods.org/using/using-cocoapods.html)

## <a name="copyright"></a>Авторское право
(c) Корпорация Майкрософт (Microsoft Corporation), 2016. Все права защищены.

