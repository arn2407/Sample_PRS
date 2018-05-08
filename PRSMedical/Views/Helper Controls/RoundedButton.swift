//
//  RoundedButton.swift
//  PRSMedical
//
//  Created by Arun Kumar on 20/03/18.
//  Copyright © 2018 Arun Kumar. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {

    @IBInspectable var color : UIColor = #colorLiteral(red: 0.9646214843, green: 0.9647598863, blue: 0.9645913243, alpha: 1)
        {
        didSet {
            setNeedsDisplay()
        }
    }
    @IBInspectable var cornerRadius : CGFloat = 1.0
        {
        didSet{
            setNeedsDisplay()
        }
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        let bezierPath = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius*aspectRatio)
        color.setFill()
        bezierPath.fill()
    }

}
