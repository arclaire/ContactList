//
//  ViewContactList.swift
//  myAddressBook
//
//  Created by lucy on 24/05/19.
//  Copyright © 2019 lucy. All rights reserved.
//

import UIKit

protocol ViewContactListDelegate {
    func showContactDetail(atIdx: Int, contact: Contacts)
}

class ViewContactList: UIView {

    private var vw:UIView!
    //MARK: Outlets
    @IBOutlet weak var tblContacts: UITableView!
    @IBOutlet weak var actLoading: UIActivityIndicatorView!
    
    
    @IBOutlet weak var vLoading: UIView!
  
    var delegate: ViewContactListDelegate?
    var arrContactsGrouped: [String: [Contacts]] = [:] {
        didSet {
            self.tblContacts.reloadData()
            
        }
    }
    
    var arrContacts: [Contacts] = [] {
        didSet {
            var arrTitle: [String] = []
            for i in 0...self.arrContacts.count - 1 {
              arrTitle.append("\(String(describing: self.arrContacts[i].strFirstName!.prefix(1).capitalized))")
//                arrTitle.append(self.arrContacts[i].strFirstName?.first?.lowercased() ?? " ")
            }
            self.arrContactTitle = Array(Set<String>(arrTitle)).sorted(by: { $0.lowercased() < $1.lowercased()})
        }
    }
    
    var arrContactTitle: [String] = [] {
        didSet {
            for i in 0...self.arrContactTitle.count - 1 {
                var arr:[Contacts] = []
                for j in 0...self.arrContacts.count - 1 {
                    if self.arrContactTitle[i].lowercased() == String(self.arrContacts[j].strFirstName!.first!).lowercased()  {
                        arr.append(self.arrContacts[j])
                    }
                }
                self.arrContactsGrouped[self.arrContactTitle[i]] = arr
            }
        }
    }
    
    
    var isLoading: Bool = false {
        didSet {
            if self.isLoading {
                self.vLoading.isHidden = false
                actLoading.startAnimating()
            } else {
                self.vLoading.isHidden = true
                actLoading.stopAnimating()
            }
           
        }
    }
   
    //MARK: Initialization
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        self.vw = self.loadViewFromNIB()
        if let _ = self.vw {
            self.addSubview(self.vw)
        }
    }
    
    //MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.prepareUI()
        self.tblContacts.delegate = self
        self.tblContacts.dataSource = self
        let classCellContact: AnyClass = CellContact.classForCoder()
        let strNibName: String = String(describing: classCellContact)
        let nib: UINib = UINib(nibName: strNibName, bundle: Bundle(for: classCellContact))
        self.tblContacts.register(nib, forCellReuseIdentifier: strNibName)
    }
    
    //MARK: - UI Methods
    
    func prepareUI() {
       
    }
    func setUiAfterUpdateFavourites(atIdx: Int, contact: Contacts) {
        arrContacts[atIdx] = contact
        
        self.tblContacts.reloadData()
    }
    //MARK: - Data Methods
    
    func reloadData() {
        self.tblContacts.reloadData()
    }
    
    //MARK: - ButtonAction
    
    @IBAction func doTapButton(_ sender: Any) {
        
       
    }
}


extension ViewContactList: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      let contactSelected: Contacts = arrContacts[indexPath.row]
      
    delegate?.showContactDetail(atIdx: indexPath.row, contact: contactSelected)
    }
}

extension ViewContactList: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let strTitleSection = self.arrContactTitle[section]
        return self.arrContactsGrouped[strTitleSection]?.count ?? 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrContactTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let classCell: AnyClass = CellContact.classForCoder()
        let strNibName: String = String(describing: classCell)
        
        guard let _cellContact: CellContact = tableView.dequeueReusableCell(withIdentifier: strNibName, for: indexPath) as? CellContact else {
            let _cellContact = CellContact(style: UITableViewCell.CellStyle.default, reuseIdentifier: strNibName)
            
            return _cellContact
        }
        
        let strTitle = self.arrContactTitle[indexPath.section]
        if strTitle.count > 0 {
            let contact = self.arrContactsGrouped[strTitle]![indexPath.row]
            _cellContact.dataContacts = contact
        }
       
        return _cellContact
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65.0
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return self.arrContactTitle
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 31.0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let strTitle = self.arrContactTitle[section]
        return strTitle
    }
}
