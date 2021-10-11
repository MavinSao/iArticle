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
        
        let url = try! article.image.asURL()
        
        self.articleImageView.kf.setImage(with: url, placeholder: UIImage(named:"test"), options: [.transition(ImageTransition.fade(1))])
        
        self.articleImageView.layer.cornerRadius = 10
        
        self.authorName.text      = article.authorName
        self.dateTimeLabel.text   = article.updatedAt
    }

}
