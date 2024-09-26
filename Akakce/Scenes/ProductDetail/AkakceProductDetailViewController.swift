//
//  AkakceProductDetailViewController.swift
//  Akakce
//
//  Created by Sercan Deniz on 24.09.2024.
//

import UIKit
import SDWebImage

final class AkakceProductDetailViewController: AkakceBaseViewController<AkakceProductDetailViewModel> {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var starRatingView: StarRatingView!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    private var id: Int?
    
    required init(id: Int) {
        super.init()
        self.id = id
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchDetail(id: id ?? 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        
    }

    private func setupUI() {
        guard let productDetail = viewModel.productDetail else { return }
        titleLabel.text = productDetail.title
        
        imageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        imageView.sd_setImage(with: URL(string: productDetail.image))
        
        starRatingView.configureStarImages(rate: Int(productDetail.rating.rate.rounded()))
        
        let priceWithCurrency = productDetail.price.addTurkishLiraCurrency()
        priceLabel.attributedText = priceWithCurrency?.toPrice(beforeDotFontSize: 17, afterDotFontSize: 11)
        descriptionLabel.text = productDetail.description
    }
}

extension AkakceProductDetailViewController: AkakceProductDetailViewModelDelegate {
    func didFetchDetail() {
        hideIndicator()
        setupUI()
    }
    
    func callIndicator() {
        showIndicator()
    }
    
    func errorFetchProductList(error: Error?, message: String?) {
        hideIndicator()
        let action = [UIAlertAction(title: "Tamam", style: .destructive)]
        if let error = error {
            self.showAlert(title: "Hata", message: error.localizedDescription, style: .alert, actions: action)
        } else {
            self.showAlert(title: "Hata", message: message, style: .alert, actions: action)
        }
    }
}
