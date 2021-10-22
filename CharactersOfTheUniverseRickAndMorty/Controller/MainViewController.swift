//
//  MainTableViewController.swift
//  CharactersOfTheUniverseRickAndMorty
//
//  Created by Дмитрий Межевич on 21.10.21.
//

import UIKit

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private var characters = Characters()
    private let characterAPIURL = "https://rickandmortyapi.com/api/character/?page=2"
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        getDataFromJSON()
    }
    
    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characters.results?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell

        guard let result = characters.results?[indexPath.row] else { return cell }
        
        cell.apdate(result)

        return cell
    }
    
    private func getDataFromJSON() {
        
        guard let url = URL(string: characterAPIURL) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }
            
            do {
                self.characters = try JSONDecoder().decode(Characters.self, from: data)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch {
                let error: Error = try! JSONDecoder().decode(Error.self, from: data)
                self.tableView.reloadData()
                print(error.error)
            }
        }.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "details",
              let indexPath = tableView.indexPathForSelectedRow,
              let detailsVC = segue.destination as? DetailsViewController else { return }
        //Text
        DispatchQueue.main.async {
            detailsVC.episodeHero.text = self.characters.results?[indexPath.row].episode?.joined(separator: "--")
        }
        // Image
        DispatchQueue.global().async {
            guard let urlString = self.characters.results?[indexPath.row].image,
                  let url = URL(string: urlString),
                  let dataURL = try? Data(contentsOf: url) else { return }

            DispatchQueue.main.async {
                detailsVC.imageHero.image = UIImage(data: dataURL)
            }
        }
        
        
    }
    
}
