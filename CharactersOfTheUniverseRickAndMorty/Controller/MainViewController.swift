//
//  MainTableViewController.swift
//  CharactersOfTheUniverseRickAndMorty
//
//  Created by Дмитрий Межевич on 21.10.21.
//

import UIKit
import Alamofire
import AlamofireImage

class MainViewController: UIViewController {

    //MARK: - Property
    enum selectMethod {
        case next, back, choose
    }
    
    private var networkManager = NetworkManager()
    private var characters: [CharacterData] = []
    private var countOfPages = 0
    private var currentOfPage = 1 {
        willSet {
            if newValue == 34, nextPage.isEnabled {
                nextPage.isEnabled = false
            }
            if newValue == 1, backPage.isEnabled {
                backPage.isEnabled = false
            }
            if newValue > 1, !backPage.isEnabled {
                backPage.isEnabled = true
            }
            if newValue < 34, !nextPage.isEnabled {
                nextPage.isEnabled = true
            }
        }
    }
    
    //MARK: - IB Outlet
    @IBOutlet var tableView: UITableView!
    @IBOutlet var chooseOfPage: UILabel!
    @IBOutlet var currentOfPageLabel: UILabel!
    @IBOutlet var nextPage: UIButton!
    @IBOutlet var backPage: UIButton! {
        didSet {
            if currentOfPage == 1 {
                backPage.isEnabled = false
            }
        }
    }
    
    //MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //  TableViewDelegate
        tableView.dataSource = self
        tableView.delegate = self
        
        //  Request to server
        networkManager.getDataFromJSON(byNumberOfSection: currentOfPage)
        
        //  Respons of server
        networkManager.characresAndInfoData = { [unowned self] infoData, charactersData in
            self.countOfPages = infoData.countOfPage
            self.characters = charactersData
            self.tableView.reloadData()
            self.chooseOfPage.text = "Page \(self.currentOfPage) is \(self.countOfPages)"
            self.currentOfPageLabel.text = "Current \(self.currentOfPage) is \(infoData.countOfPage)"
        }
    }
    
    //MARK: - IB Action
    
    //  Next page
    @IBAction func nextPage(_ sender: UIButton) {
        
        if currentOfPage < countOfPages {
            
            tableView.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: true)
            selectMethodUpdate(select: .next)
        }
        
    }
    
    //  Previous page
    @IBAction func backPage(_ sender: UIButton) {
        
        if currentOfPage > 1 {
            
            tableView.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: true)
            selectMethodUpdate(select: .back)
        }
    }
    
    //  Choosing of page
    @IBAction func choosePage(_ sender: UIButton) {
        
        presentAlertController(withTitel: "Choosing of page", messange: "Pleath, select a page in the range from 1 to \(self.countOfPages).") { [unowned self] numberOfPage in
            guard 1...self.countOfPages ~= numberOfPage,
                  numberOfPage != self.currentOfPage
            else { return }
            
            self.currentOfPage = numberOfPage
            
            selectMethodUpdate(select: .choose)
        }
    }
    
    //MARK: - Private method
    //  Apdate Interface
    private func selectMethodUpdate(select: selectMethod) {

        switch select {
        case .next:
            currentOfPage += 1
            updateInterface()
        case .back:
            currentOfPage -= 1
            updateInterface()
        case .choose:
            updateInterface()
        }
    }

    private func updateInterface() {
        networkManager.getDataFromJSON(byNumberOfSection: currentOfPage)
        networkManager.characresAndInfoData = { [unowned self] _, charactersData in
            
            self.chooseOfPage.text = "Page \(self.currentOfPage) is \(self.countOfPages)"
            self.currentOfPageLabel.text = "Current \(self.currentOfPage) is \(self.countOfPages)"
            
            self.characters = charactersData
            self.tableView.reloadData()
        }
    }
}

//MARK: - Extention MainViewController
extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characters.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell

        cell.nameHero.text = "Name: \(characters[indexPath.row].name)"
        cell.statusHero.text = "Status: \(characters[indexPath.row].status)"
        cell.genderHero.text = "Gender: \(characters[indexPath.row].gender)"
        
        DispatchQueue.global().async {
            guard let data = self.networkManager.getImageData(forHero: self.characters[indexPath.row].imageString) else { return }
            
            DispatchQueue.main.async {
                cell.imageHero.image = UIImage(data: data)
            }
        }

        return cell
    }
}
