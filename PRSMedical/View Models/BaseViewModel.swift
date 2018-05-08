//
//  BaseViewModel.swift
//  PRSMedical
//
//  Created by Arun Kumar on 12/04/18.
//  Copyright © 2018 Arun Kumar. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class BaseViewModel : NSObject
{
    func fetchServiceResponse<T : Codable>(_ input : T , _ urlString : String , _ completion : @escaping CompletionHandler)  {
        
        do {
            let data =   try JSONEncoder().encode(input)
            let parameters = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as! [String : Any]
            Alamofire.request(
                urlString.getFullURL,
                method: .post,
                parameters: parameters)
                .validate()
                .responseJSON {[weak self] (response) -> Void in
                    guard let `self` = self else {return}
                    guard response.result.isSuccess else {
                        print("Error while fetching remote rooms: \(response.result.error?.localizedDescription ?? "")")
                       self.setupModel(for: response.data)
                        completion(false , response.result.error?.localizedDescription)
                        return
                    }
                    self.setupModel(for: response.value)
                    
                    completion(true , nil)
            }
            
        } catch let error {
            completion(false , error.localizedDescription)
        }
       
    }
    
    func setupModel(for value : Any?){
        
    }
    
}
