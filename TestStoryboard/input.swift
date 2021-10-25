//
//  input.swift
//  TestStoryboard
//
//  Created by Sepuh Hovhannisyan on 01.09.21.
//

import Foundation
import UIKit
import CoreData


func saveImage(image: UIImage?, name: String) {
    let imageData = image?.jpegData(compressionQuality: 1.0)
    let asset_path = projectPath + "Assets.xcassets/\(name).jpg"
    let fileManager = FileManager.default
    
    fileManager.createFile(atPath: asset_path, contents: imageData, attributes: nil)
}


func removeImage(path: String) {
    do {
        try FileManager.default.removeItem(at: URL(fileURLWithPath: path))
    } catch _ { }
}


class inputViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var inputIsoCode: UITextField!
    @IBOutlet weak var inputCountryName: UITextField!
    @IBOutlet weak var notification: UILabel!
    @IBOutlet weak var notCloseButton: UIButton!
    @IBOutlet weak var chooseImageButton: UIButton!
    @IBOutlet weak var CameraImageButton: UIButton!
    @IBOutlet weak var GalleryImageButton: UIButton!
    var imageView: UIImageView = UIImageView(image: UIImage(named: "at"))
    var imagePicker = UIImagePickerController()
    var alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
    
    @IBAction func tappedButton(sender: AnyObject) {
        if inputIsoCode.text != Optional("") && inputCountryName.text != Optional("") {
            let isoCode: String = inputIsoCode.text!
            let countryName: String = inputCountryName.text!
            for country in countries {
                if country.isoCode == isoCode {
                    notification.textAlignment = NSTextAlignment.center
                    notification.isHidden = false
                    notCloseButton.isHidden = false
                    return
                }
            }
            
            let imageName = getNewImageName()
            
            let newCountry = Country(isoCode: isoCode, name: countryName, imageName: imageName)
//            db.insert_element(countryIndex: Int32(countries.count), countryIsoCode: isoCode, countryName: countryName, imageName: imageName)
            saveImage(image: imageView.image, name: imageName)
            
            countries.append(newCountry)
            
            addElementCoreData(id: Int32(countries.count - 1), isoCode: isoCode, name: countryName, imageName: imageName)
        }

        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let nextView = storyBoard.instantiateViewController(identifier: "1") as! CountriesTableViewController
        self.present(nextView, animated: true, completion: nil)
    }
    
    func chooseGalleryImage() {
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = false
        imagePicker.delegate = self
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func takeCameraImage() {
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func chooseImageButtonClicked(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) && UIImagePickerController.isSourceTypeAvailable(.camera) {
            CameraImageButton.isHidden = false
            GalleryImageButton.isHidden = false
            chooseImageButton.isHidden = true
        }
        else if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            chooseGalleryImage()
        }
        else if UIImagePickerController.isSourceTypeAvailable(.camera) {
            takeCameraImage()
        }
    }
    @IBAction func CameraButtonClick(_ sender: Any) {
        takeCameraImage()
    }
    @IBAction func GalleryButtonClick(_ sender: Any) {
        chooseGalleryImage()
    }
    
    @IBAction func closeNot(_ sender: Any) {
        notification.isHidden = true
        notCloseButton.isHidden = true
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.contentMode = .scaleAspectFit
            imageView.image = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion:nil)
    }
}
