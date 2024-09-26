//
//  AkakceProductDetailViewModelTests.swift
//  AkakceTests
//
//  Created by Sercan Deniz on 26.09.2024.
//

import XCTest
import Alamofire
@testable import Akakce
final class AkakceProductDetailViewModelTests: XCTestCase {
    
    var viewModel: AkakceProductDetailViewModel!
    var mockNetworkManager: MockDetailNetworkManager!
    var mockDelegate: MockAkakceProductDetailViewModelDelegate!
    
    override func setUp() {
        super.setUp()
        mockNetworkManager = MockDetailNetworkManager()
        mockDelegate = MockAkakceProductDetailViewModelDelegate()
        viewModel = AkakceProductDetailViewModel()
        viewModel.delegate = mockDelegate
        viewModel.networkManager = mockNetworkManager
    }
    
    func testFetchDetailSuccess() {
         let mockProduct = ProductsModel(id: 1, title: "Test Product", price: 100, description: "Description", category: "Category", image: "image", rating: Rating(rate: 4.5, count: 10))
         mockNetworkManager.mockResponse = .success(mockProduct)

         let expectation = XCTestExpectation(description: "Fetch product details successfully")

         viewModel.fetchDetail(id: 1)

         DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
             XCTAssertTrue(self.mockDelegate.didCallCallIndicator)
             XCTAssertTrue(self.mockDelegate.didCallDidFetchDetail)
             XCTAssertEqual(self.viewModel.productDetail?.id, mockProduct.id)
             expectation.fulfill()
         }

         wait(for: [expectation], timeout: 2.0)
     }
}

class MockAkakceProductDetailViewModelDelegate: AkakceProductDetailViewModelDelegate {
    var didCallCallIndicator = false
    var didCallDidFetchDetail = false
    var didCallErrorFetchProductList = false
    
    func callIndicator() {
        didCallCallIndicator = true
    }
    
    func didFetchDetail() {
        didCallDidFetchDetail = true
    }
    
    func errorFetchProductList(error: Error?, message: String?) {
        didCallErrorFetchProductList = true
    }
}

class MockDetailNetworkManager: NetworkManager {
    var mockResponse: Result<ProductsModel, Error>?
    
    func request<T>(type: T.Type, url: String, method: Alamofire.HTTPMethod, parameters: [String: Any]?, completion: @escaping (Result<T, Error>) -> Void) where T : Decodable {
        if let mockResponse = mockResponse as? Result<T, Error> {
            completion(mockResponse)
        }
    }
}
