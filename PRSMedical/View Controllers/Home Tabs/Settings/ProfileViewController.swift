//
//  ProfileViewController.swift
//  PRSMedical
//
//  Created by Arun Kumar on 03/04/18.
//  Copyright © 2018 Arun Kumar. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController  {

    var userInfoInputs : RegistraionInput?
    @IBOutlet weak var viewPickerComponent : UIView!
    @IBOutlet weak var pickerComponent : UIPickerView!
    @IBOutlet weak var collectionBasicInfo : UICollectionView!
    @IBOutlet weak var buttonUpdate : UIButton!
    
    private let registrationVM : RegistrationViewModel = {
        let vm = RegistrationViewModel()
        return vm
    }()
    
    private enum InfoSelection : Int
    {
        case height , weight , birthYear
    }
    
    private var arrPickerRows = [String]()
    private var selectedInfo : InfoSelection = .height
    private  lazy var heightArray : [String] = {
        let arr = (1...8).reduce([String]()) { (result, height) -> [String] in
            var currentResult = result
            (0...11).forEach{
                currentResult += ["\(height)' \($0)\""]
            }
            return currentResult
        }
        return arr
    }()
    
    private lazy var weightArray : [String] = {
        return (50...400).map{"\($0) lbs"}
    }()
    private lazy var birthYearsArray : [String] = {
        return (1918...2018).map{"\($0)"}
    }()
    let arrInfos = [InfoDetail("Gender" , "M"),InfoDetail("Height" , "5' 6\""),InfoDetail("Weight" , "140 lbs"),InfoDetail("Birth Year" , "1980")]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = isNavigatedBySignUP ? "Tell Us About Yourself" : "Profile"
        
        buttonUpdate.setTitle(isNavigatedBySignUP ? "Next" : "Update", for: .normal)
        
        if !isNavigatedBySignUP {
            arrInfos[0].value = loginUserInfo?.gender ?? "M"
            arrInfos[1].value = loginUserInfo?.height ?? "5' 6\""
            arrInfos[2].value = loginUserInfo?.weight ?? "140 lbs"
            arrInfos[3].value = loginUserInfo?.birthYear ?? "1980"
            if let userInfo = loginUserInfo
            {
                  userInfoInputs = RegistraionInput(email: userInfo.email, password: userInfo.password, firstname: userInfo.firstName, lastname: userInfo.lastName, gender: userInfo.gender, bday: userInfo.birthYear, weight: userInfo.weight, height: userInfo.height)
            }
          
        }
        
        // Do any additional setup after loading the view.
    }


    private func getCurrentInfoArray(for selection: InfoSelection) -> [String]
    {
        switch selection {
        case .height:
            return heightArray
        case .weight:
            return weightArray
        case .birthYear:
            return birthYearsArray
        }
    }
    @IBAction func actionNext(_ sender : UIButton)
    {
        
        isNavigatedBySignUP ? uploadUserInfo() : updateUserInfo()
        
    }
    private func updateUserInfo()
    {
        sharedApp.loader.showLoader(withText: "Updating user info. Please wait...")
        sendUserInfoToServer (false){[weak self] (success, msg) in
            sharedApp.loader.hideLoader()
            guard let `self` = self else {return}
            if success
            {
                let alertOK : AlertAction = ("OK" , .default , nil)
                self.showAlert(withTitle: "Message", msg: "Updated successfully", actions: alertOK)
                
                loginUserInfo?.updateGender(self.userInfoInputs?.gender)
                loginUserInfo?.updateheight(self.userInfoInputs?.height)
                loginUserInfo?.updateWeight(self.userInfoInputs?.weight)
                loginUserInfo?.updateBday(self.userInfoInputs?.bday)
            }
            else
            {
                print(msg ?? "")
            }
        }
    }
    private func uploadUserInfo()
    {
         sharedApp.loader.showLoader(withText: "Registering. Please wait...")
        sendUserInfoToServer(true) {[weak self] (success, msg) in
            sharedApp.loader.hideLoader()
            guard let `self` = self else {return}
            if success
            {
                if let email = self.userInfoInputs?.email , let password = self.userInfoInputs?.password
                {
                self.saveObject(false, forKey: .firstRun)
                Credential.delete()
                let newCredential = Credential.newCredential(forContext: CoreDataStack.dataStack.manageObjectContext)
                newCredential.saveCredential(withEmailID: email , password: password)
                self.performSegue(withIdentifier: "segueSetupMaual", sender: nil)
                }
            }
            else
            {
                let alertOK : AlertAction = ("OK" , .default , nil)
                self.showAlert(withTitle: "Message", msg: msg, actions: alertOK)
            }
        }
       
    }
    private func sendUserInfoToServer( _ isRegistraion : Bool , _ completion : @escaping CompletionHandler)
    {
        for (index, info) in arrInfos.enumerated() {
            if let currentInfo = InfoSelection.init(rawValue : index-1)
            {
                switch currentInfo
                {
                case .birthYear:
                    userInfoInputs?.bday = info.value
                case .height:
                    userInfoInputs?.height = info.value
                case .weight:
                    userInfoInputs?.weight = info.value
                }
            }
            else
            {
                userInfoInputs?.gender = info.value
            }
        }
        
       
        registrationVM.registerUser(userInfoInputs! , isRegistraion, completion)
    }
    
    @IBAction func actionPickerDone(_ sender : UIBarButtonItem)
    {
        let pickerSelectedIndex = pickerComponent.selectedRow(inComponent: 0)
        let selectedData = arrPickerRows[pickerSelectedIndex]
        let selectedInfoSection = selectedInfo.rawValue + 1
        let infoObject = arrInfos[selectedInfoSection]
        infoObject.value = selectedData
        
        collectionBasicInfo.reloadItems(at: [IndexPath.init(item: selectedInfoSection, section: 0)])
        closePickerView()
    }
    
    private func showPickerView()
    {
        if viewPickerComponent.isDescendant(of: view) {return}
        let originFrame = CGRect(x: 0, y: view.bounds.height, width: view.bounds.width, height: 235.0)
        viewPickerComponent.frame = originFrame
        view.addSubview(viewPickerComponent)
        UIView.animate(withDuration: 0.25, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: [.curveEaseIn], animations: { [weak self] in
            guard let `self` = self else {return}
            var rect = self.viewPickerComponent.frame
            rect.origin.y = self.view.bounds.height - rect.height
            self.viewPickerComponent.frame = rect
        }, completion: nil)
    }
    
    private func closePickerView()
    {
        UIView.animate(withDuration: 0.25, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: [.curveEaseOut], animations: {
            [weak self ] in
            guard let `self` = self else {return}
            
            var rect = self.viewPickerComponent.frame
            rect.origin.y = self.view.bounds.height
            self.viewPickerComponent.frame = rect
            
        }) {[weak self ] (isFinished) in
             guard let `self` = self else {return}
            self.viewPickerComponent.removeFromSuperview()
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
extension ProfileViewController : CollectionViewDelegates
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrInfos.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let info = arrInfos[indexPath.item]
        switch indexPath.item {
        case 0:
            let cell = collectionView.dequeReusableCell(for: indexPath) as ProfileViewCell
            cell.model = info
            return cell
        default:
            let cell = collectionView.dequeReusableCell(for: indexPath) as ProfileViewOtherCell
            cell.textLabel.text = info.title
            cell.detailTextLabel.text = info.value
            return cell
        }
       
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 50)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectionIndex = indexPath.item - 1
        if selectionIndex >= 0 ,    let selectionEnum = InfoSelection.init(rawValue : selectionIndex)
        {
            selectedInfo = selectionEnum
            arrPickerRows = getCurrentInfoArray(for: selectedInfo)
            pickerComponent.reloadAllComponents()
            let infoValue = arrInfos[indexPath.item].value
            if let index = arrPickerRows.index(of: infoValue)
            {
                pickerComponent.selectRow(index, inComponent: 0, animated: false)
            }
            showPickerView()
        }
}
}

extension ProfileViewController : UIPickerViewDataSource , UIPickerViewDelegate
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrPickerRows.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrPickerRows[row]
    }
    
}

// MARK: Detail Info Model
class InfoDetail {
    let title : String
    var value : String
    init(_ title : String , _ value : String) {
        self.title = title
        self.value = value
    }
}
