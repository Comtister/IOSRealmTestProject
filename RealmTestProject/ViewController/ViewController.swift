//
//  ViewController.swift
//  RealmTestProject
//
//  Created by Oguzhan Ozturk on 26.07.2021.
//

import UIKit

class ViewController: UITableViewController {

    var datas : Meals?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDatas()
        
    }
    
    private func getDatas(){
        
        DataHelper.getRecipes { [weak self] (meals) in
            
            if meals != nil{
                self?.datas = meals!
                self?.tableView.reloadData()
            }
            
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas == nil ? 0 : datas!.meals.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = datas!.meals[indexPath.row].title
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .normal, title: "Save DB") { [self] (action, view, boolValue) in
            boolValue(true)
            
            //DB Operation
            /*
             //Create custom realm
            do{
            try! RealmManager.shared?.setRealmCustom(realmName: "Test1").setConfigs(config: { (config) in
                 //Setup realm config
             }).build()
            }catch{
                print("error")
            }*/
          
             //Create default realm and save data
            do{
               
                try RealmManager.shared?.saveData(object: datas!.meals[indexPath.row])
               
            }catch{
                print(error)
            }
        }
       
        
       return UISwipeActionsConfiguration(actions: [action])
        
    }

}

