//
//  CharacterListPresenter.swift
//  RickMortyUI
//
//  Created by Joao Matheus on 18/10/23.
//

import RickMortyDomain

protocol CharacterListPresenterInput: AnyObject {
    func onLoadingChange(_ isLoading: Bool)
    func onCharacterItem(_ items: [Character])
}

protocol CharacterListPresenterOutput: AnyObject {
    func onLoadingChange(_ isLoading: Bool)
    func onCharacterItemCell(_ items: [CharacterItemCellController])
}

final class CharacterListPresenter: CharacterListPresenterInput {

    weak var view: CharacterListPresenterOutput?
    private(set) var service: CharacterDownloadImage
    
    init(service: CharacterDownloadImage) {
        self.service = service
    }
 
    func onLoadingChange(_ isLoading: Bool) {
        view?.onLoadingChange(isLoading)
    }
    
    func onCharacterItem(_ items: [Character]) {
        let cells = items.map { CharacterItemCellController(model: $0, service: service) }
        view?.onCharacterItemCell(cells)
    }

}
