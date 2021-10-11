//
//  Date+Extension.swift
//  iArticle
//
//  Created by Mavin Sao on 30/9/21.
//

import Foundation

extension Date {
    func getStringFromDateFormat(format: String)->String{
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = format
        return dateFormat.string(from: self)
    }
}
