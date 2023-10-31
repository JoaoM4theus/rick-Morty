//
//  CharacterListInteractor.swift
//  RickMortyUI
//
//  Created by Joao Matheus on 18/10/23.
//

import Foundation
import RickMortyDomain

protocol CharacterListInteractorInput {
    func loadService()
}

final class CharacterListInteractor: CharacterListInteractorInput {
    
    private let service: CharacterLoader
    private let presenter: CharacterListPresenterInput
    
    init(service: CharacterLoader, presenter: CharacterListPresenterInput) {
        self.service = service
        self.presenter = presenter
    }

    func loadService() {
        presenter.onLoadingChange(true)
        service.load { [weak presenter] result in
            switch result {
            case let .success(items):
                presenter?.onCharacterItem(items)
            default: break
            }
            presenter?.onLoadingChange(false)
        }
    }

}
