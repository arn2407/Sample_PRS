//
//  CircleView.swift
//  PRSMedical
//
//  Created by Arun Kumar on 03/04/18.
//  Copyright © 2018 Arun Kumar. All rights reserved.
//

import UIKit

@objc protocol CircleViewTouchEvent :  NSObjectProtocol {
    func didTapView(_ view : CircleView)
}

@IBDesignable
class CircleView: UIView {

@IBOutlet weak var delegate : CircleViewTouchEvent?
    
    @IBInspectable var color : UIColor = #colorLiteral(red: 0.8470588235, green: 0.8470588235, blue: 0.8470588235, alpha: 1)
        {
        didSet {
            setNeedsDisplay()
        }
    }
    @IBInspectable var border : UIColor = #colorLiteral(red: 0.8470588235, green: 0.8470588235, blue: 0.8470588235, alpha: 1)
        {
        didSet {
            setNeedsDisplay()
        }
    }
    @IBInspectable var isSelected : Bool = false
        {
        didSet {
            setNeedsDisplay()
            if let imageView = viewWithTag(100) as? UIImageView , let image = imageView.image
            {
                imageView.image = image.withRenderingMode(.alwaysTemplate)
                imageView.tintColor = isSelected ? .white : .black
            }
        }
    }
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        
        let circlePath = UIBezierPath(ovalIn: rect)
        
        let getColor : UIColor = isSelected ? #colorLiteral(red: 0.1960784314, green: 0.3960784314, blue: 0.6862745098, alpha: 1) : color
        
        getColor.setFill()
        circlePath.fill()
        
        border.setStroke()
        circlePath.lineWidth = 0.5
        circlePath.stroke()

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.didTapView(self)
    }
   

}
