//
//  CategoryViewController.swift
//  Todoey
//
//  Created by James Harding on 27/02/2019.
//  Copyright © 2019 James Harding. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    //initialise a new access point to the realm database
    
    var categories: Results<Category>?
    //change categories from an array of category items to a collection of results that are category objects

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        //load all categories
        
        tableView.separatorStyle = .none

    }
    
    override func viewWillAppear(_ animated: Bool) {

        guard let categoryNavBar = navigationController?.navigationBar else {fatalError("Navigation controller does not exist.")}

        categoryNavBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(categoryNavBar.barTintColor!, returnFlat: true)]
        
    }
    
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
        //if categories is nil, 1 will be used instead
    }
    //Creates the number of cells based on the size of the array
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = categories?[indexPath.row] {
        
            cell.textLabel?.text = category.name
            
            guard let categoryColour = UIColor(hexString: category.colour) else {fatalError()}
            
            cell.backgroundColor = categoryColour
            cell.textLabel?.textColor = ContrastColorOf(categoryColour, returnFlat: true)
            
        }
        
        return cell
    }
    //Defines the cells contents
    
    
    //MARK: - TableView Delegate Methods
    //what happens when a category cell is pressed
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //runs before segue
        let destinationVC = segue.destination as! ToDoListViewController
        //creates a new instance of the desitnation view controller
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        //set the desintation view controller's selected category property to the category of the row that was clicked on
            
        }
        
    }
    
    
    //MARK: - Data Manipulation Methods
    
    func save(category: Category) {
    //takes the category from the addButtonPressed function
        
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category \(error)")
        }
        
        self.tableView.reloadData()
        
    }
    //Saves the current array to the database
    
    func loadCategories() {
        
        categories = realm.objects(Category.self)
        //Loads an array from the Realm database and updaes the table view
        //Loads all objects that belong to the category data type
        
        tableView.reloadData()
    
    }
    
    //MARK: - Delete data from swipe
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print("Error deleting category, \(error)")
            }
            //tableView.reloadData()
        }
    }
    
    //MARK: - Add New Categories

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        //Creates the alert view controller
        //title = alert title
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            //what will happen once the user clicks the add item button on the UIAlert
            //title = what the button says
            
            let newCategory = Category()
            //New item based on a Category entity
            
            newCategory.name = textField.text!
            //Changes the category name to what was typed in by the user
            
            newCategory.colour = UIColor.randomFlat.hexValue()
  
            self.save(category: newCategory)
            //passes the new category to the save function
        }
        
        alert.addTextField { (alertTextField) in
            textField = alertTextField
            alertTextField.placeholder = "Create new category"
        }
        //Adds a textfield to the Alert
        //placeholder = placeholder text in textbox
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
}
