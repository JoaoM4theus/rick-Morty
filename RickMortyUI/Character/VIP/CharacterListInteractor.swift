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

final class CharacterListInteractor<Service: RickMortyLoader>: CharacterListInteractorInput where Service.T == Result<[Character], RickMortyResultError> {
    public typealias T = Result<[Character], RickMortyResultError>
    
    private let service: Service
    private let presenter: CharacterListPresenterInput
    
    init(service: Service, presenter: CharacterListPresenterInput) {
        self.service = service
        self.presenter = presenter
    }

    func loadService() {
        presenter.onLoadingChange(true)
        service.load { [weak presenter] result in
            switch result {
            case let .success(items):
                presenter?.onRestaurantItem(items)
            default: break
            }
            presenter?.onLoadingChange(false)
        }
    }

}
