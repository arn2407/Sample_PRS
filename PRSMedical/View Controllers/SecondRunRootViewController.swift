//
//  SecondRunRootViewController.swift
//  PRSMedical
//
//  Created by Arun Kumar on 12/04/18.
//  Copyright © 2018 Arun Kumar. All rights reserved.
//

import UIKit

class SecondRunRootViewController: UIViewController {
    @IBOutlet weak var activity : UIActivityIndicatorView!
        {
        didSet{
            activity.stopAnimating()
        }
    }
    
    private let loginVM : LoginViewModel = {
        let vm = LoginViewModel()
        return vm
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        login()
        // Do any additional setup after loading the view.
    }
    
    func login()  {
        if let credentialEntity = Credential.getCredentialEntity() , let email = credentialEntity.emailID , let password = credentialEntity.password
        {
            activity.startAnimating()
        let input = LoginInput(email: email, password: password)
        loginVM.login(input) {[weak self] (success, msg) in
            guard let `self` = self else {return}
            self.activity.stopAnimating()
            
            if !success {
                let alertOK : AlertAction = ("OK" , .default , {[weak self](_) in
                    guard let `self` = self else {return}
                    let loginHome = self.getViewController() as PRSHomeViewController
                    self.pushTo(vc: loginHome)
                    
                })
                
                Credential.delete()
                
                self.showAlert(withTitle: "Message", msg: self.loginVM.msg, actions: alertOK)
                return
            }
            
            loginUserInfo = self.loginVM
            userEmailID = email
           
            let homeTab = self.getViewController() as MainTabBarViewController
            self.pushTo(vc: homeTab)
        }
        }
        else
        {
            let loginHome = self.getViewController() as PRSHomeViewController
            pushTo(vc: loginHome)
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
