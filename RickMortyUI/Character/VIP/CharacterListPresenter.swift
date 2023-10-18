//
//  CharacterListPresenter.swift
//  RickMortyUI
//
//  Created by Joao Matheus on 18/10/23.
//

import RickMortyDomain

protocol CharacterListPresenterInput: AnyObject {
    func onLoadingChange(_ isLoading: Bool)
    func onRestaurantItem(_ items: [Character])
}

protocol CharacterListPresenterOutput: AnyObject {
    func onLoadingChange(_ isLoading: Bool)
    func onRestaurantItemCell(_ items: [CharacterItemCellController])
}

final class CharacterListPresenter: CharacterListPresenterInput {

    weak var view: CharacterListPresenterOutput?

    func onLoadingChange(_ isLoading: Bool) {
        view?.onLoadingChange(isLoading)
    }
    
    func onRestaurantItem(_ items: [Character]) {
        let cells = items.map { CharacterItemCellController(model: $0) }
        view?.onRestaurantItemCell(cells)
    }

}
