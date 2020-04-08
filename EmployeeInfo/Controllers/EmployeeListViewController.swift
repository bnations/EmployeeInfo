//
//  EmployeeListViewController.swift
//  EmployeeInfo
//
//  Created by Brady Nations on 4/6/20.
//  Copyright © 2020 Brady Nations. All rights reserved.
//

import UIKit
import RealmSwift

class EmployeeListViewController: UITableViewController {
    
    var employeeItems: Results<Employee>?
    //let employees = List<Employee>()
    
    let searchController = UISearchController(searchResultsController: nil)
    var filteredEmployees: [Employee] = []
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadEmployees()
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Employees"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredEmployees.count
        } else {
            return employeeItems?.count ?? 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeeCell", for: indexPath)
        let employee: Employee?
        
        if isFiltering {
            employee = filteredEmployees[indexPath.row]
        } else {
            employee = employeeItems?[indexPath.row]
        }
        
        cell.textLabel?.text = employee?.name
//        if let employee = employeeItems?[indexPath.row] {
//            cell.textLabel?.text = employee.name
//
//        } else {
//            cell.textLabel?.text = "No items added"
//        }
        
        return cell
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! EmployeeDetailViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            if isFiltering {
                destinationVC.selectedEmployee = filteredEmployees[indexPath.row]
            } else {
                destinationVC.selectedEmployee = employeeItems?[indexPath.row]
            }
        }

    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToEmployeeDetail", sender: self)
    }
    
    func loadEmployees() {
        employeeItems = realm.objects(Employee.self)
        tableView.reloadData()
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new employee", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Employee", style: .default) { (action) in
            
            let newEmployee = Employee()
            newEmployee.name = textField.text!
            
            
            self.saveEmployees(employee: newEmployee)
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new employee"
            textField = alertTextField
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    func saveEmployees(employee: Employee) {
        do {
            try realm.write {
                realm.add(employee)
            }
        } catch {
            print("Error saving employee, \(error)")
        }
        tableView.reloadData()
        
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let item = employeeItems?[indexPath.row] {
                try! realm.write {
                    realm.delete(item)
                }
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
        tableView.reloadData()
    }
    
    func filterContentForSearchText( _ searchText: String) {
        filteredEmployees = employeeItems!.filter {
            (employee: Employee) -> Bool in
            return employee.name.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
    }
    
}


extension EmployeeListViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
}
