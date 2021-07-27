//
//  Meal.swift
//  RealmTestProject
//
//  Created by Oguzhan Ozturk on 26.07.2021.
//

import Foundation
import RealmSwift

class Meal : Object , Codable {
    
    @Persisted var id : Int
    @Persisted var title : String
    @Persisted var imageUrl : String
    
    enum CodingKeys : String , CodingKey{
        case imageUrl = "image" , id , title
    }
    
    override init() {
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.imageUrl = try container.decode(String.self, forKey: CodingKeys.imageUrl)
        self.id = try container.decode(Int.self, forKey: CodingKeys.id)
        self.title = try container.decode(String.self, forKey: CodingKeys.title)
    }
    
}
