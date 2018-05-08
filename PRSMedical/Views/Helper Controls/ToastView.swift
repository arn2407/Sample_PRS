//
//  ToastView.swift
//  PRSMedical
//
//  Created by Arun Kumar on 23/04/18.
//  Copyright © 2018 Arun Kumar. All rights reserved.
//

import UIKit

class ToastView: NSObject {

    static let toast = ToastView()
    
    private let toastView : UIView = {
        let vw = UIView()
        vw.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        vw.clipsToBounds = true
        vw.radius = 10
           return vw
    }()
    
    private let label : UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private var bottomConstraintToastView : NSLayoutConstraint?
    
    private override init() {
        guard let window = UIApplication.shared.keyWindow else {return}
        
        toastView.addSubview(label)
        toastView.addConstraints("H:|-8-[v0]-8-|", views: label)
        toastView.addConstraints("V:|-8-[v0]-8-|", views: label)
        
        window.addSubview(toastView)
        toastView.alpha = 0.0
        
        window.addConstraints("H:|-24-[v0]-24-|", views: toastView)
        window.addConstraints("V:[v0(40)]", views: toastView)
      self.bottomConstraintToastView = NSLayoutConstraint(item: window, attribute: .bottom, relatedBy: .equal, toItem: toastView, attribute: .bottom, multiplier: 1.0, constant: 64.0)
        self.bottomConstraintToastView?.isActive = true
    }
    
    
    func showToast(with text : String? = "Some Error found")  {
        self.toastView.alpha = 1.0
        label.text = text
       animateToastView(false)
        self.perform(#selector(hideToast), with: nil, afterDelay: 3.0)
    }
  @objc  func hideToast()  {
        animateToastView(true)
    }
    
    private func animateToastView(_ isHidden : Bool)
    {
         guard let window = UIApplication.shared.keyWindow else {return}
        window.layoutIfNeeded()
        bottomConstraintToastView?.constant = isHidden ?  -44 : 64
        UIView.animate(withDuration: 0.2, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: [!isHidden ? .curveEaseIn : .curveEaseOut], animations: {
            window.layoutIfNeeded()
        }) {[weak self] (_) in
            guard let `self` = self else {return}
            if  isHidden {self.toastView.alpha = 0.0}
        }
    }
    
    
    
}
