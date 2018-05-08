//
//  ViewController.swift
//  PRSMedical
//
//  Created by Arun Kumar on 11/03/18.
//  Copyright © 2018 Arun Kumar. All rights reserved.
//

import UIKit
import GoogleSignIn
import FacebookCore
import FacebookLogin
import FBSDKLoginKit

class PRSHomeViewController: UIViewController {
    private let loginVM : LoginViewModel = {
        let vm = LoginViewModel()
        return vm
    }()
    @IBOutlet weak var signInButton: GIDSignInButton!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        

        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.setStatusBarStyle(.default, animated: true)
    }

    @IBAction func SignInByOthers(_ sender : UIButton)
    {
        switch sender.tag {
        case 0:
                isFacebookSignIn = true
                isGoogleSignIn = false
                let loginManager = LoginManager()
                loginManager.logIn(readPermissions: [ .publicProfile , .email], viewController: self) {[weak self] loginResult in
                    switch loginResult {
                    case .failed(let error):
                        print(error)
                    case .cancelled:
                        print("User cancelled login.")
                    case .success(let _, let _, let accessToken):
                    
                        
                        self?.getFBUserData(accessToken.authenticationToken)
                    }
            }
                    
        default:
            isGoogleSignIn = true
            isFacebookSignIn = false
          if  GIDSignIn.sharedInstance().hasAuthInKeychain()
          {
                GIDSignIn.sharedInstance().signInSilently()
            }
            else
          {
             GIDSignIn.sharedInstance().delegate = self
             GIDSignIn.sharedInstance().uiDelegate = self
             GIDSignIn.sharedInstance().signIn()
            }
        }
    }
    
    func getFBUserData(_ token : String){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, email"]).start(completionHandler: {[weak self] (connection, result, error) -> Void in
                guard let `self` = self else {return}
                if (error == nil){
                    if let response = result as? [String : Any] , let emailId = response["email"] as? String
                    {
                        userEmailID = emailId
                        mainQueue.async {[weak self] in
                            self?.login(with: emailId, password: token)
                        }
                    }
                   
                }
            })
        }
    }
    
    private func login(with email : String , password : String)
    {
        
        isNavigatedBySignUP = true
        let registrationInput = RegistraionInput(email: email  , password: password , firstname: "", lastname: "", gender: "M", bday: "1980", weight: "140" , height : "5' 6\"")
        userEmailID = registrationInput.email
        let mainTabBar = self.getViewController() as MainTabBarViewController
        mainTabBar.userInfoInputs = registrationInput
        pushTo(vc: mainTabBar)
    }
    
}

extension PRSHomeViewController : GIDSignInDelegate , GIDSignInUIDelegate
{
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        
    }
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        viewController.dismiss(animated: true, completion: nil)
    }
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            debugPrint("\(error.localizedDescription)")
        } else {
            // Perform any operations on signed in user here.
            let userId = user.userID    ; debugPrint(userId ?? "")              // For client-side use only!
            let idToken = user.authentication.idToken  ; debugPrint(idToken ?? "")      // Safe to send to the server
            let fullName = user.profile.name ; debugPrint(fullName ?? "")
            let givenName = user.profile.givenName ; debugPrint(givenName ?? "")
            let familyName = user.profile.familyName ; debugPrint(familyName ?? "")
            let email = user.profile.email ; debugPrint(email ?? "")
            
            mainQueue.async { [weak self] in
                self?.login(with: email!, password: idToken!)
                
            }
            // ...
        }
    }
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        
    }
}
