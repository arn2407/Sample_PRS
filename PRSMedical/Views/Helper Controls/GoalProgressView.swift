//
//  GoalProgressView.swift
//  PRSMedical
//
//  Created by Arun Kumar on 12/04/18.
//  Copyright © 2018 Arun Kumar. All rights reserved.
//

import UIKit

@IBDesignable
class GoalProgressView: UIView {

    @IBInspectable var trackColor : UIColor = #colorLiteral(red: 0.8196078431, green: 0.8196078431, blue: 0.8392156863, alpha: 1)
    {
        didSet{
            setNeedsDisplay()
        }
    }
    @IBInspectable var progressColor : UIColor = #colorLiteral(red: 0.3568627451, green: 0.768627451, blue: 0.4941176471, alpha: 1)
        {
        didSet{
            setNeedsDisplay()
        }
    }
    @IBInspectable var progress : CGFloat = 20
        {
        didSet{
            setNeedsDisplay()
        }
    
    }
    
    @IBInspectable var goalHour : CGFloat = 1
        {
        didSet{
            setNeedsDisplay()
        }
    }
    
    private func getPath(_ endAngle : CGFloat , _ rect : CGRect) -> UIBezierPath
    {
        let startAng = CGFloat(-Double.pi/2)
        let endAng =  endAngle + startAng
        let center = CGPoint(x: rect.width/2, y: rect.height/2)
        let radius = rect.height/2 - 5
        return UIBezierPath(arcCenter: center, radius: radius, startAngle: startAng, endAngle: endAng, clockwise: true)
    }
    
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        trackColor.setStroke()
        
        let trackPath = getPath(CGFloat(Double.pi * 2) , rect)
        trackPath.lineWidth = 4.0
        trackPath.stroke()
        
        //convert time to radian
        var endAngle = progress * 6
        let goal = 360*goalHour
        endAngle = CGFloat(2*Double.pi) * endAngle / goal
        
        let progressPath = getPath(endAngle , rect)
        progressPath.lineWidth = 9.0
        progressPath.lineCapStyle = .round
        progressColor.setStroke()
        progressPath.stroke()
        
        
    }
  

}
