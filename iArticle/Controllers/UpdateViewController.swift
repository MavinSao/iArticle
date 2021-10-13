//
//  UpdateViewController.swift
//  iArticle
//
//  Created by Mavin on 13/10/21.
//

import UIKit
import ProgressHUD
import Kingfisher

class UpdateViewController: UIViewController {
    
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var articleUpdate: ArticleModel?
    var imageData: Data?

    var imagePickerView = UIImagePickerController()
    
    let pickerAlert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
    
    @IBOutlet weak var titleTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentAlert))
        self.articleImageView.isUserInteractionEnabled = true
        self.articleImageView.addGestureRecognizer(tapGesture)
        
        self.imagePickerView.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
       view.addGestureRecognizer(tap)
        
      
        
        //Alert Action
        prepareAlertActionImage()
        prepareView()
        
    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func prepareView(){
        
        if articleUpdate?.image != ""{
            let url = try! articleUpdate?.image.asURL()
            
            self.articleImageView.kf.setImage(with: url, placeholder: UIImage(named:"default"), options: [.transition(ImageTransition.fade(1))])
        }else{
            self.articleImageView.image = UIImage(named:"default")
        }
        
        self.titleTextView.text = articleUpdate?.title
        self.descriptionTextView.text = articleUpdate?.description
        
        
        self.articleImageView.layer.cornerRadius = 10
        self.titleTextView.layer.cornerRadius = 10
        self.descriptionTextView.layer.cornerRadius = 10
    }
    
    @objc func presentAlert(){
        present(pickerAlert, animated: true, completion: nil)
    }
    
    func prepareAlertActionImage(){
        let cameraAction = UIAlertAction(title: "Camera", style: .default){ UIAlertAction in self.chooseImage(with: .camera) }
        let galleryAction = UIAlertAction(title: "Gallery", style: .default){ UIAlertAction in  self.chooseImage(with: .photoLibrary)}
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
    
        self.pickerAlert.addAction(cameraAction)
        self.pickerAlert.addAction(galleryAction)
        self.pickerAlert.addAction(cancelAction)
    }

    func chooseImage(with option: UIImagePickerController.SourceType) {
        
        
        imagePickerView.allowsEditing = true
        imagePickerView.mediaTypes = ["public.image"]
        imagePickerView.sourceType = option
        
        if #available(iOS 15.0, *) {
            imagePickerView.sheetPresentationController?.detents=[
                            .medium(),
                            .large()
            ]
        }
        
        present(imagePickerView, animated: true, completion: nil)
    }
    
    @IBAction func bthSavePress(_ sender: Any) {
        let title       = titleTextView.text
        let description = descriptionTextView.text
        let articleId   = articleUpdate!.id
        
        if title != "" && description != ""{
            
            //If Image has been choose
            if let safeImageData = imageData {
                ArticleService.shared.uploadImage(imageData: safeImageData) { result in
                    switch result {
                        case .success(let url):
                            print("Update IMAGE URL: \(url)")
                                
                        ArticleService.shared.updateArticle(articleId: articleId, title: title!, description: description!, imageURL: url) { msg in
                            ProgressHUD.showSucceed(msg)
                        }
                        self.imageData = nil
                        case .failure(let error):
                            print(error.localizedDescription)
                            ProgressHUD.showError("Error")
                    }
                }
            }else{
                ArticleService.shared.updateArticle(articleId: articleId, title: title!, description: description!, imageURL: nil) { msg in
                    print(msg)
                    ProgressHUD.showSucceed(msg)
                }
            }
        }else{
            ProgressHUD.showError("Please Fill the Title and Description")
        }
    }
    
}

extension UpdateViewController: UINavigationControllerDelegate,UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let possibleImage = info[.editedImage] as? UIImage {
            self.articleImageView.image = possibleImage
            self.imageData = possibleImage.jpegData(compressionQuality: 1.0)
        }
        dismiss(animated: true)
    }
}
