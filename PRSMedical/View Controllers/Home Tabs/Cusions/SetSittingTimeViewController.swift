//
//  SetSittingTimeViewController.swift
//  PRSMedical
//
//  Created by Arun Kumar on 23/04/18.
//  Copyright © 2018 Arun Kumar. All rights reserved.
//

import UIKit

class SetSittingTimeViewController: UIViewController {

    @IBOutlet weak var labelTime : UILabel!
    var cushion : CushionServer!
    override func viewDidLoad() {
        super.viewDidLoad()
        timing = cushion.alerttime
        
        if timing <= 10
        {
            timing = 30
        }
        // Do any additional setup after loading the view.
    }
    
    private var timing : Int = 0
    {
        didSet{
            
            self.labelTime.text = timing.formattedTime
        }
    }
    
    @IBAction func actionChangeTime(_ sender : PlusMinusButton)
    {
        switch sender.tag {
        case 0:
            if timing > 30
            {
                timing -= 15
            }
        default:
            if timing < 120
            {
                timing += 15
            }
        }
    }
    
    @IBAction func actionMakeGoal(_ sender : UIButton)
    {
        guard let tabVC = self.tabBarController as? MainTabBarViewController else {return}
        if timing == cushion.alerttime {return}
        
        sender.isEnabled = false
        
        cushion.charaterstics = tabVC.bluetoothManager.eventOrientedCharacteristic
        cushion.setAdvInterval(timing) {[weak self] (flag) in
            guard let `self` = self else {return}
            mainQueue.async {
                [weak self] in
                guard let `self` = self else {return}
                sender.isEnabled = true
                self.cushion.alerttime = flag != 0 ? self.timing : self.cushion.alerttime
                self.performSegue(withIdentifier: "segueExit", sender: nil)
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
