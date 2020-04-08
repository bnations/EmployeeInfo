//
//  Employee.swift
//  EmployeeInfo
//
//  Created by Brady Nations on 4/6/20.
//  Copyright © 2020 Brady Nations. All rights reserved.
//

import Foundation
import RealmSwift

class Employee: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var email: String = ""
    @objc dynamic var phone: String = ""
    @objc dynamic var cellPhone: String = ""
    @objc dynamic var portNumber: Int = 0
    @objc dynamic var ipadSerial: String = ""
    @objc dynamic var ipadPhoneNumber: String = ""
    @objc dynamic var category: Int = 0
    
    @objc dynamic var employee: Employee!
}
