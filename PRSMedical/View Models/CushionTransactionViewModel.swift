//
//  CushionTransactionViewModel.swift
//  PRSMedical
//
//  Created by Arun Kumar on 27/04/18.
//  Copyright © 2018 Arun Kumar. All rights reserved.
//

import UIKit

class CushionTransactionViewModel: BaseViewModel {
    private var output : Response?
    
    func fetchCushionData(_ request : CushionTransaction , _ completion : @escaping CompletionHandler)  {
        fetchServiceResponse(request, CUSHION_TRANSACTION_UPDATE, completion)
    }
    
    override func setupModel(for value: Any?) {
        super.setupModel(for: value)
        if let response = value as? [String : Any]
        {
            do
            {
                let data = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                self.output = try JSONDecoder().decode(Response.self, from: data)
            }
            catch
            {
                print(error.localizedDescription)
                
            }
            
        }
    }
    var messgae : String {return self.output?.message ?? ""}
}


struct CushionTransaction : Codable
{
    let userid : String
     let cid : String
     let cushionname : String
     let date : String
     let averagesittingtime : String
     let stepcount : String
    let totaltime : String
    
 
}
