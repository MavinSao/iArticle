//
//  ArticleTableViewCell.swift
//  iArticle
//
//  Created by Mavin Sao on 29/9/21.
//

import UIKit
import Kingfisher

class ArticleTableViewCell: UITableViewCell {

    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    
    func config(article: ArticleModel){
        
        self.titleLabel.text       = article.title
        self.descriptionLabel.text = article.description
        
        if article.image != ""{
            let url = try! article.image.asURL()
            
            self.articleImageView.kf.setImage(with: url, placeholder: UIImage(named:"default"), options: [.transition(ImageTransition.fade(1))])
        }else{
            self.articleImageView.image = UIImage(named:"default")
        }
        self.articleImageView.layer.cornerRadius = 10
        
        self.authorName.text      = article.authorName
        self.dateTimeLabel.text   = article.updatedAt
    }

}
