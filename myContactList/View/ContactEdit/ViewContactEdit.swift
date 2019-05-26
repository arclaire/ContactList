//
//  ViewContactEdit.swift
//  myAddressBook
//
//  Created by lucy on 24/05/19.
//  Copyright © 2019 lucy. All rights reserved.
//

import UIKit

//MARK: - Protocol
protocol ViewContactEditDelegate {
    func showOptionForCameraOrAlbum()
}

//MARK: -
class ViewContactEdit: UIView {
    //MARK: - Enum
    enum FieldTitle: String {
        case FName = "First Name"
        case LName = "Last Name"
        case Mobile = "mobile"
        case Email = "email"
    }
    
    //MARK: - Outlets
    @IBOutlet fileprivate var vw: UIView!
    
    @IBOutlet weak fileprivate var vwHeader: UIView!
    @IBOutlet weak fileprivate var imgVwProfilePicture: UIImageView!
    @IBOutlet weak fileprivate var tblContactEdit: UITableView!
    @IBOutlet weak fileprivate var vLoading: UIView!
    @IBOutlet weak fileprivate var actLoading: UIActivityIndicatorView!
    
    var caBgLayer: CAGradientLayer = CAGradientLayer()
    //MARK: - Attributes Navigation
    fileprivate var contact: Contacts = Contacts()
    
    var delegate: ViewContactEditDelegate?
    
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
        
        imgVwProfilePicture.layer.borderColor = UIColor.white.cgColor
        imgVwProfilePicture.layer.borderWidth = 3.0
        imgVwProfilePicture.layer.cornerRadius = imgVwProfilePicture.frame.width / 2.0
        
        let classCellContactDetail: AnyClass = CellContactDetail.classForCoder()
        let strNibName: String = String(describing: classCellContactDetail)
        let nib: UINib = UINib(nibName: strNibName, bundle: Bundle(for: classCellContactDetail))
        self.tblContactEdit.register(nib, forCellReuseIdentifier: strNibName)
        tblContactEdit.tableFooterView = UIView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.caBgLayer.frame = self.vwHeader.bounds
    }
    
    func setUiViewDidLoad(contact: Contacts) {
        isLoading = false
        
        let strImageUrl = contact.strImage ?? ""
        imgVwProfilePicture.setImage(source: strImageUrl, type: .avatar, contentMode: .scaleAspectFill)
        
        self.contact = contact
        
        self.tblContactEdit.reloadData()
    }
    
    func setUiAfterGetImage(image: UIImage) {
        imgVwProfilePicture.image = image
    }
    
    func setUiBeforeUpdate() {
        isLoading = true
    }
    
    func setUiAfterError() {
        isLoading = false
    }
    
    //MARK: - Helper
    func getLastUpdatedData() -> Contacts {
        let contactLastUpdated: Contacts = self.contact.copy()
        
        for intIdx in 0..<tblContactEdit.numberOfRows(inSection: 0) {
            let idxPath: IndexPath = IndexPath(row: intIdx, section: 0)
            
            guard let _cellCurrent: CellContactDetail = tblContactEdit.cellForRow(at: idxPath) as? CellContactDetail else {
                continue
            }
            
            let cellData: (title: String?, value: String?) = _cellCurrent.getTitleAndValueFromField()
            
            guard let _strTitle: String = cellData.title,
                 let _strValue: String = cellData.value else {
                    continue
            }
            
            switch _strTitle {
            case FieldTitle.FName.rawValue:
                contactLastUpdated.strFirstName = _strValue
            case FieldTitle.LName.rawValue:
                contactLastUpdated.strLastName = _strValue
            case FieldTitle.Mobile.rawValue:
                contactLastUpdated.strMobileNumber = _strValue
            case FieldTitle.Email.rawValue:
                contactLastUpdated.strEmail = _strValue
            default: break
            }
        }
        
        return contactLastUpdated
    }
    
    //MARK: - Actions
    @IBAction func actOpenCameraOrAlbum(_ sender: UIButton) {
        delegate?.showOptionForCameraOrAlbum()
    }
}

//MARK: - UITableViewDelegate
extension ViewContactEdit: UITableViewDelegate {
    //MARK: Delegate
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let _cell: CellContactDetail = cell as? CellContactDetail else { return }
        
        switch indexPath.row {
        case 0:
            _cell.setUi(title: FieldTitle.FName.rawValue, value: contact.strFirstName, isForEdit: true)
            _cell.setUiForEdit(keyboardType: UIKeyboardType.default, returnType: UIReturnKeyType.next)
        case 1:
            _cell.setUi(title: FieldTitle.LName.rawValue, value: contact.strLastName, isForEdit: true)
            _cell.setUiForEdit(keyboardType: UIKeyboardType.default, returnType: UIReturnKeyType.next)
        case 2:
            _cell.setUi(title: FieldTitle.Mobile.rawValue, value: contact.strMobileNumber, isForEdit: true)
            _cell.setUiForEdit(keyboardType: UIKeyboardType.phonePad, returnType: UIReturnKeyType.next)
        case 3:
            _cell.setUi(title: FieldTitle.Email.rawValue, value: contact.strEmail, isForEdit: true)
            _cell.setUiForEdit(keyboardType: UIKeyboardType.emailAddress, returnType: UIReturnKeyType.done)
        default: break
        }
    }
}

//MARK: - UITableViewDataSource
extension ViewContactEdit: UITableViewDataSource {
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
        
        _cell.selectionStyle = UITableViewCell.SelectionStyle.none
        _cell.tag = indexPath.row
        _cell.delegate = self
        
        return _cell
    }
}

//MARK: - CellContactDetailDelegate
extension ViewContactEdit: CellContentDetailDelegate {
    func cellContactDetailShouldReturn(atIdx: Int) {
        if atIdx + 1 < tblContactEdit.numberOfRows(inSection: 0) {
            let idxPathNext: IndexPath = IndexPath(row: atIdx + 1, section: 0)
            
            guard let _cellCurrent: CellContactDetail = tblContactEdit.cellForRow(at: idxPathNext) as? CellContactDetail else {
                return
            }
            
            _cellCurrent.forceActiveField()
        }
    }
}
