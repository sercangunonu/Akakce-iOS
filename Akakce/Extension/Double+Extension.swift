//
//  Double+Extension.swift
//  Akakce
//
//  Created by Sercan Deniz on 26.09.2024.
//

import Foundation

extension Double {
    
    public func addTurkishLiraCurrency() -> String? {
        return String(self) + " TL"
    }
}
