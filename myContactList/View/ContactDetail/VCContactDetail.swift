//
//  VCContactDetail.swift
//  myAddressBook
//
//  Created by lucy on 24/05/19.
//  Copyright © 2019 lucy. All rights reserved.
//

import UIKit
import MessageUI

//MARK: - Protocol
protocol VCContactDetailDelegate {
    func contactDetailUpdate(lastUpdated: Contacts)
}

//MARK: - Initialization
class VCContactDetail: UIViewController {
    //MARK: - Outlets
    @IBOutlet var vContactDetail: ViewContactDetail!
    
    //MARK: - Attributes Navigation
    var contact: Contacts = Contacts()
    var delegate: VCContactDetailDelegate?
    
    //MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let _vcNav: UINavigationController = segue.destination as? UINavigationController {
            if let _vcLast: UIViewController = _vcNav.children.last,
                let _vcContactEdit: VCContactEdit = _vcLast as? VCContactEdit {
                _vcContactEdit.contact = self.contact.copy()
                _vcContactEdit.delegate = self
            }
        }
    }
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.vContactDetail.setUiViewDidLoad(contact: contact)
        self.vContactDetail.delegate = self
        self.getContactDetail()
    }
    
    //MARK: - API
    func getContactDetail() {
        ServiceContacts.getContactsDetail(id: contact.strId ?? "", onsuccess: { (contact) in
            self.contact = contact
            
            self.vContactDetail.setUiAfterGetData(contact: self.contact)
        }, onError: { (err) in
            self.vContactDetail.setUiAfterGetData(contact: nil)
        })
    }
    
    //MARK: - Actions
    @IBAction func actOpenEditContact(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "openContactEdit", sender: self)
    }
    
    //MARK: - Alert
    fileprivate func showError(message: String) {
        let alt: UIAlertController = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
        let actCancel: UIAlertAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil)
        alt.addAction(actCancel)
        
        present(alt, animated: true, completion: nil)
    }
}
//MARK: - ViewContactDetailDelegate
extension VCContactDetail: ViewContactDetailDelegate {
    func viewContactDetailFavourite(lastContactData: Contacts) {
        lastContactData.isFavorite = !lastContactData.isFavorite
        
        ServiceContacts.updateContact(data: lastContactData, onsuccess: { (contact) in
            self.contact = contact
            
            self.vContactDetail.setUiAfterGetData(contact: contact)
            
            self.delegate?.contactDetailUpdate(lastUpdated: contact)
        }) { (err) in
            self.vContactDetail.setUiAfterError()
        }
    }
    
    func viewContactDetailSendSms(recipient: String) {
        if MFMessageComposeViewController.canSendText() {
            let mfMessageComposer: MFMessageComposeViewController = MFMessageComposeViewController()
            mfMessageComposer.title = "Test Message"
            mfMessageComposer.recipients = [recipient]
            mfMessageComposer.subject = "Apps Invite"
            mfMessageComposer.body = ""
            mfMessageComposer.messageComposeDelegate = self
            
            present(mfMessageComposer, animated: true, completion: nil)
        } else {
            showError(message: "Sorry, but this feature is unavailable right now")
        }
    }
    
    func viewContactDetailError(message: String) {
        showError(message: message)
    }
}

//MARK: - MFMessageComposeViewController
extension VCContactDetail: MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
}


//MARK: - VCContactEditDelegate
extension VCContactDetail: VCContactEditDelegate {
    func VCContactEditUpdateSuccess(contact: Contacts) {
        self.contact = contact
        
        self.vContactDetail.setUiAfterGetData(contact: self.contact)
        
        self.delegate?.contactDetailUpdate(lastUpdated: self.contact)
    }
}
