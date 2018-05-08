//
//  LoginViewModel.swift
//  PRSMedical
//
//  Created by Arun Kumar on 12/04/18.
//  Copyright © 2018 Arun Kumar. All rights reserved.
//

import UIKit

class LoginViewModel: BaseViewModel {

    private var output : LoginOutput?
    
    func login(_ input : LoginInput , _ completion : @escaping CompletionHandler)
    {
        fetchServiceResponse(input, LOGIN_API, completion)
    }
    
    override func setupModel(for value: Any?) {
        super.setupModel(for: value)
        if let response = value as? [String : Any]
        {
            do
            {
                let data = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                self.output = try JSONDecoder().decode(LoginOutput.self, from: data)
            }
            catch
            {
                print(error.localizedDescription)
                
            }
            
        }
        else if let data  = value as? Data
        {
            do
            {
                self.output = try JSONDecoder().decode(LoginOutput.self, from: data)
            }
            catch
            {
                print(error.localizedDescription)
                
            }
        }
    }
    
    var userID : String {return self.output?.userID ?? ""}
    var password : String {return self.output?.password ?? ""}
    var imei : String {return self.output?.imei ?? ""}
    var firstName : String {return self.output?.firstName ?? ""}
    var lastName : String {return self.output?.lastName ?? ""}
    var gender : String {return self.output?.gender ?? ""}
    var birthYear : String {return self.output?.birthYear ?? ""}
    var email : String {return self.output?.email ?? ""}
    var weight : String {return self.output?.weight ?? ""}
    var height : String {return self.output?.height ?? ""}
    var metrices : String {return self.output?.metrices ?? ""}
    var createdAt : String {return self.output?.createdAt ?? ""}
    var updatedAt : String {return self.output?.updatedAt ?? ""}
    var version : Int {return self.output?.version ?? 0}
    var msg : String {return self.output?.msg ?? "Something went wrong"}
    
    func updateGender(_ gender : String?) {self.output?.gender = gender ?? ""}
    func updateheight(_ height : String?) {self.output?.height = height ?? ""}
    func updateWeight(_ weight : String?) {self.output?.weight = weight ?? ""}
    func updateBday(_ bday : String?) {self.output?.birthYear = bday ?? ""}
    
    
}
struct LoginInput : Codable {
    let email : String
    let password : String
}

struct LoginOutput : Decodable {
    let userID: String
    let password : String
    let imei : String
    let firstName : String
    let lastName : String
    var gender : String
    var birthYear : String
    let email: String
    var weight : String
    var height : String
    let metrices : String
    let createdAt : String
    let updatedAt : String
    let version : Int
    let msg : String
    
    private enum CodingKeys: String , CodingKey
    {
        case userID = "_id"
        case  password
        case imei
        case firstName = "firstname"
        case lastName = "lastname"
        case gender
        case birthYear = "bday"
        case email
        case weight
        case height
        case metrices
        case createdAt
        case updatedAt
        case version = "__v"
        case message
    }
    init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userID = try container.decodeIfPresent(String.self, forKey: .userID) ?? ""
        self.password = try container.decodeIfPresent(String.self, forKey: .password) ?? ""
        self.imei = try container.decodeIfPresent(String.self, forKey: .imei) ?? ""
        self.firstName = try container.decodeIfPresent(String.self, forKey: .firstName) ?? ""
        self.lastName = try container.decodeIfPresent(String.self, forKey: .lastName) ?? ""
        self.gender = try container.decodeIfPresent(String.self, forKey: .gender) ?? ""
        self.birthYear = try container.decodeIfPresent(String.self, forKey: .birthYear) ?? ""
        self.email = try container.decodeIfPresent(String.self, forKey: .email) ?? ""
        self.weight = try container.decodeIfPresent(String.self, forKey: .weight) ?? ""
        self.height = try container.decodeIfPresent(String.self, forKey: .height) ?? ""
        self.metrices = try container.decodeIfPresent(String.self, forKey: .metrices) ?? ""
        self.createdAt = try container.decodeIfPresent(String.self, forKey: .createdAt) ?? ""
        self.updatedAt = try container.decodeIfPresent(String.self, forKey: .updatedAt) ?? ""
         self.version = try container.decodeIfPresent(Int.self, forKey: .version) ?? 0
        self.msg = try container.decodeIfPresent(String.self, forKey: .message) ?? ""
    }
}
