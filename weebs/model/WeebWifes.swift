//
//  WeebWifes.swift
//  weebs
//
//  Created by Arfino Alam on 23/02/24.
//

import Foundation

struct WeebWifes: Identifiable, Decodable {
    var id = UUID()
    let image: String
    let anime: String
    let name: String
    
    enum CodingKeys: String, CodingKey {
            case image, anime, name
        }
}
