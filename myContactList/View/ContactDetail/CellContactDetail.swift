//
//  CellContactDetail.swift
//  myContactList
//
//  Created by lucy on 26/05/19.
//  Copyright © 2019 lucy. All rights reserved.
//

import UIKit

//MARK: - Protocol
protocol CellContentDetailDelegate {
    func cellContactDetailShouldReturn(atIdx: Int)
}

//MARK: - Class Declaration
class CellContactDetail: UITableViewCell {
    //MARK: - Outlets
    @IBOutlet weak fileprivate var lblTitle: UILabel!
    @IBOutlet weak fileprivate var lblValue: UILabel!
    @IBOutlet weak fileprivate var txtFieldValue: UITextField!
    
    //MARK: - Attributes Navigation
    var delegate: CellContentDetailDelegate?
    
    //MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUi(title: String, value: String?, isForEdit: Bool = false) {
        lblTitle.attributedText = createAttributeString(value: title, isForTitle: true)
        
        if isForEdit {
            lblValue.text = nil
            lblValue.attributedText = nil
            lblValue.isHidden = true
            
            txtFieldValue.placeholder = lblTitle.attributedText?.string
            txtFieldValue.text = value
            txtFieldValue.attributedText = createAttributeString(value: value, isForTitle: false)
            txtFieldValue.isHidden = false
            txtFieldValue.tag = self.tag
        } else {
            lblValue.attributedText = createAttributeString(value: value, isForTitle: false)
            lblValue.isHidden = false
            
            txtFieldValue.placeholder = nil
            txtFieldValue.text = nil
            txtFieldValue.attributedText = nil
            txtFieldValue.isHidden = true
            txtFieldValue.tag = 0
        }
    }
    
    func setUiForEdit(keyboardType: UIKeyboardType, returnType: UIReturnKeyType) {
        txtFieldValue.keyboardType = keyboardType
        txtFieldValue.returnKeyType = returnType
        
        if keyboardType == UIKeyboardType.phonePad {
            let vwInputAccessory: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.contentView.frame.width, height: 44))
            vwInputAccessory.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
            vwInputAccessory.translatesAutoresizingMaskIntoConstraints = false
            
            let btnNext: UIButton = UIButton(type: UIButton.ButtonType.system)
            btnNext.setTitle("Next", for: .normal)
            btnNext.addTarget(self, action: #selector(actNext(sender:)), for: .touchUpInside)
            btnNext.translatesAutoresizingMaskIntoConstraints = false
            btnNext.tag = txtFieldValue.tag
            
            txtFieldValue.inputAccessoryView = vwInputAccessory

            vwInputAccessory.addSubview(btnNext)
            
            NSLayoutConstraint.activate([
                btnNext.trailingAnchor.constraint(equalTo:
                    vwInputAccessory.trailingAnchor, constant: -20),
                btnNext.centerYAnchor.constraint(equalTo:
                    vwInputAccessory.centerYAnchor)
            ])
        } else {
            txtFieldValue.inputAccessoryView = nil
        }
    }
    
    //MARK: - Actions
    @objc func actNext(sender: UIButton) {
        if sender.titleLabel?.text?.lowercased() == "done" {
            txtFieldValue.resignFirstResponder()
        } else {
            delegate?.cellContactDetailShouldReturn(atIdx: sender.tag)
        }
    }
    
    //MARK: - Helper
    fileprivate func createAttributeString(value: String?, isForTitle: Bool) -> NSAttributedString {
        let parStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
        parStyle.lineBreakMode = NSLineBreakMode.byTruncatingTail
        parStyle.alignment = isForTitle ? NSTextAlignment.right : NSTextAlignment.left
        
        let fltGrayValue: CGFloat = 74.0/255.0
        
        let attrStr: NSAttributedString =
            NSAttributedString(string: value ?? "", attributes: [
            NSAttributedString.Key.kern : -0.5,
            NSAttributedString.Key.foregroundColor : UIColor(red: fltGrayValue, green: fltGrayValue, blue: fltGrayValue, alpha: isForTitle ? 0.5 : 1.0),
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16.0)
        ])
        
        return attrStr
    }

    func forceActiveField() {
        txtFieldValue.becomeFirstResponder()
    }
    
    func getTitleAndValueFromField() -> (String?, String?) {
        return (lblTitle.text, txtFieldValue.text)
    }
}

extension CellContactDetail: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.returnKeyType == UIReturnKeyType.done {
            textField.resignFirstResponder()
        } else {
            delegate?.cellContactDetailShouldReturn(atIdx: textField.tag)
        }
        
        return true
    }
}
