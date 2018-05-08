//
//  PlusMinusButton.swift
//  PRSMedical
//
//  Created by Arun Kumar on 23/04/18.
//  Copyright © 2018 Arun Kumar. All rights reserved.
//

import UIKit

@IBDesignable
class PlusMinusButton: UIButton {
    private struct Constants {
        static let plusLineWidth: CGFloat = 3.0
        static let plusButtonScale: CGFloat = 0.6
        static let halfPointShift: CGFloat = 0.5
    }
    
    private var halfWidth: CGFloat {
        return bounds.width / 2
    }
    
    private var halfHeight: CGFloat {
        return bounds.height / 2
    }
    @IBInspectable var fillColor : UIColor = #colorLiteral(red: 1, green: 0.1921568627, blue: 0.2274509804, alpha: 1)
    {
        didSet{
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var plus : Bool = false
        {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        fillColor.setFill()
       let bezierPath = UIBezierPath(ovalIn: rect)
        bezierPath.fill()
        
     
        
        let plusWidth: CGFloat = min(bounds.width, bounds.height) * Constants.plusButtonScale
        let halfPlusWidth = plusWidth / 2
        
        let plusPath = UIBezierPath()
        
        //set the path's line width to the height of the stroke
        plusPath.lineWidth = Constants.plusLineWidth
        
        //move the initial point of the path
        //to the start of the horizontal stroke
        plusPath.move(to: CGPoint(
            x: halfWidth - halfPlusWidth + Constants.halfPointShift,
            y: halfHeight + Constants.halfPointShift))
        
        //add a point to the path at the end of the stroke
        plusPath.addLine(to: CGPoint(
            x: halfWidth + halfPlusWidth + Constants.halfPointShift,
            y: halfHeight + Constants.halfPointShift))
        
        
        if plus
        {
            plusPath.move(to: CGPoint(
                x: halfWidth + Constants.halfPointShift,
                y: halfHeight - halfPlusWidth + Constants.halfPointShift))
            
            //add a point to the path at the end of the stroke
            plusPath.addLine(to: CGPoint(
                x: halfWidth  + Constants.halfPointShift,
                y: halfHeight + halfPlusWidth + Constants.halfPointShift))
        }
        
           UIColor.white.setStroke()
        plusPath.stroke()
        
   
    }


}
