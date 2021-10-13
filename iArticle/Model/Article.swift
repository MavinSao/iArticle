//
//  ArticleModel.swift
//  iArticle
//
//  Created by Mavin Sao on 30/9/21.
//

import Foundation


struct Response: Decodable {
    var data: [Article]
    var message: String
}

struct Article: Decodable{
    var id           : String
    var title        : String
    var description  : String
    var image        : String
//    var published    : Bool
    var updatedAt    : String
    
    enum CodingKeys: String, CodingKey {
        case id    = "_id"
        case title
        case description
        case image
//        case published
        case updatedAt
    }
    
}
