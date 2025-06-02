//
//  Comic.swift
//  XKCDViewer
//
//  Created by Kiarash Asar on 6/2/25.
//

import Foundation

struct Comic: Codable, Identifiable {
    let id: Int
    let title: String
    let img: String
    let alt: String
    let month: String
    let day: String
    let year: String
    let safeTitle: String
    let transcript: String
    let news: String
    let link: String
    
    private enum CodingKeys: String, CodingKey {
        case id = "num"
        case title
        case img
        case alt
        case month
        case day
        case year
        case safeTitle = "safe_title"
        case transcript
        case news
        case link
    }
}

// MARK: - Computed Properties

extension Comic {
    /// Date from month, day, and year
    var date: Date? {
        guard let monthNum = Int(month),
              let dayNum = Int(day),
              let yearNum = Int(year) else {
            return nil
        }
        
        var components = DateComponents()
        components.month = monthNum
        components.day = dayNum
        components.year = yearNum
        
        guard let date = Calendar.current.date(from: components) else {
            return nil
        }
        
        return date
    }
}
