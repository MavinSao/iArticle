//
//  ImageResponse.swift
//  iArticle
//
//  Created by Mavin Sao on 11/10/21.
//

import Foundation

struct MessageResponse: Decodable {
    let message: String
}

struct ImgResponse: Codable {
    let url: String
}
