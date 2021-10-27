//
//  CharactersData.swift
//  CharactersOfTheUniverseRickAndMorty
//
//  Created by Дмитрий Межевич on 26.10.21.
//

import Foundation

struct CharacterData {
    
    var name: String
    var status: String
    var gender: String
    var imageString: String
    
    init?(forChracterData data: Character) {
        name = data.name ?? "No name"
        status = data.status ?? "No data"
        gender = data.gender ?? "Undefined"
        imageString = data.image ?? ""
    }
}

struct InfoData {
    
    var countOfPage: Int
    
    init?(forInfoData data: Info) {
        countOfPage = data.pages ?? 0
    }
}
