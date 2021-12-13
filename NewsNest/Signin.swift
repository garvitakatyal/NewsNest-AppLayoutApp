//
//  Signin.swift
//  NewsNest
//
//  Created by Alan Díaz on 13/12/21.
//

import UIKit
import Firebase
import FirebaseAuth

class Signin: UIViewController {

    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func bLoginClicked(_ sender: Any) {
        let email = tfEmail.text!
        let password = tfPassword.text!
        
        if email.count == 0 {
            print("Write Email")
            showAlert(message: "Write Email")
            return
        } else {
            if password.count == 0 {
                print("Write password")
                showAlert(message: "Write Password")
                return
            } else {
                Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                    if let error = error as? NSError {
                        switch AuthErrorCode(rawValue: error.code) {
                        case .operationNotAllowed:
                            print("operationNotAllowed")
                            self.showAlert(message: "operationNotAllowed")
                            
                        case .userDisabled:
                            print("userDisabled")
                            self.showAlert(message: "userDisabled")
                            
                        case .wrongPassword:
                            print("wrongPassword")
                            self.showAlert(message: "wrongPassword")
                            
                        case .invalidEmail:
                            print("invalidEmail")
                            self.showAlert(message: "invalidEmail")
                            
                        default:
                            print(error)
                        }
                    } else {
                        print("signin successfully")
                        
                        self.performSegue(withIdentifier: "news", sender: nil)
                    }
                }
            }
        }
        
        
    }
    
    func showAlert(message:String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
