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
    let service: CharacterDownloadImage
    
    init(model: Character, service: CharacterDownloadImage) {
        self.model = model
        self.service = service
    }

    func renderCell(_ cell: CharacterItemCell) {
        cell.name.text = model.name
        cell.moreInfo.text = "More info..."
        if let url = URL(string: model.image) {
            service.downloadImage(fromUrl: url) { result in
                switch result {
                case let .success(data):
                    cell.characterImage.image = UIImage(data: data)
                case .failure: break
                }
            }
            return
        }
        cell.characterImage.image = UIImage(named: "avatar_placeholder")
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
