/*
 * Copyright (c) Microsoft. All rights reserved. Licensed under the MIT license.
 * See LICENSE in the project root for license information.
 */


import UIKit

class SendViewController: UIViewController {
    
    @IBOutlet var disconnectButton: UIBarButtonItem!
    @IBOutlet var descriptionLabel: UILabel!
    
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
        
        getUserInfo()
        initUI()
        
    }
    
    func initUI() {
        self.title = NSLocalizedString("GRAPH_TITLE", comment: "")
        self.disconnectButton.title = NSLocalizedString("DISCONNECT", comment: "")
        self.descriptionLabel.text = NSLocalizedString("DESCRIPTION", comment: "")
        self.sendButton.setTitle(NSLocalizedString("SEND", comment: ""), forState: .Normal)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
}


// MARK: Actions
extension SendViewController {
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
                    print(NSLocalizedString("ERROR", comment: ""), nsError.localizedDescription)
                    dispatch_async(dispatch_get_main_queue(),{
                        self.statusTextView.text = NSLocalizedString("SEND_FAILURE", comment: "")
                    })
                    
                }
                else {
                    dispatch_async(dispatch_get_main_queue(),{
                        self.statusTextView.text = NSLocalizedString("SEND_SUCCESS", comment: "")
                    })
                }
            })
        }
    }
}


// MARK: Graph Helper
extension SendViewController {
    func disconnect() {
        authentication.disconnect()
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    /**
     Fetches user information such as mail and display name
     */
    func getUserInfo() {
        self.sendButton.enabled = false
        self.statusTextView.text = NSLocalizedString("LOADING_USER_INFO", comment: "")
        
        self.graphClient.me().request().getWithCompletion {
            (user: MSGraphUser?, error: NSError?) in
            if let graphError = error {
                print(NSLocalizedString("ERROR", comment: ""), graphError)
                dispatch_async(dispatch_get_main_queue(),{
                    self.statusTextView.text = NSLocalizedString("GRAPH_ERROR", comment: "")
                })

            }
            else {
                guard let userInfo = user else {
                    dispatch_async(dispatch_get_main_queue(),{
                        self.statusTextView.text = NSLocalizedString("USER_INFO_LOAD_FAILURE", comment: "")

                    })
                    return
                }
                
                dispatch_async(dispatch_get_main_queue(),{
                    self.emailTextField.text = userInfo.mail
                    
                    if let displayName = userInfo.displayName {
                        self.headerLabel.text = NSString(format: NSLocalizedString("HI_USER", comment: ""), displayName) as String
                    }
                    else {
                        self.headerLabel.text = NSString(format: NSLocalizedString("HI_USER", comment: ""), "") as String
                    }
                    
                    self.statusTextView.text = NSLocalizedString("USER_INFO_LOAD_SUCCESS", comment: "")
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
    func createSampleMessage(to emailAddress: String) -> MSGraphMessage? {
        let message = MSGraphMessage()
        
        // set recipients
        
        let toRecipient = MSGraphRecipient()
        let msEmailAddress = MSGraphEmailAddress()
        msEmailAddress.address = emailAddress
        
        toRecipient.emailAddress = msEmailAddress
        
        let toRecipientList = [toRecipient]
        
        message.toRecipients = toRecipientList
        message.subject = NSLocalizedString("MAIL_SUBJECT", comment: "")
        
        let messageBody = MSGraphItemBody()
        messageBody.contentType = MSGraphBodyType.html()
        
        guard let emailBodyFilePath = NSBundle.mainBundle().pathForResource("EmailBody", ofType: "html") else {return nil}
        messageBody.content = try! String(contentsOfFile: emailBodyFilePath, encoding: NSUTF8StringEncoding)
        message.body = messageBody
        
        return message
    }
    
}

