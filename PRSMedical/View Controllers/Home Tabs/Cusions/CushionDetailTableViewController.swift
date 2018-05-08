//
//  CushionDetailTableViewController.swift
//  PRSMedical
//
//  Created by Arun Kumar on 22/04/18.
//  Copyright © 2018 Arun Kumar. All rights reserved.
//

import UIKit

class CushionDetailTableViewController: UITableViewController {

    var cushion : CushionServer!
    
    @IBOutlet weak var labelCushionName : UILabel!
    @IBOutlet weak var labelSittingTime : UILabel!
    @IBOutlet weak var switchPhone : UISwitch!
    @IBOutlet weak var switchViberation : UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Cushion: \(cushion.deviceName)"
        
        labelCushionName.text = cushion.deviceName
        switchPhone.isOn = false
        switchViberation.isOn = cushion.vibration
    
        
        labelSittingTime.text = cushion.alerttime.formattedTime
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

   override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let headerView = view as! UITableViewHeaderFooterView
        headerView.textLabel?.font = UIFont.systemFont(ofSize: 13)
        headerView.textLabel?.textColor = #colorLiteral(red: 0.2862745098, green: 0.2862745098, blue: 0.2862745098, alpha: 1)
        headerView.backgroundView?.backgroundColor = .white
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func actionPhoneAlert(_ sender : UISwitch)
    {}
  
    @IBAction func actionViberationAlert(_ sender : UISwitch)
    {
        guard let tabVC = self.tabBarController as? MainTabBarViewController else {return}
        cushion.charaterstics = tabVC.bluetoothManager.eventOrientedCharacteristic
        cushion.setViberation(sender.isOn) { (success) in
            mainQueue.async {
                
            }
        }
        
    }
    
    @IBAction func unwindSegueForTimingUpdate(_ segue : UIStoryboardSegue)
    {
        let time = cushion.alerttime
    
        labelSittingTime.text = time.formattedTime
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if segue.identifier == "segueTiming"
      {
        let vc = segue.destination as! SetSittingTimeViewController
        vc.cushion = self.cushion
        }
    }
 

}
