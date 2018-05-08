//
//  SettingsViewModel.swift
//  PRSMedical
//
//  Created by Lucideus  on 4/30/18.
//  Copyright © 2018 Arun Kumar. All rights reserved.
//

import UIKit

class SettingsViewModel: BaseViewModel {

    
    private var faqs : [FaqsModel] = []
    private var abouts : [AboutModel] = []
    private var terms : [TermModel] = []
    private var policies : [PolicyModel] = []
    
    enum SettingType
    {
        case about , faq , terms , privacy
        var urlString : String {
            switch self {
            case .about:
                return CUSHION_ABOUT_API
            case .faq:
                return CUSHION_FAQs_API
            case .privacy:
                return CUSHION_PRIVACY_API
            case .terms:
                return CUSHION_TERMS_API

            }
        }
    }
    private var currentType = SettingType.about
    
    func getContent(for type : SettingType  , _ completion : @escaping CompletionHandler)
    {
        self.currentType = type
        let input = BlankInput()
        fetchServiceResponse(input, type.urlString, completion)
    }
    
    override func setupModel(for value: Any?) {
        super.setupModel(for: value)
        if let response = value as? [[String : Any]]
        {
            do
            {
                let data = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                switch self.currentType
                {
                case .about:
                    self.abouts = try JSONDecoder().decode([AboutModel].self, from: data)
                case .faq:
                    self.faqs = try JSONDecoder().decode([FaqsModel].self, from: data)
                case .privacy:
                    self.policies = try JSONDecoder().decode([PolicyModel].self, from: data)
                case .terms:
                    self.terms = try JSONDecoder().decode([TermModel].self, from: data)
                }
                
            }
            catch
            {
                print(error.localizedDescription)
                
            }
            
        }
        else if let data  = value as? Data
        {
//            do
//            {
//                self.output = try JSONDecoder().decode(LoginOutput.self, from: data)
//            }
//            catch
//            {
//                print(error.localizedDescription)
//                
//            }
        }
    }
    
    var faqsCount : Int {return self.faqs.count}
    func getFaqs(for index : Int) -> FaqsModel? {
        guard faqs.count > index  else { return nil }
        return faqs[index]
    }
    func getAbout(for Index : Int) -> AboutModel? {
         guard Index < abouts.count else { return nil }
        return abouts[Index]
    }
    func getTerms(for index : Int) -> TermModel?
    {
        guard terms.count > index  else { return nil }
        return terms[index]
    }
    func getPolicy(for index : Int) -> PolicyModel?
    {
        guard policies.count > index  else { return nil }
        return policies[index]
    }
    
}

struct BlankInput : Codable
{}


struct FaqsModel : Decodable
{
    let faqID : String
    let question : String
    let answer : String
    let company : String
    
    enum CodingKeys : String , CodingKey {
        case faqID = "_id"
        case question
        case answer
        case company
    }
    
    init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.faqID = try container.decodeIfPresent(String.self, forKey: .faqID) ?? ""
        self.question = try container.decodeIfPresent(String.self, forKey: .question) ?? ""
        self.answer = try container.decodeIfPresent(String.self, forKey: .answer) ?? ""
        self.company = try container.decodeIfPresent(String.self, forKey: .company) ?? ""

    }
   
}


struct AboutModel : Decodable
{
    let aboutID : String
    let title : String
    let info : String
   
    
    enum CodingKeys : String , CodingKey {
        case aboutID = "_id"
        case title
        case info
    }
    
    init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.aboutID = try container.decodeIfPresent(String.self, forKey: .aboutID) ?? ""
        self.title = try container.decodeIfPresent(String.self, forKey: .title) ?? ""
        self.info = try container.decodeIfPresent(String.self, forKey: .info) ?? ""
        debugPrint("information is " + self.info)
    }
}

struct TermModel : Decodable
{
    let termID : String
    let title : String
    enum CodingKeys : String , CodingKey {
        case termID = "_id"
        case title
    }
    
    init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.termID = try container.decodeIfPresent(String.self, forKey: .termID) ?? ""
        self.title = try container.decodeIfPresent(String.self, forKey: .title) ?? ""
        
    }
    
}

struct PolicyModel : Decodable
{
    let policyID : String
    let title : String
    enum CodingKeys : String , CodingKey {
        case policyID = "_id"
        case title
    }
    
    init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.policyID = try container.decodeIfPresent(String.self, forKey: .policyID) ?? ""
        self.title = try container.decodeIfPresent(String.self, forKey: .title) ?? ""
        
    }
    
}
