//
//  RssFeedViewController.swift
//  BBCRssReader
//
//  Created by Artem Kalinovsky on 4/10/19.
//  Copyright © 2019 DataArt. All rights reserved.
//

import ReSwift

final class RssFeedViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var loadingView: UIView!

    private let refreshControl = UIRefreshControl()
    
    private lazy var tableDataSource: TableDataSource<NewsFeedItemTableViewCell, RssNewsItem>? = {
        let dataSource: TableDataSource<NewsFeedItemTableViewCell, RssNewsItem> = TableDataSource(cellIdentifier: NewsFeedItemTableViewCell.id,
                                                                                                  models: []) { cell, rssNewsItem in
                                                                                                    cell.configure(with: rssNewsItem)
                                                                                                    return cell
        }
        return dataSource
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = tableDataSource
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshCartItems), for: .valueChanged)
        store.dispatch(fetchRssFeed)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        store.subscribe(self) {
            $0.select {
                $0.rssFeedState
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        store.unsubscribe(self)
    }

    @objc private func refreshCartItems() {
        store.dispatch(fetchRssFeed)
    }

}

// MARK: - StoreSubscriber

extension RssFeedViewController: StoreSubscriber {

    func newState(state: RssFeedState) {
        if !state.showLoading {
            refreshControl.endRefreshing()
        }
        loadingView.isHidden = !state.showLoading
        tableDataSource?.models = state.rssItems
        tableView.isHidden = state.showLoading
        tableView.reloadData()
    }

}
