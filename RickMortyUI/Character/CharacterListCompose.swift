//
//  CharacterListCompose.swift
//  RickMortyUI
//
//  Created by Joao Matheus on 18/10/23.
//

import UIKit
import RickMortyDomain

public final class CharacterListCompose {
    public static func compose(service: CharacterLoader, downloadImage: CharacterDownloadImage) -> UITableViewController {
        let decorator = MainQueueDispatchDecorator(decorate: service)
        let presenter = CharacterListPresenter(service: downloadImage)
        let interactor = CharacterListInteractor(service: decorator, presenter: presenter)
        let controller = CharacterListViewController(interactor: interactor)
        presenter.view = controller
        return controller
    }
}

extension MainQueueDispatchDecorator: CharacterLoader where T == CharacterLoader{
    
    func load(completion: @escaping (CharacterLoader.CharacterResult) -> Void) {
        decorate.load { [weak self] result in
            self?.dispatch {
                completion(result)
            }
        }
    }

}
