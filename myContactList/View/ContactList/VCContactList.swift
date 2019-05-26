//
//  VCContactList.swift
//  myAddressBook
//
//  Created by lucy on 24/05/19.
//  Copyright © 2019 lucy. All rights reserved.
//

import UIKit

class VCContactList: UIViewController {
    
    @IBOutlet var vContactList: ViewContactList!
    
    //MARK: - Attributes Navigation
    fileprivate var tupSelectedContact: (index: Int, data: Contacts) = (-1, Contacts())
    
    //MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let _vcContactDetail: VCContactDetail = segue.destination as? VCContactDetail {
            _vcContactDetail.contact = tupSelectedContact.data
            _vcContactDetail.delegate = self
        } else if let _vcNav: UINavigationController = segue.destination as? UINavigationController {
            if let _vcLast: UIViewController = _vcNav.children.last,
                let _vcContactEdit: VCContactEdit = _vcLast as? VCContactEdit {
                _vcContactEdit.delegate = self
            }
        }
    }
    
    //MARK - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.vContactList.delegate = self
        self.getContactList()
    }
    
    func getContactList() {
        
        self.vContactList.isLoading = true
        ServiceContacts.getContacts(onsuccess: { (contacts) in
            
            self.vContactList.isLoading = false
            let contact: [Contacts] = contacts.sorted(by: { ($0.strFirstName?.lowercased())! < ($1.strFirstName?.lowercased())! })
            
            self.vContactList.arrContacts = contact
            
        }) { (error) in
            self.vContactList.isLoading = false
        }
    }
    
    //MARK: -
    @IBAction func addContact(_ sender: Any) {
        self.performSegue(withIdentifier: "openContactEdit", sender: self)
    }
}

//MARK: - ViewContactListDelegate
extension VCContactList: ViewContactListDelegate {
    func showContactDetail(atIdx: Int, contact: Contacts) {
        self.tupSelectedContact = (atIdx, contact)
        
        self.performSegue(withIdentifier: "showContactDetail", sender: self)
    }
}

//MARK: - VCContactDetailDelegate
extension VCContactList: VCContactDetailDelegate {
    func contactDetailUpdate(lastUpdated: Contacts) {
        self.vContactList.setUiAfterUpdateFavourites(atIdx: tupSelectedContact.index, contact: lastUpdated)
    }
}

//MARK: - VCContactEditDelegate
extension VCContactList: VCContactEditDelegate {
    func VCContactEditUpdateSuccess(contact: Contacts) {
        self.vContactList.arrContacts.append(contact)
        
        self.vContactList.arrContacts = self.vContactList.arrContacts.sorted(by: { ($0.strFirstName?.lowercased())! < ($1.strFirstName?.lowercased())! })
    }
}
