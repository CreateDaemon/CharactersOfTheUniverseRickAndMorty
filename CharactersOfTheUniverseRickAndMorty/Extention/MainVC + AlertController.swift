//
//  ExtentionMainVC + Alert.swift
//  CharactersOfTheUniverseRickAndMorty
//
//  Created by Дмитрий Межевич on 26.10.21.
//

import UIKit

extension MainViewController {
    
    func presentAlertController(withTitel titel: String, messange: String, completionHandler: @escaping (Int) -> Void) {
        
        let alertController = UIAlertController(title: titel, message: messange, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.keyboardType = .numbersAndPunctuation
            textField.placeholder = "Enter page"
        }
        
        let alertActionSegue = UIAlertAction(title: "Segue", style: .default) { action in
            let textField = alertController.textFields?.first
            guard let text = textField?.text,
                  let page = Int(text)
            else { return }
            completionHandler(page)
        }
        
        let alertActionCancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(alertActionCancel)
        alertController.addAction(alertActionSegue)
        
        present(alertController, animated: true)
    }
}
