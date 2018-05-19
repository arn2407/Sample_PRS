//
//  BadgesCollectionViewCell.swift
//  PRSMedical
//
//  Created by Arun Kumar on 15/04/18.
//  Copyright © 2018 Arun Kumar. All rights reserved.
//

import UIKit

class BadgesCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var  imageView : UIImageView!
    @IBOutlet weak var labelBadgeName : UILabel!
    @IBOutlet weak var labelBadgeLevel : UILabel!
    @IBOutlet weak var constraintImageHeight : NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        radius = 8.0
        if iPhoneSE
        {
            constraintImageHeight.constant = 50
        }
    }
    
    var isActive : Bool = false
    {
        didSet {
            borderColor = isActive ? #colorLiteral(red: 0.5568627451, green: 0.5568627451, blue: 0.5764705882, alpha: 1) : #colorLiteral(red: 0.8980392157, green: 0.8980392157, blue: 0.9176470588, alpha: 1)
        }
    }
    
}
