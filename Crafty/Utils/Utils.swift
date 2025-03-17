//
//
// Created for Crafty iOS by hbq2dev
// Utils.swift
//
//  Copyright © 2025 hbq2dev.
//

import Foundation

extension String {
    func getDate() -> Date? {
        let dateFormatter = DateFormatter()
        /// "2025-01-16T11:16:24.968066"
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        let date = dateFormatter.date(from: self)

        return date
    }

    func formattedTime() -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter.string(from: getDate() ?? Date())
    }
}

func formattedDate() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
    return dateFormatter.string(from: Date())
}
