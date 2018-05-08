//
//  CushionsScanningViewController.swift
//  PRSMedical
//
//  Created by Lucideus  on 4/11/18.
//  Copyright © 2018 Arun Kumar. All rights reserved.
//

import UIKit
import CoreBluetooth

class CushionsScanningViewController: UIViewController {

    @IBOutlet weak var tablePeripheral : UITableView!
    
    
    private var peripherals : [RKPeripheral] = []
    private var savedPeripheral : [RKPeripheral] =  []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        addBLENotification()
        setupPeripherals()
  
        
        //
        // Do any additional setup after loading the view.
    }

    private func setupPeripherals()
    {
        guard let tabVC = getTabBarController()  else { return  }
        if isNavigatedBySignUP || Cushion.getAllCushions().isEmpty
        {
            isNavigatedBySignUP = false
          
                LoaderView.shared.showLoader("Searching for Your Oasis Activ")
                tabVC.startScanning()
            perform(#selector(timeOut), with: nil, afterDelay: 15.0)
        }
        else
        {
            tabVC.foundPeripherals.forEach { (peripheral) in
                let cushionIDs = Cushion.getAllCushions().compactMap{$0.cushionUUID}
                if cushionIDs.contains(peripheral.identifier.uuidString)
                {
                    self.savedPeripheral += [peripheral]
                }
                else
                {
                    self.peripherals += [peripheral]
                }
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
      
        

        
    }
    
    @objc func timeOut()
    {
        guard let tabVC = getTabBarController()  else { return  }
        tabVC.bluetoothManager.stopScanning()
        LoaderView.shared.hideLoader()
        isNavigatedBySignUP = true
        let actionCancel : AlertAction = ("Cancel" , .cancel , nil)
        let alertTryAgain : AlertAction = ("Try Again" , .default , {[weak self] (_) in
            self?.setupPeripherals()
        })
        self.showAlert(withTitle: "Time Out!!!", msg: "No Cushion Found", actions:actionCancel ,  alertTryAgain)
        
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
    deinit {
        removeBLENotification()
    }

}



extension CushionsScanningViewController : TableViewDelegates
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? peripherals.count : savedPeripheral.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "NEW" : "ALREADY REGISTERED"
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let headerView = view as! UITableViewHeaderFooterView
        headerView.textLabel?.font = UIFont.systemFont(ofSize: 13)
        headerView.textLabel?.textColor = #colorLiteral(red: 0.2862745098, green: 0.2862745098, blue: 0.2862745098, alpha: 1)
        headerView.backgroundView?.backgroundColor = .white
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeReusableCell(for: indexPath) as UITableViewCell
        let peripheral = indexPath.section == 0 ?  peripherals[indexPath.row] : savedPeripheral[indexPath.row]
        cell.textLabel?.text = peripheral.name
        cell.detailTextLabel?.text = peripheral.identifier.uuidString
        cell.accessoryType = indexPath.section == 0 ?  .disclosureIndicator : .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {return}
         let peripheral = indexPath.section == 0 ?  peripherals[indexPath.row] : savedPeripheral[indexPath.row]
        let cushionConnectionVC = self.getViewController() as CushionConnectViewController
        cushionConnectionVC.peripheral = peripheral
        self.pushTo(vc: cushionConnectionVC)

        
    }
    
}
extension CushionsScanningViewController
{
    
    private func addBLENotification()
    {
        addNotification(notification: .updateState, selector: #selector(updateBluetoothState(_:)))
        addNotification(notification: .foundCushion, selector: #selector(didFindCushion(_:)))
      
    }
    private func removeBLENotification()
    {
        removeNotification(notification: .updateState)
        removeNotification(notification: .foundCushion)
     
    }
    
    @objc func updateBluetoothState(_ noti : Notification)
    {
        if let state = noti.object as? CBManagerState , state != .poweredOn
        {
           ToastView.toast.showToast(with: "Make sure device blutooth is on.")
        }
    }
    
    @objc func didFindCushion(_ noti : Notification)
    {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(timeOut), object: nil)
        if let peripheral = noti.object as? RKPeripheral
        {
            if !peripherals.contains(peripheral)
            {
                let cushionIDs = Cushion.getAllCushions().compactMap{$0.cushionUUID}
                if cushionIDs.contains(peripheral.identifier.uuidString)
                {
                    savedPeripheral += [peripheral]
                }
                else
                {
                    peripherals += [peripheral]
                }
                tablePeripheral.reloadData()
            }
        }
    }
    

    
   
    
}

