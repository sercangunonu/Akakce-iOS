//
//  NetworkManager.swift
//  Akakce
//
//  Created by Sercan Deniz on 24.09.2024.
//

import Foundation
import Alamofire

enum DataError: Error {
    case badURL
    case invalidData
    case decodingError
    case APIError(String)
    case tooManyRequests(String)
}

enum NetworkStatus {
    case success
    case noConnection
    case unknown
}

protocol NetworkManagerProtocol {
    func request<T: Codable>(type: T.Type, url: String, method: Alamofire.HTTPMethod, parameters: [String: Any]?, completion: @escaping (Result<T, DataError>) -> Void)
}

public class NetworkManager: NetworkManagerProtocol {
    
    static let shared = NetworkManager()
    let manager = Alamofire.NetworkReachabilityManager()
    
    // Monitoring network connection
    func networkConnectionObserver() {
        manager?.startListening { status in
            switch status {
            case .notReachable :
                print("not reachable")
            case .reachable(.cellular) :
                print("cellular")
            case .reachable(.ethernetOrWiFi) :
                print("ethernetOrWiFi")
            default :
                print("unknown")
            }
        }
    }
    
    // Control internet connection
    // - Returns: Status for network.
    func isConnectedToInternet() -> NetworkStatus {
        guard let manager = manager else { return .unknown }
        let networkStatus: NetworkStatus = manager.isReachable ? .success : .noConnection
        return networkStatus
    }
    
    // Used to Alamofire because of it's simplier than URL session and it provides monitoring network, asynchronous API calls
    // Request network call by using Alamofire
    // - Parameters:
    //   - type: Model type for decoding
    //   - url: Url
    //   - method: HttpMethods(ex: Get, Post, Delete ...)
    //   - parameters: ApiKey, Language, Video etc. Which need for better/required API calls
    //   - completion: Handle API Response
    func request<T: Codable>(type: T.Type, url: String, method: Alamofire.HTTPMethod, parameters: [String: Any]?, completion: @escaping (Result<T, DataError>) -> Void) {
        AF.request(url, method: method, parameters: parameters).response { response in
            let result = response.result
            switch result {
            case .success(let data):
                guard let data = data else {
                    completion(.failure(.invalidData))
                    return
                }
                
                guard let object = try? JSONDecoder().decode(T.self, from: data) else {
                    completion(.failure(.decodingError))
                    return
                }
                completion(.success(object))
                
            case .failure(let error):
                if let statusCode = response.response?.statusCode, statusCode == 429 {
                    completion(.failure(.tooManyRequests(error.localizedDescription)))
                } else {
                    completion(.failure(.APIError(error.localizedDescription)))
                }
            }
        }
    }
}

