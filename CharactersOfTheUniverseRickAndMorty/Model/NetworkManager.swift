//
//  NetworkManager.swift
//  CharactersOfTheUniverseRickAndMorty
//
//  Created by Дмитрий Межевич on 26.10.21.
//

import Foundation
import Alamofire
import AlamofireImage


class NetworkManager {
    
    var characresAndInfoData: ((_ infoData: InfoData, _ charactersData: [CharacterData]) -> Void)?
    
    func getDataFromJSON(byNumberOfSection page: Int) {
        
        guard let url = URL(string: "https://rickandmortyapi.com/api/character/?page=\(page)") else { return }
        
        AF.request(url).validate().responseJSON { jsonData in
            
            switch jsonData.result {
            case .success(_):
                do {
                    guard let data = jsonData.data else { return }
                    let charactersData = try JSONDecoder().decode(Characters.self, from: data)
                    
                    guard let countOfCharacter = charactersData.results?.count else { return }
                    
                    var arrayOfCharacter: [CharacterData] = []
                    
                    for index in 0..<countOfCharacter {
                        arrayOfCharacter.append(CharacterData(forChracterData: charactersData.results![index])!)
                    }
                    
                    guard let infoData = InfoData(forInfoData: charactersData.info!) else { return }
                    
                    self.characresAndInfoData?(infoData, arrayOfCharacter)
                } catch {
                    print("Error decoding --- \(error)")
                }
            case .failure(let error):
                print("Error --- \(error)")
            }
        }
    }
    
    func getImageData(forHero urlString: String) -> Data? {

        guard let url = URL(string: urlString),
              let data = try? Data(contentsOf: url) else { return nil }
        
        return data
    }
}
