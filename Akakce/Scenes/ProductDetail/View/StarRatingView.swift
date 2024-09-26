//
//  StarRatingView.swift
//  Akakce
//
//  Created by Sercan Deniz on 26.09.2024.
//

import UIKit

final class StarRatingView: UIView {
    
    private var starImageViews: [UIImageView] = []
    private let totalStars = 5
    
    func configureStarImages(rate: Int) {
        setupStarRatingView()
        for i in 0..<totalStars {
            if i < rate {
                starImageViews[i].image = IconSet.filledStarIcon
            } else {
                starImageViews[i].image = IconSet.emptyStarIcon
            }
        }
    }
    
    private func setupStarRatingView() {
        let starSize: CGFloat = 20
        let spacing: CGFloat = 10
        let totalWidth = (CGFloat(totalStars) * starSize) + (CGFloat(totalStars - 1) * spacing)
        let startX = (frame.size.width - totalWidth) / 2
        
        for i in 0..<totalStars {
            let starImageView = UIImageView()
            starImageView.frame = CGRect(x: startX + CGFloat(i) * (starSize + spacing), y: 0, width: starSize, height: starSize)
            starImageView.image = IconSet.emptyStarIcon
            addSubview(starImageView)
            starImageViews.append(starImageView)
        }
    }
}
