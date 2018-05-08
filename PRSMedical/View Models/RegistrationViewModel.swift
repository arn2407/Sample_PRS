//
//  RegistrationViewModel.swift
//  PRSMedical
//
//  Created by Arun Kumar on 12/04/18.
//  Copyright © 2018 Arun Kumar. All rights reserved.
//

import UIKit


class RegistrationViewModel: BaseViewModel {
   
    private var output : Response?
    
    func registerUser(_ input : RegistraionInput , _ isRegistraion : Bool , _ completion : @escaping CompletionHandler)
    {
        fetchServiceResponse(input, isRegistraion ? REGISTRATION_API : UPDATE_API, completion)
    }
    override func setupModel(for value: Any?) {
        super.setupModel(for: value)
        if let response = value as? [String : Any]
        {
            do
            {
                let data = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                 setModelValue(from: data)
            }
            catch
            {
              print(error.localizedDescription)
                
            }
           
        }
        else if let data  = value as? Data
        {
            setModelValue(from: data)
        }
    }
    
    func setModelValue(from data : Data)   {
        do
        {
            self.output = try JSONDecoder().decode(Response.self, from: data)
        }
        catch
        {
            print(error.localizedDescription)
            
        }
    }
    
    
    var messgae : String {return self.output?.message ?? ""}
}

struct RegistraionInput : Codable {
    
    
    var email : String
    var password : String
    let imei = "imei"
    var firstname : String
    var lastname : String
    var gender : String
    var bday : String
    var weight : String
    var height : String
    let webapp = "api"
    let metrices = "metrices"
}

struct Response : Decodable {
    let message : String
    
    enum OutPutKeys : String , CodingKey {
        case message
    }
    init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: OutPutKeys.self)
        self.message = try container.decodeIfPresent(String.self, forKey: .message) ?? ""
    }
}
