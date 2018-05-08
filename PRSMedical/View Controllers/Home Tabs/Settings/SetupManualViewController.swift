//
//  SetupManualViewController.swift
//  PRSMedical
//
//  Created by Lucideus  on 4/6/18.
//  Copyright © 2018 Arun Kumar. All rights reserved.
//

import UIKit
import CoreBluetooth


class SetupManualViewController: UIViewController {

     private var centralManager: CBCentralManager!
    
    private struct Manual {
        let mDescription : String
        let mImage : UIImage?
    }
    @IBOutlet weak var buttonNext : RoundedButton!
    private var arrayManuals = [Manual(mDescription: "Make sure bluetooth is turned on", mImage: nil),
                                             Manual(mDescription: "Make sure the cushion is charged and turned on", mImage: nil),
                                             Manual(mDescription: "The cushion should be less than 3 feet from your phone", mImage: nil)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Let's Connect to the Cushion"
        centralManager = CBCentralManager(delegate: self, queue: nil)
        enableButton = false
        
        
        if presentingViewController == nil
        {
            self.navigationItem.rightBarButtonItem = nil
        }
        // Do any additional setup after loading the view.
    }
    
    private var enableButton : Bool = false
    {
        didSet{
            buttonNext.isEnabled = enableButton
            buttonNext.color = enableButton ? #colorLiteral(red: 0.5019607843, green: 0.7058823529, blue: 0.2549019608, alpha: 1) : #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
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
extension SetupManualViewController : CollectionViewDelegates
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayManuals.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeReusableCell(for: indexPath) as UICollectionViewCell
        let textLabel  = cell.viewWithTag(100) as? UILabel
        let imageView = cell.viewWithTag(101) as? UIImageView
        
        let manual = arrayManuals[indexPath.item]
        textLabel?.text = manual.mDescription
        imageView?.image = manual.mImage
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.bounds.width, height: 110.0)
    }
}
extension SetupManualViewController : CBCentralManagerDelegate
{
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .unknown:
            print("central.state is .unknown")
        case .resetting:
            print("central.state is .resetting")
        case .unsupported:
            print("central.state is .unsupported")
        case .unauthorized:
            print("central.state is .unauthorized")
        case .poweredOff:
            print("central.state is .poweredOff")
        case .poweredOn:
            print("central.state is .poweredOn")
            enableButton = true
            return
        }
        enableButton = false
        
        ToastView.toast.showToast(with : "Make sure device blutooth is on.")
        
      
}
}
