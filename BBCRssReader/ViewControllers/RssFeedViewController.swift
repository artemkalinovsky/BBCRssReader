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
                                                                                                    cell.configure(with: rssNewsItem,
                                                                                                                   cellDelegate: self)
                                                                                                    return cell
        }
        return dataSource
    }()

    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        return searchController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.searchController = searchController
        definesPresentationContext = true
        tableView.dataSource = tableDataSource
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshCartItems), for: .valueChanged)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        store.dispatch(RoutingAction(destination: .rssItemsFeed))
        store.subscribe(self) {
            $0.select {
                $0.rssFeedState
            }
        }
        store.dispatch(RssFeedAction.fetch)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        store.unsubscribe(self)
    }

    @objc private func refreshCartItems() {
        store.dispatch(RssFeedAction.fetch)
    }

}

// MARK: - UISearchControllerDelegate

extension RssFeedViewController: UISearchControllerDelegate {
    
    func didDismissSearchController(_ searchController: UISearchController) {
        store.dispatch(RssFeedAction.fetch)
    }
    
}

// MARK: - UISearchResultsUpdating

extension RssFeedViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchBarText = searchController.searchBar.text,
            !searchBarText.isEmpty else {
                return
        }
        store.dispatch(RssFeedAction.search(searchBarText))
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

// MARK: - NewsFeedItemTableViewCellDelegate

extension RssFeedViewController: NewsFeedItemTableViewCellDelegate {

    func newsFeedItemTableViewCellTouchUpInsideImage(_ cell: NewsFeedItemTableViewCell) {
        guard let displayedModels = tableDataSource?.models,
            let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        store.dispatch(RoutingAction(destination: .zoomedImage,
                                     detailedRssNewsFeedItem: displayedModels[indexPath.row]))
    }

}
