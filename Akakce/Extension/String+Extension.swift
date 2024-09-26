//
//  String+Extension.swift
//  Akakce
//
//  Created by Sercan Deniz on 26.09.2024.
//

import Foundation
import UIKit

extension String {
    
    public func toPrice(beforeDotFontSize: CGFloat, afterDotFontSize: CGFloat) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        
        if let dotRange = self.range(of: ".") {
            let beforeDotRange = NSRange(self.startIndex..<dotRange.lowerBound, in: self)
            attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: beforeDotFontSize, weight: .bold), range: beforeDotRange)
            
            let afterDotRange = NSRange(dotRange.upperBound..<self.endIndex, in: self)
            attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: afterDotFontSize, weight: .regular), range: afterDotRange)
        }
        return attributedString
    }
}
