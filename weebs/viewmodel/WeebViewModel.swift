//
//  WeebViewModel.swift
//  weebs
//
//  Created by Arfino Alam on 23/02/24.
//

import SwiftUI

@MainActor
class WeebViewModel: ObservableObject {
    @Published var wife: [WeebWifes] = []
    @Published var shareImage: UIImage?
    @Published var showOption: Bool = false
    
    func fetch() async {
        do {
            let fetchWife = try await WeebApiSevice.shared.load()
            self.wife = fetchWife
        } catch {
            print(error)
        }
    }
    
    func showSheet(from urlString: String) async {
        shareImage = await downloadImage(from: urlString)
        showOption = true
    }
    
    func downloadImage(from urlString: String) async -> UIImage? {
        guard let url = URL(string: urlString) else { return nil }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return UIImage(data: data)
        } catch {
            print("Error downloading image: \(error.localizedDescription)")
            return nil
        }
    }
    
    func deleted(_ wifes: WeebWifes) {
        if let index = wife.firstIndex(where: {$0.id == wifes.id}) {
            self.wife.remove(at: index)
        }
    }
}
