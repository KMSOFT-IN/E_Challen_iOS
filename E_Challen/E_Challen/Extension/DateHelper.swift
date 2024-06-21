//
//  DateHelper.swift
//  ExpenseManager
//
//  Created by Kmsoft on 30/03/24.
//

import Foundation

class DateHelper {
    static func stringFromDate(date: Date, format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
}
