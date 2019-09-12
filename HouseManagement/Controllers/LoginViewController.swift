//
//  LoginViewController.swift
//  HouseManagement
//
//  Created by Robert Ababei on 27/08/2019.
//  Copyright © 2019 Robert Ababei. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        CustomizedUI.customizeTextField(theTextField: usernameTextField)
        CustomizedUI.customizeTextField(theTextField: passwordTextField)
        CustomizedUI.customizeButton(theButton: loginButton, type: .shine)
    }
    
    
    @IBAction func loginBtnClicked(_ sender: UIButton) {
        
        let email = usernameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        //TODO: Don't let email and pass to be empty space. This will crash
        // your applciation because you cannot insert empty string as a node
        // in database
        Auth.auth().signIn(withEmail: "robert@ok.com", password: "asd123") { result, error in
            guard error == nil else {
                self.errorLabel.text = error?.localizedDescription
                self.errorLabel.isHidden = false
                return
            }
            let userId = Auth.auth().currentUser?.uid
            let user = [email: userId]
            
            Database.database().reference().child("users").updateChildValues(user)
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let tabBarVC = storyboard.instantiateViewController(withIdentifier: "tabBarController")
            self.navigationController?.pushViewController(tabBarVC, animated: true)
            
        }
        
    }
    

}
