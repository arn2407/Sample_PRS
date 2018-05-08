//
//  FAQsViewController.swift
//  PRSMedical
//
//  Created by Lucideus  on 4/16/18.
//  Copyright © 2018 Arun Kumar. All rights reserved.
//

import UIKit

class FAQsViewController: UIViewController {
    @IBOutlet weak var tableFAQs : UITableView!
    
    private var selectedIndexPath = [IndexPath]()

    private let settingVM = SettingsViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "FAQs"
        
        sharedApp.loader.showLoader()
        settingVM.getContent(for: .faq) {[weak self] (success, msg) in
            sharedApp.loader.hideLoader()
            guard let `self` = self else {return}
            if success {
            
            }
            self.tableFAQs.reloadData()
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
extension FAQsViewController : TableViewDelegates
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return settingVM.faqsCount
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.backgroundColor = .clear
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeReusableCell(for: indexPath) as FaqTableViewCell
        
        let faq = self.settingVM.getFaqs(for: indexPath.row)
        cell.labelQuestion.text =  faq?.question
        cell.labelAnswer.text = selectedIndexPath.contains(indexPath) ? faq?.answer : ""
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
 
        if let index = self.selectedIndexPath.index(of: indexPath)
        {
            self.selectedIndexPath.remove(at: index)
        }
        else
        {
            self.selectedIndexPath += [indexPath]
        }
        
        tableView.reloadRows(at: [indexPath], with: .none)
    }
}
