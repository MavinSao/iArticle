//
//  ArticleService.swift
//  iArticle
//
//  Created by Mavin Sao on 30/9/21.
//

import Foundation
import Alamofire
import ProgressHUD

struct ArticleService {
    
    static let shared = ArticleService()
    private let baseURL = "http://110.74.194.124:3034/api/"
    
    func fetchArticle(page: Int,size: Int,completion: @escaping(Result<[ArticleModel],Error>)->Void){
        
        print("Fetch")
    
        let url = try! "\(baseURL)articles?page=\(page)&size=\(size)".asURL()
        AF.request(url).responseDecodable(of: Response.self) { response in
            guard let resoponseArticle = response.value else {
                print("error")
                completion(.failure(ArticleError.NoResponse))
                return
            }
            
            print("message: ",resoponseArticle.message)
            
            let articles: [ArticleModel] = resoponseArticle.data.compactMap(ArticleModel.init)
            completion(.success(articles))
        }
        
     
    }
    
    func postArticle(title: String, description: String, imageURL: String?){
        var article: [String:Any] = [
            "title"         : title,
            "description"   : description,
            "image"   : ""
        ]
        if let safeImageUrl = imageURL{
            article["image"] = safeImageUrl
        }
       
        AF.request("\(baseURL)articles",method: .post,parameters: article, encoding: JSONEncoding.default).responseDecodable(of: MessageResponse.self) { response in
            
            guard let response = response.value else {
                ProgressHUD.showError("No Response")
                return
            }
            ProgressHUD.showSuccess(response.message)
            
        }
        
    }
    
    func deleteArticle(articleId: String,completion: @escaping (String)->Void){
        AF.request("\(baseURL)articles/\(articleId)", method: .delete, parameters: nil,  headers: nil).responseDecodable(of: MessageResponse.self) { response in
            
            guard let responseValue = response.value else{
                completion("Fail to delete")
                return
            }
            completion(responseValue.message)
        }
    }
    
    func archieveArticle(articleId:String,completion: @escaping (String)->Void){
        
        let parameters: [String:Any] = [
            "published": false
        ]
        
        AF.request("\(baseURL)articles/\(articleId)", method: .patch, parameters: parameters,encoding: JSONEncoding.default,  headers: nil).responseDecodable(of: MessageResponse.self) { response in
            
            guard let responseValue = response.value else{
                completion("Fail to Archive")
                return
            }
            completion(responseValue.message)
        }
    }
    
    func updateArticle(articleId: String, title: String, description: String, imageURL: String?, completion: @escaping(String)->Void){
        
        var article: [String:Any] = [
            "title"         : title,
            "description"   : description,
            "image"   : ""
        ]
        if let safeImageUrl = imageURL{
            article["image"] = safeImageUrl
        }
        
        AF.request("\(baseURL)articles/\(articleId)", method: .patch, parameters: article,encoding: JSONEncoding.default, headers: nil).responseDecodable(of: MessageResponse.self) { response in
            
            guard let responseValue = response.value else{
                completion("Fail to Archive")
                return
            }
            completion(responseValue.message)
        }
    }
    
    func uploadImage(imageData: Data, completion: @escaping (Result<String,Error>)->Void){
        
        AF.upload(multipartFormData: { multiform in
            multiform.append(imageData, withName: "image", fileName: ".jpg", mimeType: "image/jpeg")
        }, to: "\(baseURL)images")
        .responseDecodable(of: ImgResponse.self) { response in
            guard let response = response.value else{
                completion(.failure(ImageError.NoResponse))
                return
            }
            completion(.success(response.url))
        }
    }
    
}
