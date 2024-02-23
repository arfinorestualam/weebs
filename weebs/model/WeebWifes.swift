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
    
    init(image: String, anime: String, name: String) {
        self.image = image
        self.anime = anime
        self.name = name
    }
}
