//
//  CushionDataUploadViewModel.swift
//  PRSMedical
//
//  Created by Arun Kumar on 27/04/18.
//  Copyright © 2018 Arun Kumar. All rights reserved.
//

import UIKit

class CushionDataUploadViewModel: BaseViewModel {
    
    private var output : Response?
    
    func fetchCushionData(_ request : CushionData , _ completion : @escaping CompletionHandler)  {
        fetchServiceResponse(request, CUSHION_UPDTE_API, completion)
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
struct CushionData : Codable {
    
    let userid : String
    let cushionid : String
    let activestate : String
    let occupiedstate : String
    let currentTimeSetting : String
    let vibrationstate : String
    let cushionBaseTime : String
    let batteryPercentage : String
    let batteryvoltage : String
    let faulty : String
    let fault : String = ""
    
}
