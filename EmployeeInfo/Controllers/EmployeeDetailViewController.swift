//
//  EmployeeDetailViewController.swift
//  EmployeeInfo
//
//  Created by Brady Nations on 4/7/20.
//  Copyright © 2020 Brady Nations. All rights reserved.
//

import UIKit
import RealmSwift

class EmployeeDetailViewController: UIViewController {
    
    let realm = try! Realm()
    var employeeInfo: Employee?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var employeeType: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var officePhoneLabel: UILabel!
    @IBOutlet weak var cellPhoneLabel: UILabel! 
    
    var selectedEmployee : Employee? {
        didSet {
            loadEmployeeInfo()
        }
    }
    
    func loadEmployeeInfo() {
        employeeInfo = selectedEmployee
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fillLabels()
    }
    
    func fillLabels() {
        nameLabel.text = employeeInfo?.name
        emailLabel.text = employeeInfo?.email
        officePhoneLabel.text = employeeInfo?.phone
        readEmployeeType()
    }
    
    func readEmployeeType() {
        let chosenType = employeeInfo?.category
        
        switch chosenType {
        case 0:
            employeeType.text = "Attorney"
        case 1:
            employeeType.text = "Investigator"
        case 2:
            employeeType.text = "Support"
        default:
            employeeType.text = ""
        }
    }
    
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "editEmployee", sender: self)
    }
    
    @IBAction func didUnwindFromEdit(_ sender: UIStoryboardSegue) {
        guard let destinationVC = sender.source as? EmployeeEditViewController else { return }
        destinationVC.updateEmployee()
        self.selectedEmployee = destinationVC.selectedEmployee
        self.fillLabels()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationVC = segue.destination as? EmployeeEditViewController else { return }
        
        destinationVC.selectedEmployee = self.selectedEmployee
    }
}


//TODO: create update functions for employee edit view
