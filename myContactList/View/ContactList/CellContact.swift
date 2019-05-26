//
//  CellContact.swift
//  myAddressBook
//
//  Created by lucy on 24/05/19.
//  Copyright © 2019 lucy. All rights reserved.
//

import UIKit

class CellContact: UITableViewCell {

  
    @IBOutlet weak var imgFav: UIImageView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnFav: UIButton!
    
    var dataContacts: Contacts = Contacts() {
        didSet{
            let strFirstName = self.dataContacts.strFirstName ?? "unknown"
            let strLastName = self.dataContacts.strLastName ?? "unknown"
            let strImageUrl = self.dataContacts.strImage ?? ""
            self.lblName.text = String(format: "%@ %@", strFirstName, strLastName)
            self.imgFav.isHidden = !self.dataContacts.isFavorite
            if strImageUrl.count > 0 {
                if !strImageUrl.contains("missing") {
                    self.imgProfile.setImage(source: strImageUrl, type: .general, contentMode: .scaleAspectFill)
                }
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
   
}
