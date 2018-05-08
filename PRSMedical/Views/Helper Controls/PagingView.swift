//
//  PagingView.swift
//  PRSMedical
//
//  Created by Arun Kumar on 16/03/18.
//  Copyright © 2018 Arun Kumar. All rights reserved.
//

import UIKit

@IBDesignable
class PagingView: UIView {

    @IBInspectable var color : UIColor = #colorLiteral(red: 0.5019607843, green: 0.7058823529, blue: 0.2549019608, alpha: 1)
    {
        didSet{
            setNeedsDisplay()
        }
    }
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        let bezierPath = UIBezierPath(ovalIn: rect)
        color.setFill()
        bezierPath.fill()
    }
 

}
