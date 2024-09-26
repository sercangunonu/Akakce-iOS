//
//  AkakceProductListViewModelTests.swift
//  AkakceTests
//
//  Created by Sercan Deniz on 26.09.2024.
//

import Foundation
import XCTest
import Alamofire
@testable import Akakce

final class AkakceProductListViewModelTests: XCTestCase {
    
    var viewModel: AkakceProductListViewModel!
    var mockNetworkManager: MockNetworkManager!
    var mockDelegate: MockAkakceProductListViewModelDelegate!
    
    override func setUp() {
        super.setUp()
        mockNetworkManager = MockNetworkManager()
        mockDelegate = MockAkakceProductListViewModelDelegate()
        viewModel = AkakceProductListViewModel()
        viewModel.delegate = mockDelegate
        viewModel.networkManager = mockNetworkManager
    }
    
    override func tearDown() {
        viewModel = nil
        mockNetworkManager = nil
        mockDelegate = nil
        super.tearDown()
    }
    
    func testFetchProductsSuccess() {
        let mockProducts = [ProductsModel(id: 1, title: "Product", price: 100, description: "Description", category: "Category", image: "image", rating: Rating(rate: 4.5, count: 1))]
        mockNetworkManager.mockResponse = .success(mockProducts)

        let expectation = XCTestExpectation(description: "Fetch products")

        viewModel.fetchProducts()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertTrue(self.mockDelegate.didCallDidFetchProducts)
            XCTAssertEqual(self.viewModel.products[0].id, mockProducts[0].id)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 2.0)
    }

    func testFetchHorizontalProductsSuccess() {
        let mockHorizontalProducts = [ProductsModel(id: 2, title: "Product", price: 200, description: "Description", category: "Category", image: "image", rating: Rating(rate: 5, count: 2))]
        mockNetworkManager.mockResponse = .success(mockHorizontalProducts)
        
        let expectation = XCTestExpectation(description: "Fetch horizontalProducts")
        viewModel.fetchHorizontalProducts("5")

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertTrue(self.mockDelegate.didCallDidFetchHorizontalProducts)
            XCTAssertEqual(self.viewModel.horizontalProducts[1].id, mockHorizontalProducts[0].id)

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 2.0)
    }
}

class MockNetworkManager: NetworkManager {
    var mockResponse: Result<[ProductsModel], Error>?
    
    func request<T>(type: T.Type, url: String, method: Alamofire.HTTPMethod, parameters: [String : Any]?, completion: @escaping (Result<T, Error>) -> Void) where T : Decodable {
        if let mockResponse = mockResponse as? Result<T, Error> {
            completion(mockResponse)
        }
    }
}

class MockAkakceProductListViewModelDelegate: AkakceProductListViewModelDelegate {
    var didCallDidFetchProducts = false
    var didCallDidFetchHorizontalProducts = false
    var didCallErrorFetchProductList = false
    var didCallIndicator = false
    
    func didFetchProducts() {
        didCallDidFetchProducts = true
    }
    
    func didFetchHorizontalProducts() {
        didCallDidFetchHorizontalProducts = true
    }
    
    func errorFetchProductList(error: Error?, message: String?) {
        didCallErrorFetchProductList = true
    }
    
    func callIndicator() {
        didCallIndicator = true
    }
}
