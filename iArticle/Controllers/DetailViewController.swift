//
//  DetailViewController.swift
//  iArticle
//
//  Created by Mavin Sao on 30/9/21.
//

import UIKit
import Kingfisher

class DetailViewController: UIViewController {
    
    @IBOutlet weak var articleImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var article: ArticleModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNavbar()
        prepareData()
    }
    
    func prepareData(){
        
        self.titleLabel.text       = article?.title
        self.descriptionLabel.text = article?.description
        self.authorName.text       = article?.authorName
        self.dateTimeLabel.text    = article?.updatedAt
        
        if article?.image != ""{
            let url = try! article?.image.asURL()
            
            self.articleImage.kf.setImage(with: url, placeholder: UIImage(named:"default"), options: [.transition(ImageTransition.fade(1))])
        }else{
            self.articleImage.image = UIImage(named:"default")
        }
        
       
    }
    
    func prepareNavbar(){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
}
