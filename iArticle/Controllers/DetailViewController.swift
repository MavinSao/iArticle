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
        
        let url = try! article?.image.asURL()
        self.articleImage.kf.setImage(with: url, placeholder: UIImage(named:"test"), options: [.transition(ImageTransition.fade(1))])
    }
    
    func prepareNavbar(){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
//
//        let backTap = UITapGestureRecognizer(target: self, action: #selector(backToMain))
//
//        let back = UIButton()
//        back.addGestureRecognizer(backTap)
//        back.setImage(#imageLiteral(resourceName: "back"), for: .normal)
//        back.clipsToBounds = true
//
//
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: back)
    }
//    @objc func backToMain() {
//        self.navigationController?.popViewController(animated: true)
//    }

}
