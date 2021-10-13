//
//  ArticleError.swift
//  iArticle
//
//  Created by Mavin Sao on 30/9/21.
//

import Foundation


enum ImageError: Error{
    case NoResponse
    
    var description: String{
        switch self {
        case .NoResponse:
            return "No Response"
        }
    }
}

enum ArticleError: Error{
    case NoResponse
    case BadRequest
    
    var description: String{
        switch self {
        case .NoResponse:
            return "No Response"
        case .BadRequest:
            return "Bad Request"
        }
    }
        
}
