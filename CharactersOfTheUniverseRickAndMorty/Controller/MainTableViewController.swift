//
//  MainTableViewController.swift
//  CharactersOfTheUniverseRickAndMorty
//
//  Created by Дмитрий Межевич on 21.10.21.
//

import UIKit

class MainTableViewController: UITableViewController {

    private var characters = Characters()
    private var flagJSON = false
    
    @IBOutlet var imageCharacter: UIImageView!
    @IBOutlet var nameCharacter: UILabel!
    
    private let characterAPIURL = "https://rickandmortyapi.com/api/character/?page=2"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDataFromJSON()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        while !flagJSON {}
        
        //TODO: - ...
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characters.results!.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell

        guard let result = characters.results?[indexPath.row] else { return cell }
        
        cell.apdate(result)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        10
    }
    
    private func getDataFromJSON() {
        
        guard let url = URL(string: characterAPIURL) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }
            
            do {
                self.characters = try JSONDecoder().decode(Characters.self, from: data)
                self.flagJSON = true
            } catch {
                let error: Error = try! JSONDecoder().decode(Error.self, from: data)
                // DOTO - print error
                print(error.error)
            }
        }.resume()
    }

}
