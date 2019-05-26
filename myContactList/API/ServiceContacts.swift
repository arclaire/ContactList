//
//  ServiceContacts.swift
//  myAddressBook
//
//  Created by lucy on 24/05/19.
//  Copyright © 2019 lucy. All rights reserved.
//

import Alamofire
import Foundation
import SwiftyJSON

class ServiceContacts {
    
    #if DEBUG
    private static let BASE_URL: String = "https://gojek-contacts-app.herokuapp.com"
    #else
    private static let BASE_URL: String = "https://gojek-contacts-app.herokuapp.com"
    #endif
    private static let apiClient = AFApiClient()
    
    //MARK: - CallBacks
    typealias callBackGetPeople = ([Contacts]) -> Void
    typealias callBackGetPeopleDetail = (Contacts) -> Void
    typealias callBackError = (Error) -> Void
   
    private static func isResponseValid(json: JSON) -> (isValid: Bool, message: String) {
        let strMessage: String
        if let _strMessage: String = json["message"].string {
            strMessage = _strMessage
        } else {
            strMessage = ""
        }
        
        if let _isValid: Bool = json["status"].bool {
            return (_isValid, strMessage)
        } else {
            return (false, strMessage)
        }
    }
    
    static func getContactsDetail(id: String, onsuccess callbackSuccess: @escaping callBackGetPeopleDetail, onError: @escaping callBackError) {
        let strUrl: String = "\(BASE_URL)/contacts/\(id).json"
        let params: [String : Any] = [:]
        self.apiClient.request(param: params, httpMethod: .get, strUrl: strUrl) { (result) in
            let (jsonData,error) = result
            if let _jsonData = jsonData {
                debugPrint("ITEM", _jsonData)
                callbackSuccess(Contacts(jsonData: _jsonData))
            }else {
                onError(error!)
            }
        }
    }
    
    static func getContacts(onsuccess callbackSuccess: @escaping callBackGetPeople, onError: @escaping callBackError ) {
        
        let strUrl: String = "\(BASE_URL)/contacts.json"
        
        var arrPeople: [Contacts] = [Contacts]()
        let params: [String : Any] = [:]
        self.apiClient.request(param: params, httpMethod: .get, strUrl: strUrl) { (result) in
            let (jsonData,error) = result
            if let _jsonData = jsonData {
                for data in _jsonData.arrayValue {
                    arrPeople.append(Contacts(jsonData: data))
                    //debugPrint("ITEM", data)
                }
                callbackSuccess(arrPeople)
            }else {
                onError(error!)
            }
        }
    }
    
    static func updateContact(data: Contacts, image: UIImage? = nil, onsuccess callbackSuccess: @escaping callBackGetPeopleDetail, onError: @escaping callBackError) {
//        http://gojek-contacts-app.herokuapp.com/contacts/5453.json
        
        let strId: String = data.strId ?? "0"
        let strUrl: String = "\(BASE_URL)/contacts/\(strId).json"
        
        var params: [String : Any] = [:]
        
        if let _strFirstName: String = data.strFirstName {
            if !_strFirstName.isEmpty {
                params["first_name"] = _strFirstName
            }
        }
        
        if let _strLastName: String = data.strLastName {
            if !_strLastName.isEmpty {
                params["last_name"] = _strLastName
            }
        }
        
        if let _strEmail: String = data.strEmail {
            if !_strEmail.isEmpty {
                params["email"] = _strEmail
            }
        }
        
        if let _strPhone: String = data.strMobileNumber {
            if !_strPhone.isEmpty {
                params["phone_number"] = _strPhone
            }
        }
        
        if let _strImage: String = data.strImage {
            if !_strImage.isEmpty {
                params["profile_pic"] = _strImage
            }
        }
        
        params["favorite"] = data.isFavorite
        
        if let _img: UIImage = image {
            self.apiClient.upload(httpMethod: .put, strUrl: strUrl, handler: { (result) in
                let (jsonData,error) = result
                if let _jsonData = jsonData {
                    debugPrint("ITEM", _jsonData)
                    callbackSuccess(Contacts(jsonData: _jsonData))
                }else {
                    onError(error!)
                }
            }, source: _img)
        } else {
            self.apiClient.request(param: params, httpMethod: .put, paramEncoding: JSONEncoding.default, strUrl: strUrl) { (result) in
                let (jsonData,error) = result
                if let _jsonData = jsonData {
                    debugPrint("ITEM", _jsonData)
                    if let _errors = _jsonData["errors"].arrayObject as? [String] {
                        onError(NSError(domain: "", code: 0, userInfo: ["errors" : _errors]))
                    } else {
                        callbackSuccess(Contacts(jsonData: _jsonData))
                    }
                }else {
                    onError(error!)
                }
            }
        }
    }
    
    static func addContact(data: Contacts, image: UIImage? = nil, onsuccess callbackSuccess: @escaping callBackGetPeopleDetail, onError: @escaping callBackError) {
        let strUrl: String = "\(BASE_URL)/contacts.json"
        
        var params: [String : Any] = [:]
        
        if let _strFirstName: String = data.strFirstName {
            if !_strFirstName.isEmpty {
                params["first_name"] = _strFirstName
            }
        }
        
        if let _strLastName: String = data.strLastName {
            if !_strLastName.isEmpty {
                params["last_name"] = _strLastName
            }
        }
        
        if let _strEmail: String = data.strEmail {
            if !_strEmail.isEmpty {
                params["email"] = "ssss@gmail.com"
            }
        }
        
        if let _strPhone: String = data.strMobileNumber {
            if !_strPhone.isEmpty {
                params["phone_number"] = 8374322675
            }
        }
        
        if let _strImage: String = data.strImage {
            if !_strImage.isEmpty {
                params["profile_pic"] = _strImage
            }
        }
        
        params["favorite"] = false
        
        if let _img: UIImage = image {
            self.apiClient.upload(httpMethod: .put, strUrl: strUrl, handler: { (result) in
                let (jsonData,error) = result
                if let _jsonData = jsonData {
                    debugPrint("ITEM", _jsonData)
                    callbackSuccess(Contacts(jsonData: _jsonData))
                }else {
                    onError(error!)
                }
            }, source: _img)
        } else {
            self.apiClient.request(param: params, httpMethod: .post, paramEncoding: JSONEncoding.default, strUrl: strUrl) { (result) in
                let (jsonData,error) = result
                if let _jsonData = jsonData {
                    debugPrint("ITEM", _jsonData)
                    if let _errors = _jsonData["errors"].arrayObject as? [String] {
                        onError(NSError(domain: "", code: 0, userInfo: ["errors" : _errors]))
                    } else {
                        callbackSuccess(Contacts(jsonData: _jsonData))
                    }
                }else {
                    onError(error!)
                }
            }
        }
    }
}
