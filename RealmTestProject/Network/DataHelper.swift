//
//  DataHelper.swift
//  RealmTestProject
//
//  Created by Oguzhan Ozturk on 26.07.2021.
//

import Foundation
//a simple class for obtaining data
class DataHelper{
    
    private init(){
        
    }
    
    static func getRecipes(completion : @escaping (Meals?) -> Void){
        
        var returnValue : Meals?
        
        let url = URL(string: "https://api.spoonacular.com/recipes/complexSearch")
        
        var components = URLComponents(url: url!, resolvingAgainstBaseURL: false)
        
        components?.queryItems = [
            URLQueryItem(name: "apiKey", value: "5cb9fc2f792f47e8aacb8be7fec720ce"),
            URLQueryItem(name: "query", value: "pasta")]
        
        guard let finalUrl = components?.url else {
            completion(nil)
            return}
        
        URLSession.shared.dataTask(with: finalUrl ) { (data, response, error) in
           
            if error != nil{
                returnValue = nil
                return
            }
            
            do{
                let decoder = JSONDecoder()
                returnValue = try decoder.decode(Meals.self, from: data!)
            }catch{
                print(error)
            }
            
            DispatchQueue.main.async {
                completion(returnValue)
            }
           
        }.resume()
        
    }
    
}
