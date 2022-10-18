//
//  LoginViewController.swift
//  notesapp
//
//  Created by Rehan Sarwar on 10/12/22.
//  Copyright © 2020 Confiz. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet fileprivate var signInUsernameField: UITextField!
    @IBOutlet fileprivate var signInPasswordField: UITextField!
    @IBOutlet fileprivate var loaderSpinner: UIActivityIndicatorView!
    @IBOutlet private var loginBtn: UIButton!
    var userDefaults: UserDefaults = .standard

    override func viewDidLoad() {
        let isLogin: Bool = userDefaults.bool(forKey: "isLogin")
        if(isLogin){
            guard let vc = self.storyboard?.instantiateViewController(identifier: "main") as?MainViewController else {
                return
            }
               vc.navigationItem.largeTitleDisplayMode = .never
            self.navigationController?.pushViewController(vc, animated:true)
             var navigationArray = self.navigationController?.viewControllers // To get all UIViewController stack as Array
             navigationArray?.remove(at: 0) // To remove previous UIViewController
             self.navigationController?.viewControllers.remove(at: 0)
        }
        super.viewDidLoad()
        self.signInUsernameField.delegate = self
        self.signInPasswordField.delegate = self
        self.loaderSpinner.isHidden=true
        signInUsernameField.text = "eve.holt@reqres.in"
        signInPasswordField.text = "cityslicka"
        
        // Do any additional setup after loading the view.
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
     @IBAction func signIn() {
       guard let email = signInUsernameField.text, let password = signInPasswordField.text else {
           return
        }
        
        let isValidateEmail = validateEmailId(emailID:  email)
            if (isValidateEmail == false) {
               self.showToast(message: "Invalid User Email")
               return
            }
       
         let isValidatePass = validatePassword(password: password)
            if (isValidatePass == false) {
              self.showToast(message: "Please add your complete password")
               return
            }
         
        loaderSpinner.isHidden = false
        let perameter = ["email": email, "password": password]
        NetworkManager().login(req: perameter){(loginRes) in
            DispatchQueue.main.async{
                var message = ""
                if(!loginRes.token!.isEmpty){
                    self.userDefaults.set(true, forKey: "isLogin")
                    message = "Login successful"
                    guard let vc = self.storyboard?.instantiateViewController(identifier: "main") as?MainViewController else {
                       return
                   }
                      vc.navigationItem.largeTitleDisplayMode = .never
                   self.navigationController?.pushViewController(vc, animated:true)
                    var navigationArray = self.navigationController?.viewControllers // To get all UIViewController stack as Array
                    navigationArray?.remove(at: 0) // To remove previous UIViewController
                    self.navigationController?.viewControllers.remove(at: 0)
                return
                } else if(!loginRes.error!.isEmpty) {
                    message = loginRes.error!
                }else {
                    message = "something went wrong"
                }
                self.showToast(message: message)
            }
            
        }
    
    }

}
