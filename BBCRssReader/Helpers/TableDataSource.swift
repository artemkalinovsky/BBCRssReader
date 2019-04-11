//
//  TableDataSource.swift
//  BBCRssReader
//
//  Created by Artem Kalinovsky on 4/10/19.
//  Copyright © 2019 DataArt. All rights reserved.
//

import UIKit

final class TableDataSource<V, T> : NSObject, UITableViewDataSource where V: UITableViewCell {

    typealias CellConfiguration = (V, T) -> V

    var models: [T]
    private let configureCell: CellConfiguration
    private let cellIdentifier: String

    init(cellIdentifier: String, models: [T], configureCell: @escaping CellConfiguration) {
        self.models = models
        self.cellIdentifier = cellIdentifier
        self.configureCell = configureCell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? V

        guard let currentCell = cell else {
            fatalError("Identifier or class not registered with this table view")
        }

        let model = models[indexPath.row]
        return configureCell(currentCell, model)
    }
}

