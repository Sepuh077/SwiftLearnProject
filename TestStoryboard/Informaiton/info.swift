//
//  info.swift
//  TestStoryboard
//
//  Created by Sepuh on 07.09.21.
//

import UIKit


internal final class countryInfoController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var countryImage: UIImageView!
    @IBOutlet weak var changeImageButton: UIButton!
    @IBOutlet weak var cameraImageButton: UIButton!
    @IBOutlet weak var galleryImageButton: UIButton!
    
    private var isoCode: String = "at"
    
    private var indexPath = IndexPath()
    
    var imageView: UIImageView?
    var imagePicker = UIImagePickerController()
    
    var homeView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "1") as! CountriesTableViewController
    
    func config(country: Country, indexPath: IndexPath) {
        self.name.text = country.name
        self.name.textAlignment = .center
        
        self.isoCode = country.isoCode
        self.indexPath = indexPath
        
        self.countryImage.image = UIImage(named: projectPath + "Assets.xcassets/\(country.imageName).jpg")
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.present(homeView, animated: true, completion: nil)
    }
    @IBAction func changeImage(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) && UIImagePickerController.isSourceTypeAvailable(.camera) {
            cameraImageButton.isHidden = false
            galleryImageButton.isHidden = false
            changeImageButton.isHidden = true
        }
        else if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            chooseGalleryImage()
        }
        else if UIImagePickerController.isSourceTypeAvailable(.camera) {
            takeCameraImage()
        }
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
    
    @IBAction func CameraButtonClick(_ sender: Any) {
        takeCameraImage()
    }
    @IBAction func GalleryButtonClick(_ sender: Any) {
        chooseGalleryImage()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            countryImage.contentMode = .scaleAspectFit
            countryImage.image = pickedImage
            removeImage(path: projectPath + "Assets.xcassets/\(countries[indexPath.row].imageName).jpg")
            let newImageName = getNewImageName()
            
            saveImage(image: pickedImage, name: newImageName)
            
            countries[indexPath.row].imageName = newImageName
//            db.update_row(isoCode: isoCode, id: Int32(indexPath.row), imageName: newImageName)
            updateElementInCoreData(isoCode: isoCode, newId: Int32(indexPath.row), newImageName: newImageName)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion:nil)
    }
}
