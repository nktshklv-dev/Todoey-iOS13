//
//  CategoryListViewController.swift
//  Todoey
//
//  Created by Nikita  on 10/7/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class CategoryListViewController: UITableViewController {
    
      let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var categories = [Category]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBlue
        appearance.titleTextAttributes = [.font: UIFont.boldSystemFont(ofSize: 20.0),
                                          .foregroundColor: UIColor.white]
        
        // Customizing our navigation bar
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        fetchData()

     
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell")
        
        let category = categories[indexPath.row]
        
        cell?.textLabel!.text = category.name
        
        return cell!
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let ac = UIAlertController(title: "Add new category.", message: nil, preferredStyle: .alert)
        var textField: UITextField?
        ac.addTextField{ field in
            field.placeholder = "Category name"
            textField = field
        }
        ac.addAction(UIAlertAction(title: "Add", style: .default){
            action in
            guard let catName = textField?.text else {return}
            let newCategory = Category(context: self.context)
            newCategory.name = catName
            self.categories.append(newCategory)
            self.saveData()
        } )
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(ac, animated: true)
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath , animated: true)
    }
    

  

}


extension CategoryListViewController{
    func saveData(){
        do{
            try context.save()
            fetchData()
        } catch{
            print(error.localizedDescription)
        }
    }
    
    func fetchData(with request: NSFetchRequest<Category> = Category.fetchRequest()){
        do{
            categories = try context.fetch(request)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }catch{
            print(error.localizedDescription)
        }
    }
}