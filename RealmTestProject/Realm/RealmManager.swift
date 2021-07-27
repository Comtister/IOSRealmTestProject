//
//  RealmManager.swift
//  RealmTestProject
//
//  Created by Oguzhan Ozturk on 27.07.2021.
//

import Foundation
import RealmSwift

class RealmManager {
    
    static var shared : RealmManager?{
        get{
            if instance == nil{
                instance = try? RealmManager()
            }
            return instance
        }
    }
    
    private static var instance : RealmManager?
    private var realm : Realm!
    private var observeTokens : [NotificationToken] = [NotificationToken]()
    
    private init() throws {
       try? setRealmDefault()
    }
    //Creator Funcs
    func setRealmDefault() throws {
        self.realm = try! Realm()
    }
    
    func setRealmCustom(realmName : String) -> RealmBuilder{
        return RealmBuilder(realmName: realmName)
    }
    
    fileprivate func createCustomRealm(config : Realm.Configuration){
        realm = try! Realm(configuration: config)
    }
    //Data funcs
    func getAllData<T : Object>(object : T.Type) -> Results<T>{
        let data = realm.objects(T.self)
        return data
       
    }
    
    func getById<T : Object>(object : T.Type , primaryKey : Int) -> Object?{
        let data = realm.object(ofType: T.self, forPrimaryKey: primaryKey)
        return data
    }
    
    func getPastas() -> Results<Meal>{
        let data = realm.objects(Meal.self).filter(NSPredicate(format: "title CONTAINS[c]'pasta'"))
        return data
    }
        
    func deleteObject(object : Object) throws{
        try! realm.write({
            realm.delete(object)
        })
    }
    
    func deleteAllObjects() throws{
        try! realm.write({
            realm.deleteAll()
        })
    }

    func saveData(object : Object) throws {
       try! realm.write({
            realm.add(object)
        })
    }
    //Observing funcs
    func observeRealm(change : @escaping () -> Void) -> NotificationToken{
        
       let token = realm.observe { (notification, realm) in
            change()
        }
        
        observeTokens.append(token)
        return token
    }
    
    func observeScheme<T : Object>(type : T.Type , change : @escaping (RealmCollectionChange<Results<T>>) -> Void) -> NotificationToken{
        let token = realm.objects(type).observe { (changes) in
           
            change(changes)
            
        }
        observeTokens.append(token)
        return token
    }
    
    func finishObserving(token : NotificationToken){
        token.invalidate()
        var index = 0
        observeTokens.forEach { (savedToken) in
            if savedToken === token{
                observeTokens.remove(at: index)
            }
           index += 1
        }
        
    }
    
    //Inner Builder Class
    class RealmBuilder {
        
        private var config : Realm.Configuration
        private var realmName : String
        
        fileprivate init(realmName : String) {
            self.config = Realm.Configuration.defaultConfiguration
            self.realmName = realmName
            config.fileURL!.deleteLastPathComponent()
            config.fileURL!.appendPathComponent(realmName)
            config.fileURL!.appendPathExtension("realm")
        }
        
        func setConfigs(config : (inout Realm.Configuration) -> Void) -> RealmBuilder{
            config(&self.config)
            return self
        }
        
        func build() throws{
            
            RealmManager.shared!.createCustomRealm(config: self.config)
            
        }
        
    }
    
}
