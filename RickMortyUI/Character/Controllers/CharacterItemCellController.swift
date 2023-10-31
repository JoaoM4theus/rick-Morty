//
//  CharacterItemCellController.swift
//  RickMortyUI
//
//  Created by Joao Matheus on 17/10/23.
//

import UIKit
import RickMortyDomain

final class CharacterItemCellController {
    
    let model: Character
    
    init(model: Character) {
        self.model = model
    }
    
    func renderCell(_ cell: CharacterItemCell) {
        cell.name.text = model.name
        cell.moreInfo.text = "More info..."
        if let url = URL(string: model.image) {
//            cell.characterImage.downloadImage(from: url) { image in
//                cell.characterImage.image = image
//                cell.characterImage.layer.cornerRadius = cell.characterImage.frame.width / 2
//                cell.characterImage.clipsToBounds = true
//            }
        }
    }

}

private extension Character {
    
    var statusToString: String {
        return "Status: \(status)"
    }
    
    var specieToString: String {
        return "Specie: \(species)"
    }
    
    var genderToString: String {
        return "Gender: \(gender)"
    }
    
    
}
