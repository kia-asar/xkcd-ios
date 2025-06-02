//
//  Date+DisplayFormatting.swift
//  XKCDViewer
//
//  Created by Kiarash Asar on 6/2/25.
//

import Foundation

extension Date {
    var displayFormattedDate: String {
        DateFormatter.displayFormatter.string(from: self)
    }
}

extension DateFormatter {
    static var displayFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"
        return dateFormatter
    }
}
