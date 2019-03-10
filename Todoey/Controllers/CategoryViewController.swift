//
//  CategoryViewController.swift
//  Todoey
//
//  Created by James Harding on 27/02/2019.
//  Copyright © 2019 James Harding. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()

    }
    
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    //Creates the number of cells based on the size of the array
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        //Creates the cells from the correct table view at the correct index path

        cell.textLabel?.text = categoryArray[indexPath.row].name
        //Names the cells based on the data in this array
        
        return cell
    }
    //Defines the cells contents
    
    
    //MARK: - TableView Delegate Methods
    //what happens when a category cell is pressed
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let desitinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            desitinationVC.selectedCategory = categoryArray[indexPath.row]
        }
        
    }
    
    
    //MARK: - Data Manipulation Methods
    
    func saveCategories() {
        
        do {
            try context.save()
        } catch {
            print("Error saving category \(error)")
        }
        
        self.tableView.reloadData()
        
    }
    //Saves the current array to the database
    
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("Error fetching category data from context, \(error)")
        }
        
        tableView.reloadData()
    }
    //Loads an array from the database and updaes the table view
    
    
    //MARK: - Add New Categories

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        //Creates the alert view controller
        //title = alert title
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            //what will happen once the user clicks the add item button on the UIAlert
            //title = what the button says
            
            let newCategory = Category(context: self.context)
            //New item based on a Category entity
            
            newCategory.name = textField.text!
            //Changes the category name to what was typed in by the user
            
            self.categoryArray.append(newCategory)
            //Adds the new item to the array
            
            self.saveCategories()
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
