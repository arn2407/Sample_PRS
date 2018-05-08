//
//  MainTabBarViewController.swift
//  PRSMedical
//
//  Created by Arun Kumar on 28/03/18.
//  Copyright © 2018 Arun Kumar. All rights reserved.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    var userInfoInputs : RegistraionInput?
    
    let bluetoothManager = BluetoothManager()
    var foundPeripherals = [RKPeripheral]()
    
    private lazy var tabItemsView : UICollectionView = {
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = UIScreen.main.bounds.size
        flowLayout.scrollDirection = .horizontal
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        
        cv.backgroundColor = .white
        cv.dataSource = self
        cv.delegate = self
        cv.registerCell(type: TabBarItemCollectionCell.self)
        return cv
        
    }()
    
    private struct TabbarItem
    {
        let image : UIImage
        let name : String
    }
    
    private let Items = [TabbarItem(image: #imageLiteral(resourceName: "dashboard_tab_icon"), name: "Dashboard"),
                                       TabbarItem(image: #imageLiteral(resourceName: "badges_tab_icon"), name: "Badges"),
                                       TabbarItem(image: #imageLiteral(resourceName: "cushion_tab_icon"), name: "Cushions"),
                                       TabbarItem(image:#imageLiteral(resourceName: "setting_tab_icon"), name: "Settings")]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewControllersOnSignupNavigation()
        
        self.tabBar.isHidden = true
       
        view.addSubview(tabItemsView)
         let height = tabBar.bounds.height
        view.addConstraints("H:|[v0]|", views: tabItemsView)
        tabItemsView.heightAnchor.constraint(equalToConstant: height).isActive = true
        tabItemsView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        let selectItem = isNavigatedBySignUP ? 3 : 0
        
        if !isNavigatedBySignUP && !Cushion.getAllCushions().isEmpty
        {
            startScanning()
        }
       
        selectTabIndex = selectItem
      
        if iPhonX
        {
            let bottomView = UIView()
            bottomView.backgroundColor = #colorLiteral(red: 0.9764705882, green: 0.9764705882, blue: 0.9764705882, alpha: 1)
            view.addSubview(bottomView)
            view.addConstraints("H:|[v0]|", views: bottomView)
            view.addConstraints("V:[v0]-0-[v1]|", views: tabItemsView,bottomView)
            
        }
        UIApplication.shared.setStatusBarStyle(.lightContent, animated: true)
        // Do any additional setup after loading the view.
    }
  
    var selectTabIndex : Int = 0
    {
        didSet
        {
           tabItemsView.selectItem(at: IndexPath.init(item: selectTabIndex, section: 0), animated: false, scrollPosition: .left)
            selectedIndex = selectTabIndex
        }
    }
    
    private func setupViewControllersOnSignupNavigation()
    {
        if isNavigatedBySignUP
        {
            let profileVC = self.getViewController() as ProfileViewController
            profileVC.userInfoInputs = userInfoInputs 
            let rootNav = self.viewControllers!.remove(at: 3) as! UINavigationController
            var navViewControllers = rootNav.viewControllers
            navViewControllers.insert(profileVC, at: 1)
            rootNav.viewControllers = navViewControllers
            self.viewControllers?.append(rootNav)
        }
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
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
        self.bluetoothManager.stopScanning()
    }

}

extension MainTabBarViewController : CollectionViewDelegates
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeReusableCell(for: indexPath) as TabBarItemCollectionCell
        
        let item = Items[indexPath.item]
        cell.textLabel.text = item.name
        cell.setImage(image: item.image)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (collectionView.bounds.width / CGFloat(Items.count)) - 2
        
        return CGSize(width: width, height: collectionView.bounds.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedIndex == indexPath.item
        {
           (viewControllers?[indexPath.item] as! UINavigationController).popToRootViewController(animated: true)
            return
        }
        selectedIndex = indexPath.item
    }
    
}

/// Cushion connection setup
extension MainTabBarViewController : BluetoothManagerDelegate
{
    func startScanning()  {
        
        bluetoothManager.delegate = self
       bluetoothManager.setup()
        bluetoothManager.start(true)
    }
    func foundCushion(_ peripheral: RKPeripheral) {
        self.foundPeripherals += [peripheral]
        postNotification(notification: .foundCushion, object: peripheral)
    }
    func updateState(_ state: CBManagerState) {
        postNotification(notification: .updateState, object: state)
    }
    func didCushionConnect(_ cushion: CushionServer) {
        cushion.delegate = self
        postNotification(notification: .connectCushion, object: cushion)
    }
    func didCushionDisconnect(_ cushion: CushionServer) {
        
        postNotification(notification: .disconnectCushion, object: cushion)
        
    }
}

extension MainTabBarViewController : CushionServerDelegate
{
    func connectedDidChange(_ server: CushionServer) {
        postNotification(notification: .updateCushion, object: server)
    }
    func cushionTimerStarted(_ server: CushionServer) {
         postNotification(notification: .cushionTimerStart, object: server)
    }
    func cushionTimerStopped(_ server: CushionServer) {
         postNotification(notification: .cushionTimerStopped, object: server)
    }
    
}




