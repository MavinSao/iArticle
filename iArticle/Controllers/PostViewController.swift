//
//  PostViewController.swift
//  iArticle
//
//  Created by Mavin Sao on 1/10/21.
//

import UIKit
import ProgressHUD

class PostViewController: UIViewController {

    @IBOutlet weak var articleImageView   : UIImageView!
    @IBOutlet weak var articleTextView    : UITextView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var btnPost            : UIButton!
    
    var isChooseImage = false
    var imageData: Data?
    
    var isUpdate:Bool = false
    
    
    var imagePickerView = UIImagePickerController()

    let pickerAlert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        //DismissKeyboard
        
        
        config()
        //Alert Action
        prepareAlertActionImage()
        prepareView()
    }
    
    func config(){
        let tapGesture = UITapGestureRecognizer(target: self, action:                #selector(presentAlert))
        self.articleImageView.isUserInteractionEnabled = true
        self.articleImageView.addGestureRecognizer(tapGesture)
        self.imagePickerView.delegate = self
        
        //Looks for single or multiple taps.
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))


        self.view.addGestureRecognizer(tap)
    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    func prepareView(){
        self.articleImageView.layer.cornerRadius = 10
        self.articleTextView.layer.cornerRadius = 10
        self.descriptionTextView.layer.cornerRadius = 10
        self.btnPost.layer.cornerRadius = 10
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
    
    @IBAction func postButtonPressed(_ sender: Any) {
        let title       = articleTextView.text
        let description = descriptionTextView.text
        
        if title != "" && description != ""{
            if let safeImageData = imageData {
                ArticleService.shared.uploadImage(imageData: safeImageData) { result in
                    switch result {
                        case .success(let url):
                            print("IMAGE URL: \(url)")
                            ArticleService.shared.postArticle(title: title!, description: description!, imageURL: url)
                            self.imageData = nil
                        case .failure(let error):
                            print(error.localizedDescription)
                            ProgressHUD.showError("Error")
                    }
                }
            }else{
                ArticleService.shared.postArticle(title: title!, description: description!, imageURL: nil)
            }
        }else{
            ProgressHUD.showError("Please Fill the Title and Description")
        }
    }
}

extension PostViewController: UINavigationControllerDelegate,UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let possibleImage = info[.editedImage] as? UIImage {
            isChooseImage = true
            self.articleImageView.image = possibleImage
            self.imageData = possibleImage.jpegData(compressionQuality: 1.0)
        }
        dismiss(animated: true)
    }
}

