//
//  ExtView.swift
//  myAddressBook
//
//  Created by lucy on 24/05/19.
//  Copyright © 2019 lucy. All rights reserved.
//

import Foundation
import Kingfisher
import UIKit

extension UIView {
    
    func loadViewFromNIB() -> UIView {
        let bundle = Bundle(for:type(of: self))
        let nib = UINib(nibName: String(describing: self.classForCoder), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
    
    static func getViewFromNib(bundle bdl: Bundle? = nil, nibName strNibName: String? = nil, tag intTag: Int) -> UIView? {
        let nib: UINib
        
        if let strNibName = strNibName {
            if let bdl = bdl {
                nib = UINib(nibName: strNibName, bundle: bdl)
            } else {
                nib = UINib(nibName: strNibName, bundle: Bundle(for: self.classForCoder()))
            }
        } else {
            if let bdl = bdl {
                nib = UINib(nibName: String(describing: self.classForCoder()), bundle: bdl)
            } else {
                nib = UINib(nibName: String(describing: self.classForCoder()), bundle: Bundle(for: self.classForCoder()))
            }
        }
        let obj   = nib.instantiate(withOwner: nil, options: nil)
        
        for vw in obj {
            if let vw = vw as? UIView {
                if intTag == -1 {
                    if vw.isKind(of: self.classForCoder()) {
                        return vw
                    }
                } else {
                    if vw.tag == intTag {
                        return vw
                    }
                }
            }
        }
        return nil
    }
}

extension UIStoryboard {
    static func getMainStoryboard() -> UIStoryboard {
        return UIStoryboard.init(name: "Main", bundle: nil)
    }
}


extension UIFont {
    static func  printAllFonts() {
        for familyName in UIFont.familyNames as [String] {
            print("\(familyName)")
            for fontName in UIFont.fontNames(forFamilyName: familyName) as [String] {
                print("\tFont: \(fontName)")
            }
        }
    }
}

extension UIImageView {
    enum AssetIdentifier: String {
        case avatar
        case icon
        case general
        case loading
        case none
    }
    
    func setImage(source: String, type: AssetIdentifier, contentMode: UIView.ContentMode) {
        func loadImage(urlSource: String) {
            let imgPlaceholder: UIImage?
            
            switch type {
            case .avatar:
                imgPlaceholder = UIImage(named: "icon-placeholder-contact")
            case.icon:
                imgPlaceholder = UIImage(named: "placeholder")
            case .general:
                imgPlaceholder = UIImage(named: "placeholder")
            case .loading:
                imgPlaceholder = nil
            default:
                imgPlaceholder = nil
            }
            
            
            if !urlSource.isEmpty {
                let url: URL? = URL(string: urlSource)
                
                if imgPlaceholder != nil {
                    let imgVwDummyPlaceholder: UIImageView = UIImageView(image: imgPlaceholder)
                    imgVwDummyPlaceholder.contentMode = UIView.ContentMode.scaleAspectFit
                    imgVwDummyPlaceholder.translatesAutoresizingMaskIntoConstraints = false
                    self.addSubview(imgVwDummyPlaceholder)
                    
                    let consCenterXImgVwDummyPlaceholderToSelf: NSLayoutConstraint = NSLayoutConstraint(item: imgVwDummyPlaceholder, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1.0, constant: 0.0)
                    let consCenterYImgVwDummyPlaceholderToSelf: NSLayoutConstraint = NSLayoutConstraint(item: imgVwDummyPlaceholder, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1.0, constant: 0.0)
                    self.addConstraint(consCenterXImgVwDummyPlaceholderToSelf)
                    self.addConstraint(consCenterYImgVwDummyPlaceholderToSelf)
                    
                    self.kf.setImage(with: url, placeholder: nil, options: [.transition(ImageTransition.fade(0.2))], progressBlock: { (intCurentProgress,intProgressTotal) in
                        
                        if intCurentProgress == intProgressTotal {
                            imgVwDummyPlaceholder.removeFromSuperview()
                        }
                        
                    }, completionHandler: { (image, error, cacheType, imageURL) in
                        imgVwDummyPlaceholder.removeFromSuperview()
                        if error == nil {
                            self.contentMode = contentMode
                        } else {
                            self.image = imgPlaceholder
                            self.contentMode = UIView.ContentMode.scaleAspectFit
                        }
                    })
                }else {
                    if type != .none {
                        kf.indicatorType = .activity
                    }
                    kf.setImage(with: url)
                }
                
            } else {
                self.image = imgPlaceholder
            }
        }
        
        if !source.isEmpty {
            guard let _img: UIImage = UIImage(named: source) else {
                let strImgFullPath: String = source
   
                loadImage(urlSource: strImgFullPath)
                return
            }
            
            self.image = _img
        } else {
            loadImage(urlSource: source)
        }
    }
}
