//
//  AkakceProductListViewModel.swift
//  Akakce
//
//  Created by Sercan Deniz on 24.09.2024.
//

import Foundation

protocol AkakceProductListViewModelDelegate: AnyObject {
    func didFetchProducts()
    func didFetchHorizontalProducts()
    func errorFetchProductList(error: Error?, message: String?)
    func callIndicator()
}

final class AkakceProductListViewModel: AkakceBaseViewModel {
    weak var delegate: AkakceProductListViewModelDelegate?
    
    private let queue = DispatchQueue(label: "com.Akakce.fetchQueue", qos: .background)
    var networkManager = NetworkManager()
    var products: [ProductsModel] = []
    var horizontalProducts: [ProductsModel] = []
    
    func fetchProducts() {
        self.queue.async {
            self.delegate?.callIndicator()
            self.networkManager.request(type: [ProductsModel].self, url: Constants.baseURL, method: .get, parameters: nil) { [weak self] response in
                switch response {
                case .success(let products):
                    self?.products = products
                    self?.delegate?.didFetchProducts()
                case .failure(let error):
                    self?.delegate?.errorFetchProductList(error: error, message: nil)
                }
            }
        }
    }
    
    func fetchHorizontalProducts(_ limit: String) {
        self.queue.async {
            self.delegate?.callIndicator()
            self.networkManager.request(type: [ProductsModel].self, url: Constants.baseURL + "?limit=" + limit, method: .get, parameters: nil) { [weak self] response in
                switch response {
                case .success(let horizontalProducts):
                    self?.horizontalProducts = horizontalProducts
                    self?.delegate?.didFetchHorizontalProducts()
                case .failure(let error):
                    self?.delegate?.errorFetchProductList(error: error, message: nil)
                }
            }
        }
    }
}
