//
//  WalkThroughViewController.swift
//  PRSMedical
//
//  Created by Arun Kumar on 12/03/18.
//  Copyright © 2018 Arun Kumar. All rights reserved.
//

import UIKit

class WalkThroughViewController: UIViewController {
    @IBOutlet weak var collectionView : UICollectionView!
    @IBOutlet weak var pageStackView : UIStackView!
  
    private var isMoved = false
    
   
    
    enum WalkThroughEnum : Int {
        case sit , move , healthy
        
        func getWalkThroughModel() -> (String , String , UIImage?) {
            switch self {
            case .sit:
                return ("SIT" , "When you have regular breaks from sitting, your health and posture will improve." , #imageLiteral(resourceName: "sit_image"))
            case .move:
                  return ("MOVE" , "Oasis will remind you when you need to get up and move." , #imageLiteral(resourceName: "move_image"))
            default:
                return ("BE HEALTHY" , "Be happy knowing you have taken a big step towards a healthier you!" , #imageLiteral(resourceName: "healthy_image"))
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        // Do any additional setup after loading the view.
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    @IBAction func actionSkip(_ sender : UIButton)
    {
          goToHome()
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
extension WalkThroughViewController : UICollectionViewDataSource , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let walktuple = WalkThroughEnum(rawValue: indexPath.item)!.getWalkThroughModel()
        let labelTitle = cell.viewWithTag(100) as? UILabel
        labelTitle?.text = walktuple.0
        
        let labelDescription = cell.viewWithTag(101) as? UILabel
        labelDescription?.text = walktuple.1
        
        let imageView = cell.viewWithTag(102) as? UIImageView
        imageView?.image = walktuple.2
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 413.5 * aspectRatio)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isMoved {return}
        if scrollView.contentOffset.x / scrollView.bounds.width > 2
        {
            isMoved = true
           goToHome()
        }
        
        
    }
    
    private func goToHome()
    {
        performSegue(withIdentifier: "segueHome", sender: nil)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        updatePagingIndicator()
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate
        {
            updatePagingIndicator()
        }
    }
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        updatePagingIndicator()
    }
    
    private func updatePagingIndicator()
    {
        let index = Int(collectionView.contentOffset.x / collectionView.bounds.width)
      
        pageStackView.arrangedSubviews.enumerated().forEach({ (offset , page) in
            let color : UIColor = offset == index ? #colorLiteral(red: 0.5019607843, green: 0.7058823529, blue: 0.2549019608, alpha: 1) : #colorLiteral(red: 0.5019607843, green: 0.7058823529, blue: 0.2549019608, alpha: 0.2)
            (page as! PagingView).color = color
        })
    }
}
