//
//  AFApiClient.swift
//  myAddressBook
//
//  Created by lucy on 24/05/19.
//  Copyright © 2019 lucy. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

typealias resultHendler = (JSON?,Error?)

class AFApiClient: NSObject {
    
    func request(httpMethod: Alamofire.HTTPMethod , urlString: String, requestHendler: @escaping (resultHendler) -> Void) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        var requestResult: (jsonData: JSON?, error: Error?)
        
        Alamofire.request(urlString).responseJSON { response in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            debugPrint(response)
            
            switch response.result {
            case .success:
                if let data = response.result.value {
                    requestResult.jsonData = JSON(data)
                    requestHendler(requestResult)
                }
            case .failure(let _error):
                requestResult.error = _error
                requestHendler(requestResult)
            }
        }
    }
    
    func requestCallBack(urlString: String, requestHendler: @escaping (resultHendler) -> Void) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        var requestResult: (jsonData: JSON?, error: Error?)
        
        Alamofire.request(urlString).responseString { response in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            debugPrint(response)
            
            switch response.result {
            case .success:
                if let data = response.result.value {
                    requestResult.jsonData = JSON(data)
                    requestHendler(requestResult)
                }
            case .failure(let _error):
                requestResult.error = _error
                requestHendler(requestResult)
            }
        }
        
    }
    
    func request(param: [String: Any], httpMethod: Alamofire.HTTPMethod, paramEncoding: ParameterEncoding = URLEncoding.default , strUrl: String, requestHendler: @escaping (resultHendler) -> Void) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        var requestResult: (jsonData: JSON?, error: Error?)
        
        Alamofire.request(strUrl, method: httpMethod, parameters: param, encoding: paramEncoding, headers: [:])
            .responseJSON { response in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                print(response.request as Any)  // original URL request
                print(response.response as Any) // URL response
                print(response.result.value as Any)   // result of response serialization
                
                switch response.result {
                case .success:
                    if let data = response.result.value {
                        requestResult.jsonData = JSON(data)
                        requestHendler(requestResult)
                    }
                case .failure(let _error):
                    requestResult.error = _error
                    requestHendler(requestResult)
                }
        }
    }
    
    func upload(param: [String : Any]? = nil, httpMethod: Alamofire.HTTPMethod, strUrl: String, handler: @escaping (resultHendler) -> Void, source: UIImage) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let dtFormat: DateFormatter = DateFormatter()
        dtFormat.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dtFormat.timeZone = TimeZone.current
        
        let strDate: String = dtFormat.string(from: Date())
        let strImageName: String = "img-\(strDate)"
        
        var dtImg: Data = Data()
        
        if let _dtImg: Data = source.jpegData(compressionQuality: 0.1) { dtImg = _dtImg }
        
        var requestResult: (jsonData: JSON?, error: Error?)
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(dtImg, withName: "profile_pic",fileName: "\(strImageName).jpg", mimeType: "image/jpg")
            
            if let _param: [String : Any] = param {
                for (key, value) in _param {
                    let strValue: String = String(describing: value)
                    
                    multipartFormData.append(strValue.data(using: String.Encoding.utf8)!, withName: key)
                }
            }
        }, to: strUrl) { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    print(response.request as Any)  // original URL request
                    print(response.response as Any) // URL response
                    print(response.result.value as Any)   // result of response serialization
                    
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false

                    if let data = response.result.value {
                        requestResult.jsonData = JSON(data)
                        
                        handler(requestResult)
                    } else if let _error: Error = response.error {
                        requestResult.error = _error
                        
                        handler(requestResult)
                    }
                }
            case .failure(let err):
                print(err as Any)  // original URL request
                
                UIApplication.shared.isNetworkActivityIndicatorVisible = false

                requestResult.error = err
                
                handler(requestResult)
            }
        }
    }
    
    func cancelRequest() {
        if #available(iOS 9.0, *) {
            Alamofire.SessionManager.default.session.getAllTasks { (tasks) in
                tasks.forEach({$0.cancel()})
            }
        } else {
            
        }
    }
}
