//
//  AkakceProductCollectionCell.swift
//  Akakce
//
//  Created by Sercan Deniz on 25.09.2024.
//

import UIKit
import SDWebImage

final class AkakceProductCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    static let identifier = "productCell"
    
    func configure(imageURL: String, title: String, price: Double) {
        
        imageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        imageView.sd_setImage(with: URL(string: imageURL))
        
        setTitle(title: title)
        setPrice(price: price)
    }
    
    private func setTitle(title: String) {
        titleLabel.text = title
    }
    
    private func setPrice(price: Double) {
        let priceWithCurrency = price.addTurkishLiraCurrency()
        priceLabel.attributedText = priceWithCurrency?.toPrice(beforeDotFontSize: 17, afterDotFontSize: 11)
    }
}
