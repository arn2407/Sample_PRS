//
//  ForgetPasswodViewController.swift
//  PRSMedical
//
//  Created by Arun Kumar on 21/03/18.
//  Copyright © 2018 Arun Kumar. All rights reserved.
//

import UIKit
import MaterialComponents

class ForgetPasswodViewController: BaseViewController {

    private let forgotPassVM = ForgotPasswordViewModel()
    
    @IBOutlet weak var textFieldEmail : UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        title = "Forgot Password?"
        textFieldEmail.addLeadingIcon(#imageLiteral(resourceName: "email_tf_icon"))

        // Do any additional setup after loading the view.
    }
    @IBAction func actionSendLink(_ sender : UIButton)
    {
        guard let email = textFieldEmail.text , !email.isEmpty else { return }
        textFieldEmail.resignFirstResponder()
        let input = CushionForgotPassword(email: email)
        sharedApp.loader.showLoader(withText: "Sending Mail....")
        forgotPassVM.resetPassword(input) {[weak self] (success, msg) in
           sharedApp.loader.hideLoader()
            if success{
                let okAction  : AlertAction = ("OK" , .default , nil)
                self?.showAlert(withTitle: "Message", msg: self?.forgotPassVM.response?.message, actions: okAction)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension ForgetPasswodViewController : UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
