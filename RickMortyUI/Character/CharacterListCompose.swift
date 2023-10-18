//
//  CharacterListCompose.swift
//  RickMortyUI
//
//  Created by Joao Matheus on 18/10/23.
//

import UIKit
import RickMortyDomain

public final class CharacterListCompose<Service: RickMortyLoader> where Service.T == Result<[Character], RickMortyResultError> {
    public static func compose(service: Service) -> UITableViewController {
        let presenter = CharacterListPresenter()
        let interactor = CharacterListInteractor(service: service, presenter: presenter)
        let controller = CharacterListViewController(interactor: interactor)
        presenter.view = controller
        return controller
    }
}
