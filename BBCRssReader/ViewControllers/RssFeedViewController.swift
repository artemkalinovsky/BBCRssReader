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

// MARK: - UITableViewDelegate

extension RssFeedViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let displayedModels = tableDataSource?.models else { return }
        store.dispatch(RoutingAction(destination: .rssItemDetails,
                                     detailedRssNewsFeedItem: displayedModels[indexPath.row]))
    }

}

// MARK: - StoreSubscriber

extension RssFeedViewController: StoreSubscriber {

    func newState(state: RssFeedState) {
        if !state.showLoading {
            refreshControl.endRefreshing()
        }
        loadingView.isHidden = !state.showLoading
        if !state.rssItems.isEmpty {
            tableDataSource?.models = state.rssItems.sorted { $0.publishDate ?? Date() > $1.publishDate ?? Date() }
        }
        tableView.isHidden = state.showLoading
        tableView.reloadData()
    }

}
