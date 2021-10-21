//
//  ViewController.swift
//  CharactersOfTheUniverseRickAndMorty
//
//  Created by Дмитрий Межевич on 20.10.21.
//

import UIKit

class ViewController: UIViewController {
    
    private var character = Character()
    private var flagJSON = false
    
    @IBOutlet var imageCharacter: UIImageView!
    @IBOutlet var nameCharacter: UILabel!
    
    private let characterAPIURL = "https://rickandmortyapi.com/api/character/1"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageCharacter.image = UIImage(named: "RickAndMorty")
        getDataFromJSON()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        while !flagJSON {}
        
        nameCharacter.text = character.name ?? "No name"
        getImageCharacter(fromURLString: character.image)
    }

    private func getDataFromJSON() {
        
        guard let url = URL(string: characterAPIURL) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }
            
            do {
                self.character = try JSONDecoder().decode(Character.self, from: data)
                self.flagJSON = true
            } catch {
                let error: Error = try! JSONDecoder().decode(Error.self, from: data)
                // DOTO - print error
                print(error.error)
            }
        }.resume()
    }
    
    private func getImageCharacter(fromURLString urlString: String?) {

        DispatchQueue.global().async {
            guard let urlString = urlString,
                  let url = URL(string: urlString),
                  let dataURL = try? Data(contentsOf: url) else { return }

            DispatchQueue.main.async {
                self.imageCharacter.image = UIImage(data: dataURL)
            }
        }
    }
    
}

