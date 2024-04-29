//
//  String+Extension.swift
//  VitalSurge
//
//  Created by Shehzad Rehmat on 15/02/2024.
//

import Foundation


extension String {
    
    var replyDate: String {
        let date = ISO8601DateFormatter().date(from: self)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM"
        
        return formatter.string(from: date ?? Date())
    }
    
}
