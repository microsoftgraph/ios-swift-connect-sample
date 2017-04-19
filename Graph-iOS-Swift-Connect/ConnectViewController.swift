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
        
        title = NSLocalizedString("GRAPH_TITLE", comment: "")
        connectButton.setTitle(NSLocalizedString("CONNECT", comment: ""), for: UIControlState())
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // There is only one segue
        let sendViewController: SendViewController = segue.destination as! SendViewController
        sendViewController.authentication = authentication
    }
}


// MARK: Actions
private extension ConnectViewController {
    @IBAction func connectToGraph(_ sender: AnyObject) {
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
                case .nsErrorType(let nsError):
                    print(NSLocalizedString("ERROR", comment: ""), nsError.localizedDescription)
                    self.showError(message: NSLocalizedString("CHECK_LOG_ERROR", comment: ""))
                }
            }
            else {
                self.performSegue(withIdentifier: "showSendMail", sender: nil)
            }
        }
    }
}


// MARK: UI Helper
private extension ConnectViewController {
    func loadingUI(show: Bool) {
        if show {
            self.activityIndicator.startAnimating()
            self.connectButton.setTitle(NSLocalizedString("CONNECTING", comment: ""), for: UIControlState())
            self.connectButton.isEnabled = false;
        }
        else {
            self.activityIndicator.stopAnimating()
            self.connectButton.setTitle(NSLocalizedString("CONNECT", comment: ""), for: UIControlState())
            self.connectButton.isEnabled = true;
        }
    }
    
    func showError(message:String) {
        DispatchQueue.main.async(execute: {
            let alertControl = UIAlertController(title: NSLocalizedString("ERROR", comment: ""), message: message, preferredStyle: .alert)
            alertControl.addAction(UIAlertAction(title: NSLocalizedString("CLOSE", comment: ""), style: .default, handler: nil))
            
            self.present(alertControl, animated: true, completion: nil)
        })
    }
}

