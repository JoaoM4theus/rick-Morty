//
//  CharacterListViewController.swift
//  RickMortyUI
//
//  Created by Joao Matheus on 17/10/23.
//

import UIKit

class CharacterListViewController: UITableViewController {

    public private(set) var characterCollection: [CharacterItemCellController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(CharacterItemCell.self, forCellReuseIdentifier: CharacterItemCell.identifier)
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

}
