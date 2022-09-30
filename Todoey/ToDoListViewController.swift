//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    var itemArray = [Item]()
    let defaults = UserDefaults.standard
    var dataFilePath: URL?
    override func viewDidLoad() {
        super.viewDidLoad()

         dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
        print(dataFilePath)
        
        
        
        itemArray.append(Item(title: "item"))
        itemArray.append(Item(title: "item"))
        itemArray.append(Item(title: "item"))
        itemArray.append(Item(title: "item"))
        itemArray.append(Item(title: "item"))
        itemArray.append(Item(title: "item"))
        
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
        
        cell?.textLabel?.text = item.title
        
        cell?.accessoryType = item.isSelected ? .checkmark : .none
        
        
        
        
        return cell!
        
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
        itemArray[indexPath.row].isSelected = !itemArray[indexPath.row].isSelected
        saveData()
        tableView.reloadData()
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
            let item = Item(title: textField.text!)
            self.itemArray.append(item)
            //Saving data
            self.saveData()
            
            self.tableView.reloadData()
          
            
        })
        
        present(alert, animated: true)
            
}
    
    
    //MARK: - Model Manipulation Methods
    
    func saveData(){
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        }
        catch{
            print(error.localizedDescription)
        }
       
        
        self.tableView.reloadData()
      
    }
    
    func loadData(){
        do{
            guard let data = try? Data(contentsOf: dataFilePath!) else {return}
            let decoder = PropertyListDecoder()
            let decodedData = try decoder.decode([Item].self, from: data)
            itemArray = decodedData
        }
        catch{
            print(error.localizedDescription)
        }
      
       
        
    }
}

