//
//  ArticleModel.swift
//  iArticle
//
//  Created by Mavin Sao on 30/9/21.
//

import Foundation

struct ArticleModel {
    var id            : String
    var title         : String
    var description   : String
    var image         : String
//    var published     : Bool
    var authorName    : String
    var updatedAt     : String
    
    init(article: Article) {
        self.id          = article.id
        self.title       = article.title
        self.description = article.description
        self.image       = article.image
//        self.published   = article.published
        self.authorName  = "By Mavin"
        self.updatedAt    = article.updatedAt.toReadableDate ?? "Not Readable"
    }
    
}
