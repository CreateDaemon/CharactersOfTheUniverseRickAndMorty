//
//  ImageViewTable.swift
//  CharactersOfTheUniverseRickAndMorty
//
//  Created by Дмитрий Межевич on 28.10.21.
//

import UIKit

class ImageViewTable: UIImageView {
    
    private var currentURL: String?
    
    func fetchImage(forURL url: String?) {
        
        image = UIImage(named: "RickAndMorty")
        
        currentURL = url
        
        guard let url = url else { return }
        guard let imageURL = url.getURL() else {
            image = UIImage(named: "RickAndMorty")
            return
        }
        
        //  Есть ли изображение в кэше, то используем его
        if let cachedImage = getCachedImage(withURL: imageURL) {
            image = cachedImage
            return
        }
        
        URLSession.shared.dataTask(with: imageURL) { data, response, error in
            
            if let error = error {
                print(error)
                return
            }
            guard let data = data, let response = response else { return }
            guard let responseURL = response.url else { return }
            
            // Save image in cached
            self.saveImageToCache(data: data, respons: response)
            
            guard responseURL.absoluteString == self.currentURL else { return }
            
            DispatchQueue.main.async {
                self.image = UIImage(data: data)
            }
        }.resume()
        
    }
    
    private func saveImageToCache(data: Data, respons: URLResponse) {
        guard let responseURL = respons.url else { return }
        let cachedResponse = CachedURLResponse(response: respons, data: data)
        URLCache.shared.storeCachedResponse(cachedResponse, for: URLRequest(url: responseURL))
    }
    
    private func getCachedImage(withURL url: URL) -> UIImage? {
        
        if let cacheResponse = URLCache.shared.cachedResponse(for: URLRequest(url: url)) {
            return UIImage(data: cacheResponse.data)
        }
        return nil
    }
    
    
}


fileprivate extension String {
    
    func getURL() -> URL? {
        guard let url = URL(string: self) else { return nil }
        return url
    }
}
