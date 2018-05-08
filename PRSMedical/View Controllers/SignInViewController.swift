//
//  SignInViewController.swift
//  PRSMedical
//
//  Created by Arun Kumar on 20/03/18.
//  Copyright © 2018 Arun Kumar. All rights reserved.
//

import UIKit
import MaterialComponents

class SignInViewController: BaseViewController {

    private let loginVM : LoginViewModel = {
        let vm = LoginViewModel()
        return vm
    }()
    
    @IBOutlet weak var labelError : UILabel!
    @IBOutlet weak var textFieldEmail : UITextField!
    @IBOutlet weak var textFieldPassword : UITextField!
    
  
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Sign In"
        
        textFieldEmail.addLeadingIcon(#imageLiteral(resourceName: "user_icon"))
        
        
        textFieldPassword.addLeadingIcon(#imageLiteral(resourceName: "password_icon"))
        
       
        
        textFieldPassword.clearButtonMode = .never
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.setStatusBarStyle(.lightContent, animated: true)
    }

    @IBAction func actionSingIn(_ sender : UIButton)
    {
        self.view.endEditing(true)
        guard let email = textFieldEmail.text , !email.isEmpty , email.isValidEmail() else {
            labelError.text = "Please enter a valid email"
            return }
        guard let password = textFieldPassword.text , !password.isEmpty else {
            labelError.text = "Wrong password"
            return }
        
        let input = LoginInput(email: email, password: password)
        sharedApp.loader.showLoader(withText: "Signing in...")
        loginVM.login(input) {[weak self] (success, msg) in
            sharedApp.loader.hideLoader()
            guard let `self` = self else {return}
            
            if !success {
                let alertOK : AlertAction = ("OK" , .default , nil)
                self.showAlert(withTitle: "Message", msg: self.loginVM.msg, actions: alertOK)
                return
            }
            
            loginUserInfo = self.loginVM
            self.saveObject(false, forKey: .firstRun)
            userEmailID = email
             Credential.delete()
            let newCredential = Credential.newCredential(forContext: CoreDataStack.dataStack.manageObjectContext)
            newCredential.saveCredential(withEmailID: email, password: password)
            self.performSegue(withIdentifier: "segueMainHome", sender: nil)
        }
        
    }
    
    @IBAction func actionShowHidePassword(_ sender : UIButton)
    {
        textFieldPassword.togglePasswordVisibility()
        sender.isSelected = !sender.isSelected
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueMainHome"
        {
            isNavigatedBySignUP = false
        }
    }
  

}

extension SignInViewController : UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case textFieldEmail:
            labelError.text = ""
        default:
            labelError.text = ""
        }
    }

}
