//
//  Meals.swift
//  RealmTestProject
//
//  Created by Oguzhan Ozturk on 26.07.2021.
//

import Foundation

struct Meals : Codable {
    var meals : [Meal]
    
    enum CodingKeys : String , CodingKey {
        
        case meals = "results"
       
    }
    
}


