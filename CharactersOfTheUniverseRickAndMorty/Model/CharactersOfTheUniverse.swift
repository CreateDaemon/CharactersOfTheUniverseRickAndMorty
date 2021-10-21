//
//  CharactersOfTheUniverse.swift
//  CharactersOfTheUniverseRickAndMorty
//
//  Created by Дмитрий Межевич on 20.10.21.
//

struct Origin: Decodable {
    
    var name: String?
    var url: String?
}

struct Location: Decodable {
    
    var name: String?
    var url: String?
}

struct Character: Decodable {
    
    var id: Int?
    var name: String?
    var status: String?
    var species: String?
    var type: String?
    var gender: String?
    var origin: Origin?
    var location: Location?
    var image: String?
    var episode: [String]?
    var url: String?
    var created: String?
}

struct Info: Decodable {
    
    var count: Int?
    var pages: Int?
    var next: String?
    var prev: String?
}

struct Characters: Decodable {
    
    var info: Info?
    var results: [Character]?
}

struct Error: Decodable {
    
    var error: String
}
