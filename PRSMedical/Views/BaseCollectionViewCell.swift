//
//  BaseCollectionViewCell.swift
//  PRSMedical
//
//  Created by Arun Kumar on 29/03/18.
//  Copyright © 2018 Arun Kumar. All rights reserved.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
super.init(coder: aDecoder)
        setupCell()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
    }
    
    func setupCell()  {
        
    }
}
