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

class EmployeeEditViewController: UIViewController, UITextFieldDelegate {
    let realm = try! Realm()

    var inField = false
    
    @IBOutlet weak var categorySegments: UISegmentedControl!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var officePhoneField: PhoneNumberTextField!
    @IBOutlet weak var cellPhoneField: UITextField!
    @IBOutlet weak var ipadSerialField: UITextField!
    @IBOutlet weak var ipadPhoneField: UITextField!
    @IBOutlet weak var portNumberField: UITextField!
    @IBOutlet weak var saveButton: UIButton!

    let phoneNumberKit = PhoneNumberKit()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeTextFields()
        
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
    
    func initializeTextFields() {
        nameField.delegate = self
        nameField.keyboardType = UIKeyboardType.alphabet
        
        emailField.delegate = self
        emailField.keyboardType = UIKeyboardType.emailAddress
        
        officePhoneField.delegate = self
        officePhoneField.keyboardType = UIKeyboardType.phonePad
        
        cellPhoneField.delegate = self
        cellPhoneField.keyboardType = UIKeyboardType.phonePad
        
        ipadSerialField.delegate = self
        
        ipadPhoneField.delegate = self
        ipadPhoneField.keyboardType = UIKeyboardType.phonePad
        
        portNumberField.delegate = self
    }
    
    func fillFields() {
        nameField.text = selectedEmployee?.name
        emailField.text = selectedEmployee?.email
        officePhoneField.text = selectedEmployee?.phone
        categorySegments.selectedSegmentIndex = employee?.category as! Int
        cellPhoneField.text = selectedEmployee?.cellPhone
        ipadPhoneField.text = selectedEmployee?.ipadPhoneNumber
        ipadSerialField.text = selectedEmployee?.ipadSerial
        //portNumberField.text = selectedEmployee?.portNumber as? String
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
    
    
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        if textField == portNumberField {
//            let allowedCharacters = "1234567890"
//            let allowedCharacterSet = CharacterSet(charactersIn: allowedCharacters)
//            let typedCharacterSet = CharacterSet(charactersIn: string)
//            let alphabet = allowedCharacterSet.isSuperset(of: typedCharacterSet)
//            return alphabet
//        }
//    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        
        if let nextResponder = textField.superview?.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    func updateEmployee() {
        let realm = try! Realm()
        
        do {
            try realm.write {
                employee?.name = nameField.text!
                employee?.email = emailField.text!
                employee?.phone = officePhoneField.text!
                employee?.category = categorySegments.selectedSegmentIndex
                employee?.cellPhone = cellPhoneField.text!
                employee?.ipadPhoneNumber = ipadPhoneField.text!
                employee?.ipadSerial = ipadSerialField.text!
                
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
