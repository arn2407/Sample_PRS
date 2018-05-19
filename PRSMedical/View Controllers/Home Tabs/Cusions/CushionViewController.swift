//
//  CushionViewController.swift
//  PRSMedical
//
//  Created by Ashish Kumar on 18/04/18.
//  Copyright © 2018 Arun Kumar. All rights reserved.
//

import UIKit


class CushionViewController: UIViewController {
    
    @IBOutlet weak var collectionViewPeripherals : UICollectionView!

    @IBOutlet weak var viewError : UIView!
    private var devices : [CushionServer] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My Cushions"
        
        addBLENotification()
    
        
     
     
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        if let tabVC = tabBarController as? MainTabBarViewController
        {
            self.devices = tabVC.bluetoothManager.cushionList
            
          
            checkBatteryStatus()
            
            collectionViewPeripherals.reloadData()
        }
        
    }
   
    private func checkBatteryStatus()
    {
        let lowChargingCushion = self.devices.filter{$0.connected == 1 && $0.battery < 21 && $0.chargerFlag == 0}.last
        
        
        viewError.isHidden = lowChargingCushion == nil
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     if segue.identifier == "segueCushionDetail"
     {
        if let indexPath = getIndexPathFor(sender as? UIButton)
        {
            let device = devices[indexPath.item]
            let detailVC = segue.destination as! CushionDetailTableViewController
            detailVC.cushion = device
        }
        }
    }

    private func getIndexPathFor(_ sender : UIView?) -> IndexPath?
    {
        if sender == nil {return nil}
        if sender is MyCushionCell {
            return collectionViewPeripherals.indexPath(for: sender as! MyCushionCell)
        }
        return self.getIndexPathFor(sender?.superview)
        
    }
    
    deinit {
        
        removeBLENotification()
    }

}
extension CushionViewController : CollectionViewDelegates
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return devices.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeReusableCell(for: indexPath) as MyCushionCell
        let device = devices[indexPath.item]
        cell.labelName.text = device.deviceName
        cell.batteryLevel.textColor = device.battery <= 20 ? .red : #colorLiteral(red: 0.2980392157, green: 0.8509803922, blue: 0.3921568627, alpha: 1)
      
            cell.batteryLevel.text = device.chargerFlag == 1 ? "Cushion is charging" : "\(device.battery) %"
      
        cell.buttonSetting.isEnabled = true
        cell.settingLabel.textColor =  .black
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 144.0)
    }
}

extension CushionViewController
{
    
    private func addBLENotification()
    {
        addNotification(notification: .connectCushion, selector: #selector(cushionConnected(_:)))
        addNotification(notification: .disconnectCushion, selector: #selector(cushionDisConnected(_:)))
        
        addNotification(notification: .updateCushion, selector: #selector(cushionUpdatedNotification(_:)))

        
    }
    private func removeBLENotification()
    {
        removeNotification(notification: .connectCushion)
        removeNotification(notification: .disconnectCushion)
          removeNotification(notification: .updateCushion)
    }
    
    @objc func cushionConnected(_ noti : Notification)
    {
        if let cushion = noti.object as? CushionServer
        {
          updateCushionInfo(cushion)
        }
    }

    @objc func cushionDisConnected(_ noti : Notification)
    {
        if let cushion = noti.object as? CushionServer
        {
          updateCushionInfo(cushion)

        }
    }
    
    @objc func cushionUpdatedNotification(_ noti : Notification)
    {
        if let cushion = noti.object as? CushionServer
        {
             updateCushionInfo(cushion)
        }
    }
    
 
    
    private func updateCushionInfo(_ cushion : CushionServer)
    {
        if let index = self.devices.index(where: {$0.identifier == cushion.identifier})
        {
            let numberOfItems = collectionViewPeripherals.numberOfItems(inSection: 0)
            numberOfItems > 0 ?  collectionViewPeripherals.reloadItems(at: [IndexPath(item: index, section: 0)])  : collectionViewPeripherals.reloadData()
        }
        
        checkBatteryStatus()
    }
    
    

   
}
