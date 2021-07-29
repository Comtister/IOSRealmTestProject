//
//  SavedRecipesTableViewController.swift
//  RealmTestProject
//
//  Created by Oguzhan Ozturk on 26.07.2021.
//

import UIKit
import RealmSwift

class SavedRecipesTableViewController: UITableViewController {

    var datas : Results<Meal>?
    var observingToken : NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getAllData()
      
    }
    
    private func getAllData(){
        //Get instant data
        //datas = RealmManager.shared?.getPastas()
        //tableView.reloadData()
        
        //Realm Observing
        /*
        RealmManager.shared?.observeRealm { [weak self] in
            self?.datas = RealmManager.shared?.getPastas()
            tableView.reloadData()
        }*/
        //Scheme Observing
        observingToken = RealmManager.shared?.observeScheme(type: Meal.self, change: { [weak self] (change) in
            switch change{
            
            case .initial(let values):
                self?.datas = values
                self?.tableView.reloadData()
                break
            case .update(_, deletions: let deletions, insertions: let insertions, modifications: let modifications):
                self?.tableView.performBatchUpdates({
                                    
                    self?.tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
                                                         with: .automatic)
                    self?.tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                                                         with: .automatic)
                    self?.tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                                                         with: .automatic)
                                }, completion: { finished in
                                    
                                })
                break
            case .error(let error):
                print(error)
                break
            }
        })
        
        
            
    }
    
    private func removeObserving(){
        
        guard let observingToken = observingToken else {return}
        RealmManager.shared?.finishObserving(token: observingToken)
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas != nil ? datas!.count : 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellSaved", for: indexPath)
        
        cell.textLabel?.text = datas![indexPath.row].title
        return cell
    }

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, boolValue) in
            boolValue(true)
            
            
            
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    
}
