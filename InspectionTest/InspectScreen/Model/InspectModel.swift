//
//  InspectModel.swift
//  InspectionTest
//
//  Created by Zubin Gala on 12/08/24.
//

import UIKit

class InspectModel: Codable {
    let inspection: InspectionData?
    
    enum CodingKeys: String, CodingKey {
        case inspection = "inspection"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        inspection = try values.decodeIfPresent(InspectionData.self , forKey: .inspection)
    }
}

class InspectionData: Codable {
    let id: Int?
    let inspectionType: InspectionType?
    let area: Area?
    let survey: Survey?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case inspectionType = "inspectionType"
        case area  = "area"
        case survey  = "survey"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try values.decodeIfPresent(Int.self , forKey: .id)
        inspectionType = try values.decodeIfPresent(InspectionType.self , forKey: .inspectionType )
        area  = try values.decodeIfPresent(Area.self, forKey: .area  )
        survey  = try values.decodeIfPresent(Survey.self, forKey: .survey  )
    }
}
class InspectionType: Codable {
    let id: Int?
    let name: String?
    let access: String?
    
    enum CodingKeys: String, CodingKey {
        case id    = "id"
        case name = "name"
        case access  = "access"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try values.decodeIfPresent(Int.self , forKey: .id)
        name = try values.decodeIfPresent(String.self , forKey: .name )
        access  = try values.decodeIfPresent(String.self, forKey: .access  )
    }
}

class Area: Codable {
    let id: Int?
    let name: String?
    
    enum CodingKeys: String, CodingKey {
        case id    = "id"
        case name = "name"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try values.decodeIfPresent(Int.self , forKey: .id)
        name = try values.decodeIfPresent(String.self , forKey: .name )
    }
}

class Survey: Codable {
    let id: Int?
    let categories: [Category]?
    
    enum CodingKeys: String, CodingKey {
        case id    = "id"
        case categories = "categories"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try values.decodeIfPresent(Int.self , forKey: .id)
        categories = try values.decodeIfPresent([Category].self , forKey: .categories )
    }
}

class Category: Codable {
    let id: Int?
    let name: String?
    let questions: [Question]?
    
    enum CodingKeys: String, CodingKey {
        case id    = "id"
        case name = "name"
        case questions  = "questions"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try values.decodeIfPresent(Int.self , forKey: .id)
        name = try values.decodeIfPresent(String.self , forKey: .name )
        questions  = try values.decodeIfPresent([Question].self, forKey: .questions  )
    }
}

class Question: Codable {
    let id: Int?
    let name: String?
    let answerChoices: [AnswerChoice]?
    var selectedAnswerChoiceId: Int?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case answerChoices  = "answerChoices"
        case selectedAnswerChoiceId  = "selectedAnswerChoiceId"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try values.decodeIfPresent(Int.self , forKey: .id)
        name = try values.decodeIfPresent(String.self , forKey: .name)
        answerChoices  = try values.decodeIfPresent([AnswerChoice].self, forKey: .answerChoices  )
        selectedAnswerChoiceId  = try values.decodeIfPresent(Int.self, forKey: .selectedAnswerChoiceId  )
    }
}

struct AnswerChoice: Codable {
    let id: Int?
    let name: String?
    let score: Float?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case score  = "score"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try values.decodeIfPresent(Int.self , forKey: .id)
        name = try values.decodeIfPresent(String.self , forKey: .name )
        score  = try values.decodeIfPresent(Float.self, forKey: .score  )
    }
}


//MARK: Form Field type

enum FormFieldType {
    case inspectionType(String)
    case area(String)
    case survey(Category)
}

