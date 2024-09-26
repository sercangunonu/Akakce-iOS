//
//  AkakceProductDetailViewModel.swift
//  Akakce
//
//  Created by Sercan Deniz on 24.09.2024.
//

import Foundation

protocol AkakceProductDetailViewModelDelegate: AnyObject {
    func callIndicator()
    func didFetchDetail()
    func errorFetchProductList(error: Error?, message: String?)
}

final class AkakceProductDetailViewModel: AkakceBaseViewModel {
    weak var delegate: AkakceProductDetailViewModelDelegate?
    
    var productDetail: ProductsModel?
    
    var networkManager = NetworkManager()
    
    func fetchDetail(id: Int) {
        let url = Constants.baseURL + "/" + String(id)
        self.delegate?.callIndicator()
        self.networkManager.request(type: ProductsModel.self, url: url, method: .get, parameters: nil) { [weak self] response in
            switch response {
            case .success(let product):
                self?.productDetail = product
                self?.delegate?.didFetchDetail()
            case .failure(let error):
                self?.delegate?.errorFetchProductList(error: error, message: nil)
            }
        }
    }
}
