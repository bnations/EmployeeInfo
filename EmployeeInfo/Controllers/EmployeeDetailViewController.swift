//
//  EmployeeDetailViewController.swift
//  EmployeeInfo
//
//  Created by Brady Nations on 4/7/20.
//  Copyright © 2020 Brady Nations. All rights reserved.
//

import UIKit
import RealmSwift
import MessageUI

class EmployeeDetailViewController: UIViewController {
    
    let realm = try! Realm()
    var employeeInfo: Employee?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var sendEmail: UIButton!
    @IBOutlet weak var employeeType: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var officePhoneLabel: UILabel!
    @IBOutlet weak var cellPhoneLabel: UILabel! 
    @IBOutlet weak var ipadSerialLabel: UILabel!
    @IBOutlet weak var ipadPhoneLabel: UILabel!
    @IBOutlet weak var portNumberLabel: UILabel!
    @IBOutlet weak var emailButton: UIButton!
    
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
        cellPhoneLabel.text = employeeInfo?.cellPhone
        ipadPhoneLabel.text = employeeInfo?.ipadPhoneNumber
        ipadSerialLabel.text = employeeInfo?.ipadSerial
        //portNumberLabel.text = employeeInfo?.portNumber as! String
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
    
    @IBAction func emailButtonTapped(_ sender: UIButton) {
        showMailComposer()
        print("button pressed")
    }
    
    func showMailComposer() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([employeeInfo!.email])
            mail.setMessageBody("Hello \(employeeInfo!.name),", isHTML: false)
            
            present(mail, animated: true, completion: nil)
        } else {
            print("Error showing MailComposeView")
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


extension EmployeeDetailViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if let _ = error {
            //Show error alert
            controller.dismiss(animated: true)
            return
        }
        
        switch result {
        case .cancelled:
            print("Cancelled")
        case .failed:
            print("Failed to send")
        case .saved:
            print("Saved")
        case .sent:
            print("Email sent")
        @unknown default:
            break
        }
        controller.dismiss(animated: true)
    }
}

//TODO: create update functions for employee edit view
