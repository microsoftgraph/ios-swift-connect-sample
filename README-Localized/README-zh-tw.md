# <a name="office-365-connect-sample-for-ios-using-the-microsoft-graph-sdk"></a>使用 Microsoft Graph SDK 的 Office 365 Connect 範例 (適用於 iOS)

Microsoft Graph 是存取資料的統一端點、來自 Microsoft 雲端的關係和見解。此範例示範如何連接和驗證，然後透過 [Microsoft Graph SDK for iOS](https://github.com/microsoftgraph/msgraph-sdk-ios) 呼叫郵件和使用者 API。

> 附註：嘗試可簡化註冊的 [Microsoft Graph 應用程式註冊入口網站](https://graph.microsoft.io/en-us/app-registration)頁面，以便您能更快速地執行這個範例。
 
## <a name="prerequisites"></a>必要條件
* 來自 Apple 的 [Xcode](https://developer.apple.com/xcode/downloads/) - 此範例目前經過測試，可支援 Xcode 的版本 7.3.1。
* 安裝 [CocoaPods](https://guides.cocoapods.org/using/using-cocoapods.html) 做為相依性管理員。
* Microsoft 工作或個人電子郵件帳戶，例如 Office 365，或 outlook.com、hotmail.com 等等。您可以註冊 [Office 365 開發人員訂用帳戶](https://aka.ms/devprogramsignup)，其中包含開始建置 Office 365 應用程式所需的資源。

     > 附註：如果您已有訂用帳戶，則先前的連結會讓您連到顯示*抱歉，您無法將之新增到您目前的帳戶*訊息的頁面。在此情況下，請使用您目前的 Office 365 訂用帳戶所提供的帳戶。    
* 已註冊應用程式的用戶端識別碼，來自 [Microsoft Graph 應用程式註冊入口網站](https://graph.microsoft.io/en-us/app-registration)
* 若要提出要求，必須提供 **MSAuthenticationProvider**，它能夠以適當的 OAuth 2.0 持有人權杖驗證 HTTPS 要求。我們會針對 MSAuthenticationProvider 的範例實作使用 [msgraph-sdk-ios-nxoauth2-adapter](https://github.com/microsoftgraph/msgraph-sdk-ios-nxoauth2-adapter)，可以用來幫助您的專案。請參閱以下區段**感興趣的程式碼**以取得詳細資訊。

       
## <a name="running-this-sample-in-xcode"></a>在 Xcode 中執行這個範例

1. 複製此儲存機制
2. 使用 CocoaPods 來匯入 Microsoft Graph SDK 和驗證相依性：
        
        pod 'MSGraphSDK'
        pod 'MSGraphSDK-NXOAuth2Adapter'


 此範例應用程式已經包含可將 pods 放入專案的 podfile。只需從 **Terminal** 瀏覽至專案並執行： 
        
        pod install
        
   如需詳細資訊，請參閱[其他資訊](#AdditionalResources)中的**使用 CocoaPods**
  
3. 開啟 **Graph-iOS-Swift-Connect.xcworkspace**
4. 開啟 [應用程式] 資料夾底下的 **AutheticationConstants.swift**。您會發現註冊程序的 **clientId** 可以新增至此檔案。

   ```swift
        static let clientId = "ENTER_YOUR_CLIENT_ID"
   ```    
    > 附註：您會注意到已針對此專案設定下列權限範圍：**"https://graph.microsoft.com/Mail.Send"、"https://graph.microsoft.com/User.Read"、"offline_access"**服務呼叫在此專案中使用，將郵件傳送至您的郵件帳戶並且擷取一些設定檔資訊 (顯示名稱、電子郵件地址) 需要這些權限才能讓應用程式適當地執行。


5. 執行範例。系統會要求您連接/驗證工作或個人郵件帳戶，然後您才可以將郵件傳送至該帳戶，或者傳送至其他選取的電子郵件帳戶。


##<a name="code-of-interest"></a>感興趣的程式碼

所有的驗證程式碼可以在 **Authentication.swift** 檔案中檢視。我們使用從 [NXOAuth2Client](https://github.com/nxtbgthng/OAuth2Client) 延伸的 MSAuthenticationProvider 的範例實作，以提供已註冊原生應用程式的登入支援、自動重新整理存取權杖，以及登出功能：
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


一旦設定驗證提供者，我們可以建立和初始化用戶端物件 (MSGraphClient)，用來針對 Microsoft Graph 服務端點 (郵件和使用者) 進行呼叫。在 **SendMailViewcontroller.swift** 中，我們可以使用下列程式碼組合郵件要求並且傳送它︰

```swift
            let requestBuilder = graphClient.me().sendMailWithMessage(message, saveToSentItems: false)
            let mailRequest = requestBuilder.request()
            
            mailRequest.executeWithCompletion({
                (response: [NSObject : AnyObject]?, error: NSError?) in
                ...
            })

```

如需詳細資訊，包括用來呼叫至其他服務 (像是 OneDrive) 的程式碼，請參閱 [Microsoft Graph SDK for iOS](https://github.com/microsoftgraph/msgraph-sdk-ios)

## <a name="questions-and-comments"></a>問題和建議

我們很樂於收到您對於 Office 365 iOS Microsoft Graph Connect 專案的意見反應。您可以在此儲存機制的[問題]()區段中，將您的問題及建議傳送給我們。

請在 [Stack Overflow](http://stackoverflow.com/questions/tagged/Office365+API) 提出有關 Office 365 開發的一般問題。務必以 [Office365] 和 [MicrosoftGraph] 標記您的問題或意見。

## <a name="contributing"></a>參與
您必須在提交您的提取要求之前，先簽署[投稿者授權合約](https://cla.microsoft.com/)。若要完成投稿者授權合約 (CLA)，您必須透過表單提交要求，然後在您收到含有文件連結的電子郵件時以電子方式簽署 CLA。 

此專案已採用 [Microsoft 開放原始碼執行](https://opensource.microsoft.com/codeofconduct/)。如需詳細資訊，請參閱[程式碼執行常見問題集](https://opensource.microsoft.com/codeofconduct/faq/)，如果有其他問題或意見，請連絡 [opencode@microsoft.com](mailto:opencode@microsoft.com)。

## <a name="additional-resources"></a>其他資源

* [Office 開發人員中心](http://dev.office.com/)
* [Microsoft Graph 概觀頁面](https://graph.microsoft.io)
* [使用 CocoaPods](https://guides.cocoapods.org/using/using-cocoapods.html)

## <a name="copyright"></a>著作權
Copyright (c) 2016 Microsoft.著作權所有，並保留一切權利。

