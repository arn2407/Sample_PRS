//
//  AboutViewController.swift
//  PRSMedical
//
//  Created by Lucideus  on 4/16/18.
//  Copyright © 2018 Arun Kumar. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    private let settingVM = SettingsViewModel()
    @IBOutlet weak var  textView : UITextView!
    
    var type : SettingsViewModel.SettingType = .about
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = type == .about ?  "About Us" : type == .terms ? "Terms & Conditions" : "Privacy Policy"
        
        sharedApp.loader.showLoader()
        settingVM.getContent(for: type) {[weak self] (success, msg) in
            sharedApp.loader.hideLoader()
            guard let `self` = self else {return}
            if success {
                self.textView.text = self.type == .about ?  self.settingVM.getAbout(for: 0)?.info : self.type == .terms ? self.settingVM.getTerms(for: 0)?.title : self.settingVM.getPolicy(for: 0)?.title
            }
        }
        // Do any additional setup after loading the view.
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
