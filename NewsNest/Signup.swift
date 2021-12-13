//
//  Signup.swift
//  NewsNest
//
//  Created by Alan Díaz on 13/12/21.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseDatabase

class Signup: UIViewController {

    @IBOutlet weak var tfFirstName: UITextField!
    @IBOutlet weak var tfLastName: UITextField!
    @IBOutlet weak var tfUserName: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var tfConfirmPassword: UITextField!
    @IBOutlet weak var cbBusiness: Checkbox!
    @IBOutlet weak var cbHealth: Checkbox!
    @IBOutlet weak var cbEntertainment: Checkbox!
    @IBOutlet weak var cbScience: Checkbox!
    @IBOutlet weak var cbSports: Checkbox!
    @IBOutlet weak var cbTechnology: Checkbox!
    
    private let database = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if Auth.auth().currentUser != nil {
            performSegue(withIdentifier: "news", sender: nil)
        }
    }
    

    @IBAction func bSignUp(_ sender: Any) {
        let fname = tfFirstName.text!
        let lname = tfLastName.text!
        let username = tfUserName.text!
        let email = tfEmail.text!
        let password = tfPassword.text!
        let cpassword = tfConfirmPassword.text!
        
        if fname.count == 0 {
            print("Write First Name")
            showAlert(message: "Write First Name")
            return
        } else {
            if lname.count == 0 {
                print("Write Last Name")
                showAlert(message: "Write Last Name")
                return
            } else {
                if username.count == 0 {
                    print("Write User Name")
                    showAlert(message: "Write User Name")
                    return
                } else {
                    if email.count == 0 {
                        print("Write email")
                        showAlert(message: "Write Email")
                        return
                    } else {
                        if password.count == 0 {
                            print("Write password")
                            showAlert(message: "Write Password")
                            return
                        } else {
                            if cpassword.count == 0 {
                                print("Write confirm password")
                                showAlert(message: "Write Confirm Password")
                                return
                            } else {
                                if password != cpassword {
                                    print("Password not matched")
                                    showAlert(message: "Password Not Matched")
                                } else {
                                    var category = ""
                                    if self.cbScience.isChecked {
                                        category = "science"
                                    }
                                    if self.cbHealth.isChecked {
                                        category = "\(category),health"
                                    }
                                    
                                    if self.cbTechnology.isChecked {
                                        category = "\(category),technology"
                                    }
                                    if self.cbSports.isChecked {
                                        category = "\(category),sports"
                                    }
                                    if self.cbBusiness.isChecked {
                                        category = "\(category),business"
                                    }
                                    if self.cbEntertainment.isChecked {
                                        category = "\(category),entertainment"
                                    }
                                    
                                    if category == "" {
                                        self.showAlert(message: "choose category")
                                    } else {
                                        let object:[String: String] = ["category": category, "firstname": fname, "lastname": lname, "username": username, "email" : email]
                                        
                                        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                                            if let error = error as? NSError {
                                                switch AuthErrorCode(rawValue: error.code) {
                                                case .operationNotAllowed:
                                                    print("operationNotAllowed")
                                                    self.showAlert(message: "operationNotAllowed")
                                                    
                                                case .emailAlreadyInUse:
                                                    print("emailAlreadyInUse")
                                                    self.showAlert(message: "emailAlreadyInUse")
                                                    
                                                case .invalidEmail:
                                                    print("invalidEmail")
                                                    self.showAlert(message: "invalidEmail")
                                                    
                                                case .weakPassword:
                                                    print("weakPassword")
                                                    self.showAlert(message: "weakPassword")
                                                    
                                                default:
                                                    print(error)
                                                }
                                            } else {
                                                print("signup successfully")
                                                
                                                self.database.child("users").child(Auth.auth().currentUser!.uid).setValue(object)
                                                
                                                self.performSegue(withIdentifier: "news", sender: nil)
                                                
                                            }
                                        }
                                    }
                                    
                                }
                            }
                        }
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
