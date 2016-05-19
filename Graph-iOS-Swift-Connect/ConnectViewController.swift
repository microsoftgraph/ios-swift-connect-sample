/*
 * Copyright (c) Microsoft. All rights reserved. Licensed under the MIT license.
 * See LICENSE in the project root for license information.
 */


import Foundation
import UIKit

class ConnectViewController: UIViewController {
 
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var connectButton: UIButton!
    
    let authentication: Authentication = Authentication()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // There is only one segue
        let sendViewController: SendViewController = segue.destinationViewController as! SendViewController
        sendViewController.authentication = authentication
    }
}


// MARK: Actions
private extension ConnectViewController {
    @IBAction func connectToGraph(sender: AnyObject) {
        authenticate()
    }
}


// MARK: Authentication
private extension ConnectViewController {
    func authenticate() {
        loadingUI(show: true)
        
        let clientId = ApplicationConstants.clientId
        let scopes = ApplicationConstants.scopes
        
        authentication.connectToGraph(withClientId: clientId, scopes: scopes) {
            (error) in
            
            defer {self.loadingUI(show: false)}
            
            if let graphError = error {
                switch graphError {
                case .NSErrorType(let nsError):
                    print("Error:", nsError.localizedDescription)
                    self.showError(message: "Check print log for error details")
                }
            }
            else {
                self.performSegueWithIdentifier("showSendMail", sender: nil)
            }
        }
    }
}


// MARK: UI Helper
private extension ConnectViewController {
    func loadingUI(show show: Bool) {
        if show {
            self.activityIndicator.startAnimating()
            self.connectButton.setTitle("Connecting...", forState: .Normal)
            self.connectButton.enabled = false;
        }
        else {
            self.activityIndicator.stopAnimating()
            self.connectButton.setTitle("Connect", forState: .Normal)
            self.connectButton.enabled = true;
        }
    }
    
    func showError(message message:String) {
        dispatch_async(dispatch_get_main_queue(),{
            let alertControl = UIAlertController(title: "Error", message: message, preferredStyle: .Alert)
            alertControl.addAction(UIAlertAction(title: "Close", style: .Default, handler: nil))
            
            self.presentViewController(alertControl, animated: true, completion: nil)
        })
    }
}

