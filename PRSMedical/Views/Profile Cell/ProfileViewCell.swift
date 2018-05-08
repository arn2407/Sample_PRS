//
//  ProfileViewCell.swift
//  PRSMedical
//
//  Created by Arun Kumar on 03/04/18.
//  Copyright © 2018 Arun Kumar. All rights reserved.
//

import UIKit

class ProfileViewCell: UICollectionViewCell {
    @IBOutlet weak var textLabel : UILabel!
    @IBOutlet weak var maleView : CircleView!
    @IBOutlet weak var femaleView : CircleView!
    
    var model : InfoDetail? = nil
    {
        didSet {
            guard let info = model else {return}
            maleView.isSelected = info.value == "M"
           femaleView.isSelected = info.value != "M"
            textLabel.text = info.title
        }
    }
}

extension ProfileViewCell : CircleViewTouchEvent
{
    func didTapView(_ view: CircleView) {
        maleView.isSelected = false
        femaleView.isSelected = false
       view.isSelected = true
        
        model?.value = view == maleView ? "M" : "F"
        
    }
}


class ProfileViewOtherCell: UICollectionViewCell {
    @IBOutlet weak var textLabel : UILabel!
    @IBOutlet weak var detailTextLabel : UILabel!
}
