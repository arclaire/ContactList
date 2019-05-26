//
//  Contacts.swift
//  myAddressBook
//
//  Created by lucy on 24/05/19.
//  Copyright © 2019 lucy. All rights reserved.
//

import Foundation
import SwiftyJSON
//MARK: - Class Declaration
class Contacts: NSObject {
    var strId: String?
    var strFirstName: String?
    var strLastName: String?
    var strMobileNumber: String?
    var strEmail: String?
    var strImage: String?
    var isFavorite: Bool = false
    
    override init() {
        super.init()
    }
    
    init(jsonData: JSON) {
        super.init()
        //print("DATA", jsonData)
        self.strId = jsonData["id"].stringValue
        self.strFirstName = jsonData["first_name"].stringValue
        self.strImage = jsonData["profile_pic"].stringValue
        self.strLastName =  jsonData["last_name"].stringValue
        self.isFavorite = jsonData["favorite"].boolValue
        self.strMobileNumber = jsonData["phone_number"].stringValue
        self.strEmail = jsonData["email"].stringValue
    }
    
    required init(contact: Contacts) {
        self.strId = contact.strId
        self.strFirstName = contact.strFirstName
        self.strImage = contact.strImage
        self.strLastName =  contact.strLastName
        self.isFavorite = contact.isFavorite
        self.strMobileNumber = contact.strMobileNumber
        self.strEmail = contact.strEmail
    }
    
    //MARK: - Copy
    func copy(with zone: NSZone? = nil) -> Contacts {
        let contactPrev: Contacts = self
        
        return type(of: self).init(contact: contactPrev)
    }
}
