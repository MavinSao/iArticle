//
//  ArticleError.swift
//  iArticle
//
//  Created by Mavin Sao on 30/9/21.
//

import Foundation

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
