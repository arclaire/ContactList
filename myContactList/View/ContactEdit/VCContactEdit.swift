//
//  VCContactEdit.swift
//  myAddressBook
//
//  Created by lucy on 24/05/19.
//  Copyright © 2019 lucy. All rights reserved.
//

import AVFoundation
import UIKit

//MARK: - Protocol
protocol VCContactEditDelegate {
    func VCContactEditUpdateSuccess(contact: Contacts)
}

//MARK: -
class VCContactEdit: UIViewController {
    //MARK: - Outlets
    @IBOutlet var vContactEdit: ViewContactEdit!
    
    //MARK: - Attributes Navigation
    var contact: Contacts = Contacts() {
        didSet {
            isEdit = true
        }
    }
    
    var delegate: VCContactEditDelegate?
  
    //MARK: - Attributes
    fileprivate var isEdit: Bool = false
    fileprivate var imgNew: UIImage?
    fileprivate var strImgNewName: String = ""
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.vContactEdit.setUiViewDidLoad(contact: contact)
        self.vContactEdit.delegate = self
    }
    
    //MARK: - Actions
    @IBAction func actCancel(_ sender: UIBarButtonItem) {
        self.vContactEdit.endEditing(true)
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func actDone(_ sender: UIBarButtonItem) {
        if isEdit {
            self.vContactEdit.endEditing(true)
            self.vContactEdit.setUiBeforeUpdate()
            
            ServiceContacts.updateContact(data: self.vContactEdit.getLastUpdatedData(), image: imgNew, onsuccess: { (contact) in
                let alt: UIAlertController = UIAlertController(title: "Update Success", message: nil, preferredStyle: UIAlertController.Style.alert)
                let actCancel: UIAlertAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: { (altAct) in
                    self.delegate?.VCContactEditUpdateSuccess(contact: contact)
                    
                    self.actCancel(UIBarButtonItem())
                })
                
                alt.addAction(actCancel)
                
                self.present(alt, animated: true, completion: nil)
            }) { (error) in
                var strError: String = ""
                
                if let _userInfo = error._userInfo {
                    if let _arrError: [String] = _userInfo["errors"] as? [String] {
                        for error in _arrError {
                            if strError.isEmpty { strError = error }
                            else { strError.append("\n\(error)")}
                        }
                    }
                }
                
                let alt: UIAlertController = UIAlertController(title: "Add Contact Error", message: strError, preferredStyle: UIAlertController.Style.alert)
                let actCancel: UIAlertAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil)
                
                alt.addAction(actCancel)
                
                self.present(alt, animated: true, completion: nil)
                
                self.vContactEdit.setUiAfterError()
            }
        } else {
            self.vContactEdit.endEditing(true)
            self.vContactEdit.setUiBeforeUpdate()
            
            ServiceContacts.addContact(data: self.vContactEdit.getLastUpdatedData(), image: imgNew, onsuccess: { (contact) in
                let alt: UIAlertController = UIAlertController(title: "Add Contact Success", message: nil, preferredStyle: UIAlertController.Style.alert)
                let actCancel: UIAlertAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: { (altAct) in
                    self.delegate?.VCContactEditUpdateSuccess(contact: contact)
                    
                    self.actCancel(UIBarButtonItem())
                })
                
                alt.addAction(actCancel)
                
                self.present(alt, animated: true, completion: nil)
            }) { (error) in
                var strError: String = ""
                
                if let _userInfo = error._userInfo {
                    if let _arrError: [String] = _userInfo["errors"] as? [String] {
                        for error in _arrError {
                            if strError.isEmpty { strError = error }
                            else { strError.append("\n\(error)")}
                        }
                    }
                }
                
                let alt: UIAlertController = UIAlertController(title: "Add Contact Error", message: strError, preferredStyle: UIAlertController.Style.alert)
                let actCancel: UIAlertAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil)
                
                alt.addAction(actCancel)
                
                self.present(alt, animated: true, completion: nil)
                
                self.vContactEdit.setUiAfterError()
            }
        }
    }
}

//MARK: -
extension VCContactEdit: ViewContactEditDelegate {
    func openAlbumOrCamera(isCamera: Bool) {
        var pickerAlbumOrCamera: UIImagePickerController?
        
        if isCamera {
            if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) { return openAlbumOrCamera(isCamera: false) }
            else if UIImagePickerController.isCameraDeviceAvailable(UIImagePickerController.CameraDevice.front) || UIImagePickerController.isCameraDeviceAvailable(UIImagePickerController.CameraDevice.rear) {
                let avStatus: AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
                
                if avStatus == AVAuthorizationStatus.denied {
                    let alt: UIAlertController = UIAlertController(title: "Unable to access the Camera", message: "To enable access, go to Settings > Privacy > Camera and turn on Camera access for this app.", preferredStyle: UIAlertController.Style.alert)
                    let actCancel: UIAlertAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil)
                    alt.addAction(actCancel)
                    
                    present(alt, animated: true, completion: nil)
                } else if avStatus == AVAuthorizationStatus.notDetermined {
                    AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (isGranted) in
                        if isGranted {
                            pickerAlbumOrCamera = UIImagePickerController()
                            pickerAlbumOrCamera?.sourceType = UIImagePickerController.SourceType.camera
                            pickerAlbumOrCamera?.cameraFlashMode = UIImagePickerController.CameraFlashMode.off
                            
                            guard let _pickerAlbumOrCamera: UIImagePickerController = pickerAlbumOrCamera else { return }
                            
                            _pickerAlbumOrCamera.delegate = self
                            _pickerAlbumOrCamera.allowsEditing = true
                            _pickerAlbumOrCamera.cameraFlashMode = UIImagePickerController.CameraFlashMode.off
                            _pickerAlbumOrCamera.cameraDevice = UIImagePickerController.isCameraDeviceAvailable(UIImagePickerController.CameraDevice.front) ? UIImagePickerController.CameraDevice.front : UIImagePickerController.CameraDevice.rear
                            
                            self.present(_pickerAlbumOrCamera, animated: true, completion: nil)
                        }
                    })
                } else {
                    pickerAlbumOrCamera = UIImagePickerController()
                    pickerAlbumOrCamera?.sourceType = UIImagePickerController.SourceType.camera
                    pickerAlbumOrCamera?.cameraFlashMode = UIImagePickerController.CameraFlashMode.off
                    pickerAlbumOrCamera?.cameraDevice = UIImagePickerController.isCameraDeviceAvailable(UIImagePickerController.CameraDevice.front) ? UIImagePickerController.CameraDevice.front : UIImagePickerController.CameraDevice.rear
                }
            } else { return openAlbumOrCamera(isCamera: false) }
        } else {
            pickerAlbumOrCamera = UIImagePickerController()
            pickerAlbumOrCamera?.sourceType = UIImagePickerController.SourceType.photoLibrary
        }
        
        guard let _pickerAlbumOrCamera: UIImagePickerController = pickerAlbumOrCamera else { return }
        
        _pickerAlbumOrCamera.delegate = self
        _pickerAlbumOrCamera.allowsEditing = false
        
        present(_pickerAlbumOrCamera, animated: true, completion: nil)
    }
    
    func showOptionForCameraOrAlbum() {
        let vcAlert: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let altActTakePhoto: UIAlertAction = UIAlertAction(title: "Take Photo", style: UIAlertAction.Style.default) { (altAct) in
            self.openAlbumOrCamera(isCamera: true)
        }
        let altActChoosePhoto: UIAlertAction = UIAlertAction(title: "Choose Photo", style: UIAlertAction.Style.default) { (altAct) in
            self.openAlbumOrCamera(isCamera: true)
        }
        let altActCancel: UIAlertAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
        
        vcAlert.addAction(altActTakePhoto)
        vcAlert.addAction(altActChoosePhoto)
        vcAlert.addAction(altActCancel)
        
        present(vcAlert, animated: true, completion: nil)
    }
}

//MARK: -
extension VCContactEdit: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let _vcPresented: UIImagePickerController = presentedViewController as? UIImagePickerController else { return }
        
        guard let _imgOri: UIImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage,
              let _: URL = info[UIImagePickerController.InfoKey.imageURL] as? URL else {
            _vcPresented.dismiss(animated: true)
            
            return
        }
        
//        self.imgNew = _imgOri
        
        self.contact.strImage = "https://img.purch.com/w/660/aHR0cDovL3d3dy5saXZlc2NpZW5jZS5jb20vaW1hZ2VzL2kvMDAwLzEwNC84MzAvb3JpZ2luYWwvc2h1dHRlcnN0b2NrXzExMTA1NzIxNTkuanBn"
        
        self.vContactEdit.setUiAfterGetImage(image: _imgOri)
        _vcPresented.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        guard let _vcPresented: UIImagePickerController = presentedViewController as? UIImagePickerController else { return }

        _vcPresented.dismiss(animated: true)
    }
}
