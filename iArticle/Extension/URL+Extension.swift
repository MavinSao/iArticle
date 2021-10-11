//
//  URL+Extension.swift
//  iArticle
//
//  Created by Mavin Sao on 30/9/21.
//

import Foundation

extension String{
    var asURL: URL? {
        return URL(string: self)
    }
    
    var toReadableDate: String? {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let date = dateFormat.date(from: self)
        return "\(date!.getStringFromDateFormat(format: "EEE")) . \(date!.getStringFromDateFormat(format: "hh:mm aa"))"
    }
}
