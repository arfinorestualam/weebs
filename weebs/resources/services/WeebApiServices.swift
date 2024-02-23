//
//  WeebApiServices.swift
//  weebs
//
//  Created by Arfino Alam on 23/02/24.
//

import Foundation

class WeebApiSevice{
    static let shared = WeebApiSevice()
    
    func load() async throws -> [WeebWifes] {
        guard let url = URL (string: Constants.api) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let dataJson = try JSONDecoder().decode([WeebWifes].self, from: data)
        
        let wifes = dataJson.map { wife in
            WeebWifes(image: wife.image, anime: wife.anime, name: wife.name)
        }
        
        return wifes
    }
}
