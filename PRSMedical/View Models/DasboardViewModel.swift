//
//  DasboardViewModel.swift
//  PRSMedical
//
//  Created by Arun Kumar on 27/04/18.
//  Copyright © 2018 Arun Kumar. All rights reserved.
//

import UIKit

class DasboardViewModel: BaseViewModel {

    private var cushionServerData = [CushionServerData]()
    func fetchCushionData(_ request : CushionRquest , _ completion : @escaping CompletionHandler)  {
        fetchServiceResponse(request, CUSHION_FETCH_API, completion)
    }
    
    override func setupModel(for value: Any?) {
        super.setupModel(for: value)
        if let response = value as? [[String : Any]]
        {
            do
            {
                let data = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                self.cushionServerData = try JSONDecoder().decode([CushionServerData].self, from: data)
            }
            catch
            {
                print(error.localizedDescription)
                
            }
            
        }
    }
    
    func getAllServerCushion() -> [CushionServerData] {
        return cushionServerData
    }
    
}

struct CushionRquest : Codable {
    let userid : String
}

struct CushionServerData :Decodable {
 
    
    let serverID : String
    let userid : String
    let cushionid : String
    let cushionname : String
    let date : String
    let averagesittingtime : String
    let stepcount : String
    let createdAt : String
    let updatedAt : String
    let version : Int
    
    enum CodingKeys : String , CodingKey {
        case serverID = "_id"
        case userid
        case cushionid
        case cushionname
        case date
        case averagesittingtime
        case stepcount
        case createdAt
        case updatedAt
        case version = "__v"
        
    }
    init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.serverID = try container.decodeIfPresent(String.self, forKey: .serverID) ?? ""
        self.userid = try container.decodeIfPresent(String.self, forKey: .userid) ?? ""
        self.cushionid = try container.decodeIfPresent(String.self, forKey: .cushionid) ?? ""
        self.cushionname = try container.decodeIfPresent(String.self, forKey: .cushionname) ?? ""
        self.date = try container.decodeIfPresent(String.self, forKey: .date) ?? ""
        self.averagesittingtime = try container.decodeIfPresent(String.self, forKey: .averagesittingtime) ?? ""
        self.stepcount = try container.decodeIfPresent(String.self, forKey: .stepcount) ?? ""
        self.createdAt = try container.decodeIfPresent(String.self, forKey: .createdAt) ?? ""
        self.updatedAt = try container.decodeIfPresent(String.self, forKey: .updatedAt) ?? ""
        self.version = try container.decodeIfPresent(Int.self, forKey: .version) ?? 0
    
    }
    
}


