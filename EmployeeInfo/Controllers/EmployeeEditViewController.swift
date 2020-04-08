//
//  EmployeeEditViewController.swift
//  EmployeeInfo
//
//  Created by Brady Nations on 4/7/20.
//  Copyright © 2020 Brady Nations. All rights reserved.
//

import UIKit
import RealmSwift
import PhoneNumberKit

class EmployeeEditViewController: UIViewController {
    let realm = try! Realm()
    
    @IBOutlet weak var categorySegments: UISegmentedControl!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var officePhoneField: PhoneNumberTextField!
    @IBOutlet weak var cellPhoneField: UITextField!
    @IBOutlet weak var saveButton: UIButton!

    let phoneNumberKit = PhoneNumberKit()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fillFields()
    }
    
    var employee : Employee?

    var selectedEmployee: Employee? {
        didSet {
            loadEmployeeFields()
        }
    }
    
    func loadEmployeeFields() {
        employee = selectedEmployee
    }
    
    func fillFields() {
        nameField.text = selectedEmployee?.name
        emailField.text = selectedEmployee?.email
        officePhoneField.text = selectedEmployee?.phone
        categorySegments.selectedSegmentIndex = employee?.category as! Int
    }
    
    func phoneNumber() {
        let rawPhoneNumber = officePhoneField.text!
        do {
            let officeNumber = try phoneNumberKit.parse(rawPhoneNumber)
            officePhoneField.text = officeNumber.numberString
        } catch {
            print("Generic parser error")
        }
        
    }
    
    
    func updateEmployee() {
        let realm = try! Realm()
        
        do {
            try realm.write {
                employee?.name = nameField.text!
                employee?.email = emailField.text!
                employee?.phone = officePhoneField.text!
                employee?.category = categorySegments.selectedSegmentIndex
            }
            
        } catch {
            print("Error updating employee info, \(error)")
        }
    }
    
    enum employeeType {
        case Attorney
        case Investigator
        case Support
    }
    

    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        let selectedType = categorySegments.selectedSegmentIndex
        
        switch selectedType {
        case 0:
            selectedEmployee?.category = 0
        case 1:
            selectedEmployee?.category = 1
        case 2:
            selectedEmployee?.category = 2
        default:
            selectedEmployee?.category = 0
        }
    }
}
