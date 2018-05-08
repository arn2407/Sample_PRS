//
//  ForgotPasswordViewModel.swift
//  PRSMedical
//
//  Created by Lucideus  on 5/3/18.
//  Copyright © 2018 Arun Kumar. All rights reserved.
//

import UIKit

class ForgotPasswordViewModel: BaseViewModel {
    var response : ChangedPasswordResponse?
    func resetPassword(_ request : CushionForgotPassword , _ completion : @escaping CompletionHandler)  {
        fetchServiceResponse(request, CUSHION_FORGOT_PASSWORD, completion)
    }
    override func setupModel(for value: Any?) {
        super.setupModel(for: value)
        if let response = value as? [String : Any]
        {
            do {
                let data = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
            self.response = try JSONDecoder().decode(ChangedPasswordResponse.self, from: data)
            }
            catch{}
        }
    }
}
struct CushionForgotPassword : Codable {    let email : String }
struct ChangedPasswordResponse : Decodable {
    let code : String
    let message : String
    enum CodingKeys : String , CodingKey {
        case code
        case message = "messagee"
    }
    init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.code = try container.decodeIfPresent(String.self, forKey: .code) ?? ""
        self.message = try container.decodeIfPresent(String.self, forKey: .message) ?? ""
    }
}
