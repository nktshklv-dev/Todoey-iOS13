//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController{
    
    var itemArray = [Item]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    @IBOutlet var searchBar: UISearchBar?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar?.delegate = self
        //MARK: - code for nav bar color
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBlue
        appearance.titleTextAttributes = [.font: UIFont.boldSystemFont(ofSize: 20.0),
                                          .foregroundColor: UIColor.white]
        
        // Customizing our navigation bar
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        tableView.dataSource = self
        
        loadData()
        
        
        
        
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell")
        let item = itemArray[indexPath.row]
        
        cell?.textLabel!.text = item.title
        
        cell?.accessoryType = item.isSelected ? .checkmark : .none
        
        
        
        
        return cell!
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
        
        itemArray[indexPath.row].isSelected = !itemArray[indexPath.row].isSelected
        saveData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    //MARK: - Add new items
    @IBAction func didTapAddButton(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new item", message: nil, preferredStyle: .alert)
        
        alert.addTextField{ alertTextField in
            alertTextField.placeholder = "Create new item "
            textField = alertTextField
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        alert.addAction(UIAlertAction(title: "Add", style: .default) { _ in
            guard !textField.text!.isEmpty else {return}
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.isSelected = false
            self.itemArray.append(newItem)
            //Saving data
            self.saveData()
            
            self.tableView.reloadData()
            
            
        })

        present(alert, animated: true)
        
    }
    
   
    
}

//MARK: - CoreData Manipulation Methods
extension ToDoListViewController{
    
    
    func saveData(){
        do{
            try context.save()
            loadData()
        }catch{
            print(error.localizedDescription)
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
       
        
    }
    
    func loadData(with request: NSFetchRequest<Item> = Item.fetchRequest()){
        do{
           itemArray = try context.fetch(request)
           DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch{
            print(error.localizedDescription)
        }
        
        
    }
}


//MARK: - UISearchBarDelegate
extension ToDoListViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
    
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadData(with: request)
        
    }
}








