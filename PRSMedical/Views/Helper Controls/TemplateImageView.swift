//
//  TemplateImageView.swift
//  PRSMedical
//
//  Created by Arun Kumar on 16/03/18.
//  Copyright © 2018 Arun Kumar. All rights reserved.
//

import UIKit

@IBDesignable
class TemplateImageView: UIImageView {

    @IBInspectable var templateImage : UIImage? {
        didSet{
            image = templateImage?.withRenderingMode(.alwaysTemplate)
        }
    }

}
