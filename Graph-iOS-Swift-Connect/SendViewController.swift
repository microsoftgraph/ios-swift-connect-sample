/*
 * Copyright (c) Microsoft. All rights reserved. Licensed under the MIT license.
 * See LICENSE in the project root for license information.
 */


import UIKit

class SendViewController: UIViewController {
    
    
    @IBOutlet var headerLabel: UILabel!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var sendButton: UIButton!
    
    @IBOutlet var statusTextView: UITextView!
    
    
    var authentication: Authentication!
    lazy var graphClient: MSGraphClient = {
        
        let client = MSGraphClient.defaultClient()
        return client
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MSGraphClient.setAuthenticationProvider(authentication.authenticationProvider)
        
        self.getUserInfo()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
}


// MARK: Actions
private extension SendViewController {
    @IBAction func disconnectGraph(sender: AnyObject) {
        self.disconnect()
    }
    
    @IBAction func sendMail(sender: AnyObject) {
        guard let toEmail = self.emailTextField.text else {return}
        if let message = self.createSampleMessage(to: toEmail) {
            
            let requestBuilder = graphClient.me().sendMailWithMessage(message, saveToSentItems: false)
            let mailRequest = requestBuilder.request()
            
            mailRequest.executeWithCompletion({
                (response: [NSObject : AnyObject]?, error: NSError?) in
                if let nsError = error {
                    print("Error", nsError.localizedDescription)
                    dispatch_async(dispatch_get_main_queue(),{
                        self.statusTextView.text = "Send mail has failed. Please look at the log for more details."
                    })
                    
                }
                else {
                    print("Sent!")
                    dispatch_async(dispatch_get_main_queue(),{
                        self.statusTextView.text = "Mail sent successfully."
                    })
                }
            })
        }
    }
}


// MARK: Graph Helper
private extension SendViewController {
    func disconnect() {
        authentication.disconnect()
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    /**
     Fetches user information such as mail and display name
     */
    func getUserInfo() {
        self.sendButton.enabled = false
        self.statusTextView.text = "Loading user information"
        
        self.graphClient.me().request().getWithCompletion {
            (user: MSGraphUser?, error: NSError?) in
            if let graphError = error {
                print("Error:", graphError)
                dispatch_async(dispatch_get_main_queue(),{
                    self.statusTextView.text = "Graph Error."
                })

            }
            else {
                guard let userInfo = user else {
                    dispatch_async(dispatch_get_main_queue(),{
                        self.statusTextView.text = "User information loading failed."
                    })
                    return
                }
                
                dispatch_async(dispatch_get_main_queue(),{
                    self.emailTextField.text = userInfo.mail
                    self.headerLabel.text = "Hi \(userInfo.displayName)"
                    self.statusTextView.text = "User information loaded."
                    self.sendButton.enabled = true
                })
                
            }
        }
    }

    
    /**
     Creates sample email message
     
     - parameter emailAddress: recipient email address
     
     - returns: MSGraphMessage object with given recipient. The body is created from EmailBody.html
     */
    private func createSampleMessage(to emailAddress: String) -> MSGraphMessage? {
        let message = MSGraphMessage()
        
        // set recipients
        
        let toRecipient = MSGraphRecipient()
        let msEmailAddress = MSGraphEmailAddress()
        msEmailAddress.address = emailAddress
        
        toRecipient.emailAddress = msEmailAddress
        
        let toRecipientList = [toRecipient]
        
        message.toRecipients = toRecipientList
        message.subject = "Mail received from the Office 365 iOS Microsoft Graph SDK Sample"
        
        let messageBody = MSGraphItemBody()
        messageBody.contentType = MSGraphBodyType.html()
        
        guard let emailBodyFilePath = NSBundle.mainBundle().pathForResource("EmailBody", ofType: "html") else {return nil}
        messageBody.content = try! String(contentsOfFile: emailBodyFilePath, encoding: NSUTF8StringEncoding)
        message.body = messageBody
        
        return message
    }
    
}

