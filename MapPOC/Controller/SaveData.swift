//
//  ViewController.swift
//  MapPOC
//
//  Created by Ankleshwar on 29/07/18.
//  Copyright © 2018 Ankleshwar. All rights reserved.
//

import UIKit
import CoreData


class SaveData: UIViewController {
   
    @IBOutlet var tableView: UITableView!
    var user: [NSManagedObject] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "The List"
       
        self.tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
         fetchData()
    }
    
    
    func fetchData(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "User")
        do {
            user = try managedContext.fetch(fetchRequest)
            self.tableView.reloadData()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    

    
    
    
    

    
}



extension SaveData: UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return user.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
            let location = user[indexPath.row]
            let cell =
                tableView.dequeueReusableCell(withIdentifier: "Cell",
                                              for: indexPath)
            
              let lat  =  location.value(forKeyPath: "lat") as? Double
              let lng  =  location.value(forKeyPath: "lng") as? Double
            
            cell.textLabel?.text = String(format: "latitude %.3f", lat!) + " , " + String(format: "longitude %.3f", lng!)
            return cell
    }
   
}
