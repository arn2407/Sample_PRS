//
//  SignupViewController.swift
//  PRSMedical
//
//  Created by Arun Kumar on 18/03/18.
//  Copyright © 2018 Arun Kumar. All rights reserved.
//

import UIKit
import MaterialComponents

class SignupViewController: BaseViewController {

    @IBOutlet weak var labelError : UILabel!
    
    @IBOutlet weak var textFieldEmail : UITextField!
    @IBOutlet weak var textFieldPassword : UITextField!
    
    @IBOutlet weak var imageViewWarning : UIImageView!
    @IBOutlet weak var imageViewCompleteRegistration : UIImageView!
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

          title = "Sign up with email"
       
        textFieldEmail.addLeadingIcon(#imageLiteral(resourceName: "user_icon"))
        
    
        textFieldPassword.addLeadingIcon(#imageLiteral(resourceName: "password_icon"))
        
    
        
        textFieldPassword.clearButtonMode = .never
        setErrorText = ""
      
        // Do any additional setup after loading the view.
    }

    private var setErrorText : String = ""
    {
        didSet{
            imageViewWarning.isHidden = setErrorText.isEmpty
            labelError.text = setErrorText
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.setStatusBarStyle(.lightContent, animated: true)
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
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "segueMainHome"
        {
            self.view.endEditing(true)
            guard let email = textFieldEmail.text , !email.isEmpty , email.isValidEmail() else {
                   setErrorText = "Please enter a valid email"
                return false}
            guard let password = textFieldPassword.text , !password.isEmpty else {
                setErrorText = "Wrong password"
                return false}
            
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if segue.identifier == "segueMainHome"
       {
        isNavigatedBySignUP = true
        let registrationInput = RegistraionInput(email: textFieldEmail.text!  , password: textFieldPassword.text! , firstname: "", lastname: "", gender: "M", bday: "1980", weight: "140" , height : "5' 6\"")
        userEmailID = registrationInput.email
        let mainTabBar = segue.destination as! MainTabBarViewController
        mainTabBar.userInfoInputs = registrationInput
        }
    }
  

}
extension SignupViewController : UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case textFieldEmail:
              setErrorText = ""
        default:
           setErrorText = ""
        }
    }
}
