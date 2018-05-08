//
//  TabBarItemCollectionCell.swift
//  PRSMedical
//
//  Created by Arun Kumar on 29/03/18.
//  Copyright © 2018 Arun Kumar. All rights reserved.
//

import UIKit

class TabBarItemCollectionCell: BaseCollectionViewCell {
    
    private let normalColor = #colorLiteral(red: 0.5647058824, green: 0.5882352941, blue: 0.6274509804, alpha: 1)
    private let selectedColor = #colorLiteral(red: 0.1960784314, green: 0.3960784314, blue: 0.6862745098, alpha: 1)
    
    let textLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = #colorLiteral(red: 0.5647058824, green: 0.5882352941, blue: 0.6274509804, alpha: 1)
        label.textAlignment = .center
        return label
        
    }()
    let imageView : UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "dashboard_tab_icon").withRenderingMode(.alwaysTemplate))
        iv.tintColor = #colorLiteral(red: 0.5647058824, green: 0.5882352941, blue: 0.6274509804, alpha: 1)
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    func setImage(image : UIImage?) {
        imageView.image = image?.withRenderingMode(.alwaysTemplate)
    }
    
    override func setupCell() {
        super.setupCell()
        backgroundColor = #colorLiteral(red: 0.9764705882, green: 0.9764705882, blue: 0.9764705882, alpha: 1)
        
        let stackView = UIStackView(arrangedSubviews: [imageView , textLabel])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 0
        imageView.heightAnchor.constraint(equalToConstant: 25.0).isActive = true
        
        addSubview(stackView)
        addConstraints("H:|[v0]|", views: stackView)
        addConstraints("V:|-6.1-[v0]|", views: stackView)
        
        
    }
    
    override var isSelected: Bool
        {
        didSet {
            let color = isSelected ? selectedColor : normalColor
            textLabel.textColor = color
            imageView.tintColor = color
            
            backgroundColor = isSelected ? .white : #colorLiteral(red: 0.9764705882, green: 0.9764705882, blue: 0.9764705882, alpha: 1)
        }
    }
    
}
