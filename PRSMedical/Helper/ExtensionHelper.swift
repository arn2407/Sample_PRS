//
//  ExtensionHelper.swift
//  PRSMedical
//
//  Created by Arun Kumar on 18/03/18.
//  Copyright © 2018 Arun Kumar. All rights reserved.
//

import Foundation
import UIKit
import CoreData

import MaterialComponents


typealias CollectionViewDelegates = UICollectionViewDataSource & UICollectionViewDelegate & UICollectionViewDelegateFlowLayout
typealias TableViewDelegates = UITableViewDataSource & UITableViewDelegate
typealias CompletionHandler = (Bool , String?) -> ()
typealias AlertAction = (String , UIAlertActionStyle , ((UIAlertAction) -> Void)?)

let mainQueue = DispatchQueue.main

let deviceSize = UIScreen.main.bounds

let aspectRatio = deviceSize.height / 667.0

let iPhonX = UIScreen.main.nativeBounds.height == 2436



var isNavigatedBySignUP = false

var loginUserInfo : LoginViewModel?

var userEmailID = ""


enum UserDefaultsKeys : String {
    case firstRun
}


extension NSObject
{
    public func addNotification(notification name : NSNotification.Name , selector : Selector , object : Any? = nil) -> () {
        NotificationCenter.default.addObserver(self, selector: selector, name: name, object: object)
    }
    public func removeNotification(notification name : NSNotification.Name) -> () {
        NotificationCenter.default.removeObserver(self, name: name, object: nil)
    }
    public func postNotification(notification name : NSNotification.Name , object : Any? = nil) -> () {
        NotificationCenter.default.post(name: name, object: object)
    }
    
    func saveObject(_ obj : Any? , forKey : UserDefaultsKeys)  {
        UserDefaults.standard.set(obj, forKey: forKey.rawValue)
        UserDefaults.standard.synchronize()
    }
    func getValue(forKey key : UserDefaultsKeys) -> Any? {
        return UserDefaults.standard.value(forKey: key.rawValue)
    }
    
}



extension UIView
{
    /// To add constraints on views
    func addConstraints(_ vfs : String , views : UIView...)  {
        var viewDict = [String : Any]()
        views.enumerated().forEach{
            viewDict["v\($0.offset)"] = $0.element
            $0.element.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate(
        NSLayoutConstraint.constraints(withVisualFormat: vfs, options: .init(rawValue: 0), metrics: nil, views: viewDict)
        )
    }
    
    var radius : CGFloat
    {
        get {return layer.cornerRadius}
        set{
            clipsToBounds = true
            layer.cornerRadius = newValue
        }
    }
    var borderColor : UIColor?
    {
        get {return nil}
        set{
            guard let color = newValue else {
                return
            }
            clipsToBounds = true
            layer.borderWidth = 1.0
            layer.borderColor = color.cgColor
        }
    }
    
    
    
}



extension UIViewController
{
    
    func getTabBarController() -> MainTabBarViewController? {
        guard let nav = sharedApp.window?.rootViewController as? UINavigationController , let tab = nav.viewControllers.last as? MainTabBarViewController
            else {return nil}
        return tab
    }
    
    func addAppBar() -> MDCAppBar
    {
        let appBar : MDCAppBar = {
            let bar =  MDCAppBar()
            bar .headerViewController.headerView.backgroundColor = #colorLiteral(red: 0.1960784314, green: 0.3960784314, blue: 0.6862745098, alpha: 1)
            bar.navigationBar.tintColor = .white
            bar.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
            return bar
        }()
        self.addChildViewController(appBar.headerViewController)
   
        appBar.addSubviewsToParent()
        
        return appBar
    }
    
    func pushTo(vc : UIViewController)
    {
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func popToVC(_ sender : Any)
    {
        _ = navigationController?.popViewController(animated: true)
    }
    @IBAction func dismissVC(_ sender : Any)
    {
        dismiss(animated: true, completion: nil)
    }
  
 
    
    func showAlert(withTitle title : String? = nil , msg : String? = nil , alertType : UIAlertControllerStyle = .alert , actions : AlertAction...)
    {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: alertType)
        
        for action in  actions
        {
            let alertAction = UIAlertAction(title: action.0, style: action.1, handler: action.2)
            alert.addAction(alertAction)
        }
        
        
        
        mainQueue.async {
            [weak self] in
            guard let `self` = self else {return}
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}


extension Int
{
    var formattedTime : String {
        let hour = self/60
        let min = self%60
        let hourString = hour > 1 ? "hours" : "hour"
        let minuteString = min > 1 ? "minutes" : "minute"
        return "\(hour) \(hourString) \(min) \(minuteString)"
    }
}

extension String
{
    var getFullURL : URL {
        guard let url = URL(string: "http://api.pinprox.com:7777/\(self)") else {  fatalError() }
        return url
    }
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    func getDate(for format : String) -> Date?
    {
        let df = DateFormatter()
        df.dateFormat = format
    return df.date(from: self)
    }
    
}
extension Date
{
    func getString(for format : String) -> String
    {
        let df = DateFormatter()
        df.dateFormat = format
        return df.string(from: self)
    }
}
extension Notification.Name
{
    static let disconnectCushion = Notification.Name("kNotificationDisconnectCushions")
    static let foundCushion = Notification.Name("kNotificationFoundCushion")
     static let connectCushion = Notification.Name("kNotificationConnectCushion")
     static let diconnectCushion = Notification.Name("kNotificationDisconnectCushion")
     static let updateState = Notification.Name("kNotificationUpdateState")
     static let updateCushion = Notification.Name("kNotificationUpdateCushion")
     static let cushionTimerStart = Notification.Name("kNotificationCushionTimeStarted")
     static let cushionTimerStopped = Notification.Name("kNotificationCushionTimerStopped")
    static let forgroundUpdate = Notification.Name("kNotificationForgroundUpdate")
    static let cushionChargingStatusChanged = Notification.Name("kNotificationChargingStatus")
    
}

extension NSManagedObject
{
    @nonobjc public class func newEntity<T : NSManagedObject>(forContext context : NSManagedObjectContext) -> T
    {
        let entityName = String(describing: T.self)
        guard let entity = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context) as? T else {fatalError("NO Enity of this \(entityName) is available")}
        return entity
    }
}
extension UITextField {
    func togglePasswordVisibility() {
        isSecureTextEntry = !isSecureTextEntry
        
        if let existingText = text {
            deleteBackward()
            if let textRange = textRange(from: beginningOfDocument, to: endOfDocument) {
                replace(textRange, withText: existingText)
            }
        }
    }
    
    func addLeadingIcon(_ icon : UIImage)  {
        let leftIconView = UIImageView(image: icon)
        leftIconView.contentMode = .scaleAspectFit
        leftIconView.frame = CGRect(x: 0, y: 0, width: 30, height: 23)
        leftView = leftIconView
        leftViewMode = .always
    }
}

infix operator >>> : BitwiseShiftPrecedence

func >>> (lhs: Int64, rhs: Int64) -> Int64 {
    return Int64(bitPattern: UInt64(bitPattern: lhs) >> UInt64(rhs))
}

