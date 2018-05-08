//
//  BaseViewController.swift
//  PRSMedical
//
//  Created by Arun Kumar on 21/03/18.
//  Copyright © 2018 Arun Kumar. All rights reserved.
//

import UIKit
import MaterialComponents

class BaseViewController: UIViewController {

    var appBar : MDCAppBar!
    override func viewDidLoad() {
        super.viewDidLoad()

      appBar =  addAppBar()
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
