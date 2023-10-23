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
        cell.status.text = model.statusToString
        cell.species.text = model.specieToString
        cell.gender.text = model.genderToString
        cell.location.text = model.location.name
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
