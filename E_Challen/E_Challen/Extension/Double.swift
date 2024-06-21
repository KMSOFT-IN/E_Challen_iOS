//
//  Double.swift
//  Doctor_iOS
//
//  Created by KMSOFT on 14/10/23.
//

import Foundation

extension Double {
    func getDateTimeString() -> (dateString: String, timeString: String, dateTimeString: String, monthDateString: String) {
        let date = Date(timeIntervalSince1970: self)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let dateString = dateFormatter.string(from: date)
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        let timeString = timeFormatter.string(from: date)
        
        let dateTimeFormatter = DateFormatter()
        dateTimeFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        let dateTimeString = dateTimeFormatter.string(from: date)
        
        let mDateFormatter = DateFormatter()
        mDateFormatter.dateFormat = "MMMM dd, yyyy"
        let monthDateString = mDateFormatter.string(from: date)
        
        return (dateString, timeString, dateTimeString, monthDateString)
    }
}
