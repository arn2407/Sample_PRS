//
//  LoaderView.swift
//  PRSMedical
//
//  Created by Lucideus  on 4/6/18.
//  Copyright © 2018 Arun Kumar. All rights reserved.
//

import UIKit
import JGProgressHUD


class LoaderView: NSObject {
    private let backgroundColor : UIColor
    static let shared : LoaderView = LoaderView(backgroundColor: UIColor.white)
    
  private  init(backgroundColor : UIColor ) {
        self.backgroundColor = backgroundColor
        super.init()
        self.setupLoader()
    }
    private var loader : UIImageView!
    private lazy var backgroundView : UIView = {
        let v = UIView()
        v.backgroundColor = self.backgroundColor
        return v
    }()
    private let textLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 0.5019607843, green: 0.7058823529, blue: 0.2549019608, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 20.0)
        label.numberOfLines = 0
        return label
    }()
    private func setupLoader()
    {
        guard let window = UIApplication.shared.keyWindow else {return}
        backgroundView.frame = window.bounds
        window.addSubview(backgroundView)
        
        loader = UIImageView()
        window.addSubview(loader)
        window.addConstraints("V:|-120-[v0]", views: loader)
        loader.centerXAnchor.constraint(equalTo: window.centerXAnchor).isActive = true
        loader.widthAnchor.constraint(equalToConstant: 105).isActive = true
        loader.heightAnchor.constraint(equalToConstant: 105).isActive = true
        
        window.addSubview(textLabel)
        window.addConstraints("V:[v0]-65-[v1]", views: loader,textLabel)
        window.addConstraints("H:|-16-[v0]-16-|", views: textLabel)
        
        textLabel.isHidden = true
        loader.isHidden = true
    }
    
    func showLoader(_ text : String = "Loading...")
    {
        textLabel.text = text
        loader.animationImages = (1...7).compactMap{UIImage.init(named: "Loader_\($0)")}
      loader.animationDuration = 1
        loader.animationRepeatCount = 0
        loader.startAnimating()
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: [.curveEaseIn], animations: {
            [weak self] in
            guard let `self` = self else {return}
            self.backgroundView.alpha = 1.0
            self.loader.isHidden = false
            self.textLabel.isHidden = false
        }, completion: nil)
    }
    func hideLoader()  {
        
        UIView.animate(withDuration: 0.2, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: [.curveEaseOut], animations: {
            [weak self] in
            guard let `self` = self else {return}
            self.backgroundView.alpha = 0.0
            self.loader!.isHidden = true
            self.textLabel.isHidden = true
        }) {[weak self] (_) in
            guard let `self` = self else {return}
            
             self.loader.stopAnimating()
            self.loader.image = nil
        }
    }
    
}


class ApplicationLoader : NSObject
{
    private let loader : JGProgressHUD = {
        let hud = JGProgressHUD(style: .dark)
        return hud
    }()

    
    public func showLoader(withText text : String = "Loading...")
    {
        guard let window = UIApplication.shared.keyWindow else { return  }
        loader.textLabel.text = text
        loader.show(in: window)
    }
    public func hideLoader()
    {
        loader.dismiss(afterDelay: 0.0)
    }
}
