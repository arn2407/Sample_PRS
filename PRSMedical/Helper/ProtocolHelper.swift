//
//  ProtocolHelper.swift
//  PRSMedical
//
//  Created by Arun Kumar on 16/03/18.
//  Copyright © 2018 Arun Kumar. All rights reserved.
//

import UIKit
import Foundation


protocol ClassIdentifier {
    static var identifier : String {get}
}

extension ClassIdentifier where Self : Any
{
    static var identifier : String { return String(describing: self) }
}



extension UIViewController : ClassIdentifier
{
    func getViewController<T : UIViewController>() -> T  {
        guard  let sb = storyboard else {
            fatalError("No storyboard for \(T.identifier) is found.")
        }
        return sb.viewController() as T
    }
}
extension UIStoryboard
{
    func viewController<T : UIViewController>() -> T {
        guard let vc = instantiateViewController(withIdentifier: T.identifier) as? T else {
            fatalError("\(T.identifier) view controller is not found in your storyboard")
        }
        return vc
    }
}

extension UICollectionViewCell : ClassIdentifier {}


extension UICollectionView
{
    func registerCell(type : UICollectionViewCell.Type) {
        register(type, forCellWithReuseIdentifier: type.identifier)
    }
    public func dequeReusableCell<T : UICollectionViewCell>(for indexPath : IndexPath) -> T
    {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath) as? T else {
            fatalError("\(T.identifier) cell identifier is not found in this Table")
        }
        return cell
    }
}


extension UITableViewCell : ClassIdentifier {}


extension UITableView
{
    func registerCell(type : UITableViewCell.Type) {
        register(type, forCellReuseIdentifier: type.identifier)
    }
    public func dequeReusableCell<T : UITableViewCell>(for indexPath : IndexPath) -> T
    {
        guard let cell = dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as? T else {
            fatalError("\(T.identifier) cell identifier is not found in this Table")
        }
        return cell
    }
}
