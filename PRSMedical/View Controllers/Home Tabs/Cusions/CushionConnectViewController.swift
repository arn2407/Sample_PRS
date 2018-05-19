//
//  CushionConnectViewController.swift
//  PRSMedical
//
//  Created by Arun Kumar on 14/04/18.
//  Copyright © 2018 Arun Kumar. All rights reserved.
//

import UIKit
import CoreMotion


class CushionConnectViewController: UIViewController {
    
    var peripheral: RKPeripheral?
    
    @IBOutlet weak var imageView : UIImageView!
    
    private let activityManager = CMMotionActivityManager()
    private let pedometer = CMPedometer()
    
    private var cushionName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startUpdatingMotion()
    }
    
    private func setCushionName()
    {
       let alertVC = UIAlertController(title: "Name your Cushion", message: "Set a name for your cushion to easily identify it. ", preferredStyle: .alert)
        alertVC.addTextField { (textfield) in
            textfield.placeholder = "Cushion Name"
        }
        let actionCancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        let actionOK = UIAlertAction(title: "Save", style: .default) {[weak self] (_) in
            if let text = alertVC.textFields?.first?.text , !text.isEmpty
            {
                self?.cushionName = text
                self?.storeCushionInDB()
            }
            else
            {
                self?.setCushionName()
            }
        }
        alertVC.addAction(actionCancel)
        alertVC.addAction(actionOK)
        present(alertVC, animated: true, completion: nil)
    }
    private var isStepCountCalled = false
    
    private func startUpdatingMotion() {
      
        
        if CMPedometer.isStepCountingAvailable() {
           if let afternoonDate = Calendar.current.date(byAdding: .hour, value: -12, to: Date())
           {
            LoaderView.shared.showLoader("Enabling motion...")
            self.pedometer.queryPedometerData(from: afternoonDate, to: Date()) {[weak self] (data, error) in
                guard let `self` = self else {return}
                DispatchQueue.main.async {
                    LoaderView.shared.hideLoader()
                }
                if self.isStepCountCalled {return}
                self.isStepCountCalled = true
                self.pedometer.stopUpdates()
                DispatchQueue.main.async {
                    [weak self] in
                   self?.setCushionName()
                }
                
            }
            }
           
        }
    }
    
    
    private func storeCushionInDB()
    {
        let cushionObj = Cushion.newCushion(forContext: CoreDataStack.dataStack.manageObjectContext)
        cushionObj.saveCushionDetail(withUUID: (peripheral?.identifier.uuidString)!, name: cushionName, phoneAlert: false)
        self.view.backgroundColor = #colorLiteral(red: 0.3333333333, green: 0.7529411765, blue: 0, alpha: 1)
        imageView.isHidden = false
        if let tabVC =  getTabBarController()
        {
            tabVC.bluetoothManager.setup()
            tabVC.bluetoothManager.connectCushion(peripheral!)
        }
        perform(#selector(self.goToCushionVC), with: nil, afterDelay: 0.5)
    }
   
    
    @objc private func goToCushionVC()
    {
        
      
        
        if self.presentingViewController != nil
        {
            dismissVC("")
            return
        }
        (self.navigationController?.tabBarController as? MainTabBarViewController)?.selectTabIndex = 2
        self.navigationController?.popToRootViewController(animated: false)
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

