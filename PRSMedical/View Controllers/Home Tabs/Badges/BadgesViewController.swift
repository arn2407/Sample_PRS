//
//  BadgesViewController.swift
//  PRSMedical
//
//  Created by Arun Kumar on 15/04/18.
//  Copyright © 2018 Arun Kumar. All rights reserved.
//

import UIKit

class BadgesViewController: UIViewController {

    @IBOutlet weak var collectionBadges : UICollectionView!
    
    class BadgeInfo
    {
        var image : UIImage?
        let badgeName : String
        let badgeLevel : String
        var levelDescription  = ""
        init(_ name : String , level : String , image : UIImage) {
            self.badgeName = name
            self.badgeLevel = level
            self.image = image
        }
    }
    
    private let badges = [BadgeInfo.init("Ice Breaker", level: "Level 1", image: #imageLiteral(resourceName: "iceActive")),
                                        BadgeInfo.init("Healthy Heart", level: "Level 1", image: #imageLiteral(resourceName: "heartActive")),
                                        BadgeInfo.init("Standing Tall", level: "Level 0", image: #imageLiteral(resourceName: "tall")),
                                        BadgeInfo.init("Social Butterfly", level: "Level 0", image: #imageLiteral(resourceName: "butterfly")),
                                        BadgeInfo.init("Weekday Warrior", level: "Level 0", image: #imageLiteral(resourceName: "warrior")),
                                        BadgeInfo.init("Star Collector", level: "Level 0", image: #imageLiteral(resourceName: "star")),
                                        BadgeInfo.init("Big Bragger", level: "Level 0", image: #imageLiteral(resourceName: "bragger")),
                                        BadgeInfo.init("Reward Name", level: "Level 0", image: #imageLiteral(resourceName: "heart")),
                                        BadgeInfo.init("Super Ninja", level: "Level 0", image: #imageLiteral(resourceName: "ninja"))]
    @IBOutlet weak var constraintLeadingWidthCollection : NSLayoutConstraint!
    @IBOutlet weak var constraintTrailingWidthCollection : NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
constraintLeadingWidthCollection.constant = deviceSize.width * 42 / 375
        constraintTrailingWidthCollection.constant = deviceSize.width * 42 / 375
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? BadgesCollectionViewCell , let indexPath = collectionBadges.indexPath(for: cell)
        {
              let badge = badges[indexPath.item]
            let detailVC = segue.destination as! BadgesDetailViewController
            detailVC.info = badge
        }
    }
  

}
extension BadgesViewController : CollectionViewDelegates
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return badges.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeReusableCell(for: indexPath) as BadgesCollectionViewCell
        let badge = badges[indexPath.item]
        cell.imageView.image = badge.image
        cell.labelBadgeName.text = badge.badgeName
        cell.labelBadgeLevel.text = badge.badgeLevel
        cell.isActive = indexPath.item == 0 || indexPath.item == 1
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = deviceSize.width * 90 / 375
        let height = aspectRatio * 120
        
        return CGSize(width: width, height: height)
    }
}
