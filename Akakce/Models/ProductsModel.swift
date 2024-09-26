//
//  ProductsModel.swift
//  Akakce
//
//  Created by Sercan Deniz on 24.09.2024.
//

import Foundation

struct ProductsModel: Codable {
    let id: Int
    let title: String
    let price: Double
    let description: String
    let category: String
    let image: String
    let rating: Rating
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(Int.self, forKey: .id)!
        title = try container.decodeIfPresent(String.self, forKey: .title)!
        price = try container.decodeIfPresent(Double.self, forKey: .price)!
        description = try container.decodeIfPresent(String.self, forKey: .description)!
        category = try container.decodeIfPresent(String.self, forKey: .category)!
        image = try container.decodeIfPresent(String.self, forKey: .image)!
        rating = try container.decode(Rating.self, forKey: .rating)
    }
    
    init(id: Int, title: String, price: Double, description: String, category: String, image: String, rating: Rating) {
        self.id = id
        self.title = title
        self.price = price
        self.description = description
        self.category = category
        self.image = image
        self.rating = rating
    }
}

struct Rating: Codable {
    let rate: Double
    let count: Int
    
    enum CodingKeys: String, CodingKey {
        case rate, count
    }
}
