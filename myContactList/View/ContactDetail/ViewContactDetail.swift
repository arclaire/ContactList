//
//  ViewContactDetail.swift
//  myAddressBook
//
//  Created by lucy on 24/05/19.
//  Copyright © 2019 lucy. All rights reserved.
//

import UIKit
import MessageUI

//MARK: - Protocol
protocol ViewContactDetailDelegate {
    func viewContactDetailFavourite(lastContactData: Contacts)
    func viewContactDetailSendSms(recipient: String)
    func viewContactDetailError(message: String)
}

//MARK: - Class
class ViewContactDetail: UIView {
    //MARK: - Outlets
    @IBOutlet fileprivate var vw: UIView!

    @IBOutlet weak fileprivate var vwHeader: UIView!
    @IBOutlet weak fileprivate var vwProfilePicture: UIView!
    @IBOutlet weak fileprivate var imgVwProfilePicture: UIImageView!
    @IBOutlet weak fileprivate var lblName: UILabel!
    @IBOutlet weak fileprivate var imgFav: UIImageView!
    
    @IBOutlet fileprivate var lbMenuTitle: [UILabel]!
    
    @IBOutlet weak fileprivate var tblContactDetail: UITableView!
    @IBOutlet weak fileprivate var vLoading: UIView!
    @IBOutlet weak fileprivate var actLoading: UIActivityIndicatorView!
    var caBgLayer: CAGradientLayer = CAGradientLayer()
    //MARK: - Attributes Navigation
    fileprivate var contact: Contacts = Contacts()
    
    var delegate: ViewContactDetailDelegate?
    
    //MARK: - Attributes
    fileprivate var isLoading: Bool = false {
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
    
    //MARK: - Initialization
    required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)!
      
      self.vw = self.loadViewFromNIB()
      self.vw.frame = self.frame
        
      if let _ = self.vw {
        self.addSubview(self.vw)
      }
    }
    
    //MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()

        let clrTop = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0).cgColor
        let clrBot = UIColor(red: 80.0/255.0, green: 227.0/255.0, blue: 194.0/255.0, alpha: 0.28).cgColor
       
        caBgLayer.colors = [clrTop, clrBot]
        caBgLayer.locations = [0.0, 1.0]
        caBgLayer.frame = vwHeader.frame
        caBgLayer.opacity = 0.55
        vwHeader.backgroundColor = UIColor.clear
        vwHeader.layer.insertSublayer(caBgLayer, at: 0)
        self.vwHeader.setNeedsLayout()
        
        for lbl in lbMenuTitle {
            var strTitle: String = ""
            
            switch lbl.tag {
            case 0: strTitle = "message"
            case 1: strTitle = "call"
            case 2: strTitle = "email"
            case 3: strTitle = "favourite"
            default: break
            }
            
            lbl.attributedText = NSAttributedString(string: strTitle, attributes: [
                NSAttributedString.Key.kern : -0.5,
                NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12.0)
            ])
        }
        
        self.imgVwProfilePicture.layer.borderColor = UIColor.white.cgColor
        self.imgVwProfilePicture.layer.borderWidth = 3.0
       
        let classCellContactDetail: AnyClass = CellContactDetail.classForCoder()
        let strNibName: String = String(describing: classCellContactDetail)
        let nib: UINib = UINib(nibName: strNibName, bundle: Bundle(for: classCellContactDetail))
        self.tblContactDetail.register(nib, forCellReuseIdentifier: strNibName)
        tblContactDetail.tableFooterView = UIView()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.caBgLayer.frame = self.vwHeader.bounds
    }
   
    func setUiViewDidLoad(contact: Contacts) {
        isLoading = true
        
        let strImageUrl = contact.strImage ?? ""
        imgVwProfilePicture.setImage(source: strImageUrl, type: .avatar, contentMode: .scaleAspectFill)
        
        updateUi(contact: contact)
    }
    
    func setUiAfterGetData(contact: Contacts?) {
        isLoading = false
        
        guard let _contact: Contacts = contact else {
            return
        }
        
        updateUi(contact: _contact)
    }
    
    func setUiAfterError() {
        isLoading = false
    }
    
    //MARK: - Helper
    fileprivate func updateUi(contact: Contacts) {
        let strFirstName = contact.strFirstName ?? "unknown"
        let strLastName = contact.strLastName ?? ""
        
        self.lblName.text = String(format: "%@ %@", strFirstName, strLastName)
        
        if contact.isFavorite {
            imgFav.image = UIImage(named: "icon-fav-selected")
        } else {
            imgFav.image = UIImage(named: "icon-fav-unselected")
        }
        
        self.contact = contact
        
        self.tblContactDetail.reloadData()
    }
    
    fileprivate func openUrl(forFeature: String) {
        var isError: Bool = true
        
        var strSource: String = ""
        
        switch forFeature {
            case "sms":
                strSource = contact.strMobileNumber ?? ""
                strSource = "sms:+\(strSource)&body=Hello."
            case "tel":
                strSource = contact.strMobileNumber ?? ""
                strSource = "tel://\(strSource)"
            case "mail":
                strSource = contact.strEmail ?? ""
                strSource = "mailto:\(strSource)"
            default: break
        }
        
        if let _strSourceEncoded: String = strSource.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let _urlSource: URL =  URL(string: _strSourceEncoded),
            UIApplication.shared.canOpenURL(_urlSource) {
            isError = false
            
            if(forFeature == "sms") {
                delegate?.viewContactDetailSendSms(recipient: strSource)
            } else {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(_urlSource, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(_urlSource)
                }
            }
            
        }
        
        if isError {
            delegate?.viewContactDetailError(message: "Sorry, but this feature is unavailable right now")
        }
    }
    
    //MARK: - Actions
    @IBAction func actMessage(_ sender: UIButton) {
        self.openUrl(forFeature: "sms")
    }
    
    @IBAction func actCall(_ sender: UIButton) {
        self.openUrl(forFeature: "tel")
    }
    
    @IBAction func actEmail(_ sender: UIButton) {
        self.openUrl(forFeature: "mail")
    }
    
    @IBAction func actFav(_ sender: UIButton) {
        guard let _delegate: ViewContactDetailDelegate = delegate else { return }
        
        self.isLoading = true
        
        _delegate.viewContactDetailFavourite(lastContactData: self.contact)
    }
    
}

//MARK: - UITableViewDelegate
extension ViewContactDetail: UITableViewDelegate {
    //MARK: Helper
    //MARK: Delegate
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let _cell: CellContactDetail = cell as? CellContactDetail else { return }
        
        switch indexPath.row {
        case 0:
            _cell.setUi(title: "First Name", value: contact.strFirstName)
        case 1:
            _cell.setUi(title: "Last Name", value: contact.strLastName)
        case 2:
            _cell.setUi(title: "mobile", value: contact.strMobileNumber)
        case 3:
            _cell.setUi(title: "email", value: contact.strEmail)
        default: break
        }
    }
}

//MARK: - UITableViewDataSource
extension ViewContactDetail: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let classCell: AnyClass = CellContactDetail.classForCoder()
        let strNibName: String = String(describing: classCell)
        
        guard let _cell: CellContactDetail = tableView.dequeueReusableCell(withIdentifier: strNibName, for: indexPath) as? CellContactDetail else {
            return UITableViewCell()
        }
        
        return _cell
    }
}
