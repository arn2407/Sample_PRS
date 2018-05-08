//
//  SettingsTableViewController.swift
//  PRSMedical
//
//  Created by Arun Kumar on 29/03/18.
//  Copyright © 2018 Arun Kumar. All rights reserved.
//

import UIKit

class SettingsTableViewController: UIViewController {
   
    @IBOutlet weak var table: UITableView!
    
    private struct Items
    {
        let sectionName : String
        let rowNames : [Row]
        init(_ dict : [String : Any]) {
            self.sectionName = dict["sectionName"] as? String ?? ""
            self.rowNames = (dict["rows"] as? [String] ?? []).map{Row(rowName: $0)}
        }
        struct Row {
            let rowName : String
        }
    }
    
    private var tableItems = [Items]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
      
       
        self.title = "Settings"
        let arr :[ [String : Any]] = [["sectionName" : "CUSHIONS" , "rows" : ["Home","Office"]],
                                                         ["sectionName" : "PERSONAL" , "rows" : ["Edit "]],
                                                         ["sectionName" : "OASIS" , "rows" : ["About Us","FAQs","Terms of Use","Privacy Policy"]]]
        tableItems = arr.map{Items($0)}
       
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
   
    }
    
    @IBAction func actionLogout(_ sender : UIButton)
    {
        let actionLogout : AlertAction = ("Logout" , .destructive , {[weak self](action) in
            guard let `self` = self else {return}
             let signIn = self.getViewController() as PRSHomeViewController
            self.postNotification(notification: .disconnectCushion)
            CoreDataStack.dataStack.resetDB({ (success) in
                
            })
            let nav = UINavigationController(rootViewController: signIn)
            nav.isNavigationBarHidden = true
            sharedApp.window?.rootViewController = nav
        })
        let actionCancel : AlertAction = ("Cancel" , .cancel , nil)
        self.showAlert( msg: "You will lost all of your saved data. Are you sure?", alertType: .actionSheet, actions: actionLogout , actionCancel)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

 

   

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
        if  let type = sender as? SettingsViewModel.SettingType
        {
            let vc = segue.destination as! AboutViewController
            vc.type = type
        }
        
    }

    
    


}
extension SettingsTableViewController : TableViewDelegates
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableItems.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableItems[section].rowNames.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tableItems[section].sectionName
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeReusableCell(for: indexPath) as UITableViewCell
        cell.textLabel?.text = tableItems[indexPath.section].rowNames[indexPath.row].rowName
        return cell
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let headerView = view as! UITableViewHeaderFooterView
        headerView.textLabel?.font = UIFont.systemFont(ofSize: 13)
        headerView.textLabel?.textColor = #colorLiteral(red: 0.2862745098, green: 0.2862745098, blue: 0.2862745098, alpha: 1)
        headerView.backgroundView?.backgroundColor = .white
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        switch indexPath.section {
        case 1:
            let profileVC = getViewController() as ProfileViewController
            self.navigationController?.pushViewController(profileVC, animated: true)
        case 2:
            switch indexPath.row
            {
            case 0 , 2 , 3:
                let type : SettingsViewModel.SettingType = indexPath.row == 0 ?  .about : indexPath.row == 2 ? .terms : .privacy
                performSegue(withIdentifier: "segueAbout", sender: type)
            case 1 :
                
                performSegue(withIdentifier: "segueFaqs", sender: nil)
            default : break
            }
        default:
            break
        }
    }
    

    
}
