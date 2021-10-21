//
//  TableViewCell.swift
//  CharactersOfTheUniverseRickAndMorty
//
//  Created by Дмитрий Межевич on 21.10.21.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet var imageHero: UIImageView!
    @IBOutlet var nameHero: UILabel!
    @IBOutlet var statusHero: UILabel!
    @IBOutlet var genderHero: UILabel!
    
    func apdate(_ data: Character) {
        
        nameHero.text = "Name: \(data.name ?? "Not found")"
        statusHero.text = "Status: \(data.status ?? "Not found")"
        genderHero.text = "Gender: \(data.gender ?? "Not found")"
        getImageCharacter(fromURLString: data.image)
    }
    
    private func getImageCharacter(fromURLString urlString: String?) {

        DispatchQueue.global().async {
            guard let urlString = urlString,
                  let url = URL(string: urlString),
                  let dataURL = try? Data(contentsOf: url) else { return }

            DispatchQueue.main.async {
                self.imageHero.image = UIImage(data: dataURL)
            }
        }
    }
    
}
