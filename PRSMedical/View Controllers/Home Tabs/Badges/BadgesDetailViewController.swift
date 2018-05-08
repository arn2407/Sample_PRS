//
//  BadgesDetailViewController.swift
//  PRSMedical
//
//  Created by Arun Kumar on 29/04/18.
//  Copyright © 2018 Arun Kumar. All rights reserved.
//

import UIKit

class BadgesDetailViewController: UIViewController {

    var info : BadgesViewController.BadgeInfo!
    
    @IBOutlet weak var imageView : UIImageView!
    @IBOutlet weak var labelLevel : UILabel!
    @IBOutlet weak var labelDescription : UILabel!
    @IBOutlet weak var buttonShare : UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = info.image
        labelLevel.text = info.badgeLevel
        labelDescription.text = info.levelDescription
        
        
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
