//
//  CharacterListViewController.swift
//  RickMortyUI
//
//  Created by Joao Matheus on 17/10/23.
//

import UIKit

class CharacterListViewController: UITableViewController {

    public private(set) var characterCollection: [CharacterItemCellController] = []
    private let interactor: CharacterListInteractorInput
    
    init(interactor: CharacterListInteractorInput) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.register(CharacterItemCell.self, forCellReuseIdentifier: CharacterItemCell.identifier)
        interactor.loadService()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characterCollection.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CharacterItemCell.identifier,
            for: indexPath
        ) as? CharacterItemCell else {
            return UITableViewCell()
        }
        characterCollection[indexPath.row].renderCell(cell)
        return cell
    }

    @objc func refresh() {
        interactor.loadService()
    }

}

extension CharacterListViewController: CharacterListPresenterOutput {
    func onLoadingChange(_ isLoading: Bool) {
        if isLoading {
            refreshControl?.beginRefreshing()
            return
        }
        refreshControl?.endRefreshing()
    }
    
    func onCharacterItemCell(_ items: [CharacterItemCellController]) {
        characterCollection = items
        tableView.reloadData()
    }

}
