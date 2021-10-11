//
//  ArticleService.swift
//  iArticle
//
//  Created by Mavin Sao on 30/9/21.
//

import Foundation
import Alamofire

struct ArticleService {
    
    static let shared = ArticleService()
    private let baseURL = "http://110.74.194.124:3034/api/"
    
    func fetchArticle(page: Int,size: Int,completion: @escaping(Result<[ArticleModel],Error>)->Void){
    
        let url = try! "\(baseURL)articles?page=\(page)&size=\(size)".asURL()
        AF.request(url).responseDecodable(of: Response.self) { response in
            guard let resoponseArticle = response.value else {
                completion(.failure(ArticleError.NoResponse))
                return
            }
            let articles: [ArticleModel] = resoponseArticle.data.compactMap(ArticleModel.init)
            completion(.success(articles))
        }
    }
    
    func postArticle(){
        
    }
    
    func deleteArticle(){
        
    }
    
    func updateArticle(){
        
    }
    
    func uploadImage(){
        
    }
    
}
