# 适用于 iOS 的 Office 365 连接示例（使用 Microsoft Graph SDK）

Microsoft Graph 是访问来自 Microsoft 云的数据、关系和数据解析的统一终结点。 此示例介绍如何连接并对其进行身份验证，然后通过 [适用于 iOS 的 Microsoft Graph SDK](https://github.com/microsoftgraph/msgraph-sdk-ios) 调用邮件和用户 API。

> 注意：尝试 [Microsoft Graph 应用注册门户](https://graph.microsoft.io/en-us/app-registration) 页，该页简化了注册，因此你可以更快地运行该示例。
 
## 先决条件
* Apple [Xcode](https://developer.apple.com/xcode/downloads/)
* 安装 [CocoaPods](https://guides.cocoapods.org/using/using-cocoapods.html) 成为依存关系管理器。
* Microsoft 工作或个人电子邮件帐户，例如 Office 365 或 outlook.com、hotmail.com 等。你可以注册 [Office 365 开发人员订阅](https://aka.ms/devprogramsignup)，其中包含开始构建 Office 365 应用所需的资源。

     > 注意：如果已有订阅，则之前的链接会将你转至包含以下信息的页面：*抱歉，你无法将其添加到当前帐户*。 在这种情况下，请使用当前 Office 365 订阅中的帐户。    
* [Microsoft Graph 应用注册门户](https://graph.microsoft.io/en-us/app-registration) 中已注册应用的客户端 ID
* 若要生成请求，必须提供 **MSAuthenticationProvider**（它能够使用适当的 OAuth 2.0 持有者令牌对 HTTPS 请求进行身份验证）。 我们将使用 [msgraph-sdk-ios-nxoauth2-adapter](https://github.com/microsoftgraph/msgraph-sdk-ios-nxoauth2-adapter) 作为 MSAuthenticationProvider 的示例实现，它可被用于快速启动你的项目。 有关详细信息，请参阅以下“**相关代码**”一节。

       
## 在 Xcode 中运行此示例

1. 克隆该存储库
2. 使用 CocoaPods 以导入 Microsoft Graph SDK 和身份验证依赖项：
        
        pod 'MSGraphSDK'
        pod 'MSGraphSDK-NXOAuth2Adapter'


 该示例应用已包含可将 pod 导入到项目中的 pod 文件。 只需从**终端**导航到项目并运行： 
        
        pod install
        
   更多详细信息，请参阅 [其他资源](#其他资源) 中的“**使用 CocoaPods**”
  
3. 打开 **Graph-iOS-Swift-Connect.xcworkspace**
4. 在应用程序文件夹下打开 **AutheticationConstants.swift**。 你会发现，注册过程的 **clientId** 可以被添加到该文件。

   ```swift
        static let clientId = "ENTER_YOUR_CLIENT_ID"
   ```    
    > 注意：你会注意到为该项目配置了以下权限范围：**https://graph.microsoft.com/Mail.Send”、“https://graph.microsoft.com/User.Read”、“offline_access”**。 该项目中所使用的服务调用，向你的邮件帐户发送邮件并检索一些个人资料信息（显示名称、电子邮件地址）需要这些应用的权限以正常运行。


5. 运行示例。 系统将要求你连接至工作或个人邮件帐户或对其进行身份验证，然后你可以向该帐户或其他所选电子邮件帐户发送邮件。


##相关代码

可以在 **Authentication.swift** 文件中查看所有身份验证代码。 我们使用从 [NXOAuth2Client](https://github.com/nxtbgthng/OAuth2Client) 扩展的 MSAuthenticationProvider 示例实现来提供对已注册的本机应用的登录支持、访问令牌的自动刷新和注销功能。
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


对身份验证提供程序进行设置后，我们可以创建并初始化客户端对象 (MSGraphClient)，它将被用于对 Microsoft Graph 服务终结点（邮件和用户）进行调用。 在 **SendMailViewcontroller.swift** 中，我们可以使用以下代码来组合邮件请求并将其发送：

```swift
            let requestBuilder = graphClient.me().sendMailWithMessage(message, saveToSentItems: false)
            let mailRequest = requestBuilder.request()
            
            mailRequest.executeWithCompletion({
                (response: [NSObject : AnyObject]?, error: NSError?) in
                ...
            })

```

有关详细信息，包括调入其他服务（如 OneDrive）的代码，请参阅 [适用于 iOS 的 Microsoft Graph SDK](https://github.com/microsoftgraph/msgraph-sdk-ios)

## 问题和意见

我们乐意倾听你有关 Office 365 iOS Microsoft Graph Connect 项目的反馈。 你可以在该存储库中的 [问题]() 部分将问题和建议发送给我们。

与 Office 365 开发相关的问题一般应发布到[堆栈溢出](http://stackoverflow.com/questions/tagged/Office365+API)。确保您的问题或意见使用了 [Office365] 和 [MicrosoftGraph] 标记。

## 参与
你需要在提交拉取请求之前签署 [参与者许可协议](https://cla.microsoft.com/)。 要完成参与者许可协议 (CLA)，你需要通过表格提交请求，并在收到包含文件链接的电子邮件时在 CLA 上提交电子签名。 

此项目采用 [Microsoft 开源行为准则](https://opensource.microsoft.com/codeofconduct/)。有关详细信息，请参阅 [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/)（行为准则常见问题解答），有任何其他问题或意见，也可联系 [opencode@microsoft.com](mailto:opencode@microsoft.com)。

## 其他资源

* [Office 开发人员中心](http://dev.office.com/)
* [Microsoft Graph 概述页](https://graph.microsoft.io)
* [使用 CocoaPods](https://guides.cocoapods.org/using/using-cocoapods.html)

## 版权
版权所有 (c) 2016 Microsoft。保留所有权利。
