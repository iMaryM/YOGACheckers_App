//
//  Date+Format.swift
//  HomeWork_Lesson_13
//
//  Created by Мария Манжос on 3.09.21.
//

import UIKit

extension Date {
    func getCurrentDate(from dateFormat: String, locale: Locale = Locale.current, timeZone: TimeZone = TimeZone.current) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.locale = locale
        dateFormatter.timeZone = timeZone
        return dateFormatter.string(from: self)
    }
}
