//
//  PostViewController.swift
//  iArticle
//
//  Created by Mavin Sao on 1/10/21.
//

import UIKit

class PostViewController: UIViewController {

    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var articleTextView: UITextView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var btnPost: UIButton!
    
    lazy var imagePickerView = UIImagePickerController()

    let pickerAlert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentAlert))
        self.articleImageView.isUserInteractionEnabled = true
        self.articleImageView.addGestureRecognizer(tapGesture)
        
        self.imagePickerView.delegate = self
        
        //Alert Action
        prepareAlertActionImage()
        prepareView()
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
        present(imagePickerView, animated: true, completion: nil)
    }
    
    @IBAction func postButtonPressed(_ sender: Any) {
        
    }
}

extension PostViewController: UINavigationControllerDelegate,UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let possibleImage = info[.editedImage] as? UIImage {
            self.articleImageView.image = possibleImage
        }else{
            
        }
        dismiss(animated: true)
    }
}
