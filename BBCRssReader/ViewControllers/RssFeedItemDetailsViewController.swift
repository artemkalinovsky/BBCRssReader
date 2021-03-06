//
//  RssFeedItemDetailsViewController.swift
//  BBCRssReader
//
//  Created by Artem Kalinovsky on 4/12/19.
//  Copyright © 2019 DataArt. All rights reserved.
//

import ReSwift
import Kingfisher
import SafariServices

final class RssFeedItemDetailsViewController: UIViewController {

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var summaryLabel: UILabel!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        store.subscribe(self) {
            $0.select {
                $0.rssFeedItemDetailsState
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        store.unsubscribe(self)
        guard store.state.routingState.navigationState == .rssItemDetails else {
            return
        }
        store.dispatch(RoutingAction(destination: .rssItemsFeed))
    }
    
    @IBAction private func actionBarButtonItemPressed(_ sender: UIBarButtonItem) {
        guard let url = store.state.rssFeedItemDetailsState.rssItem?.url else { return }
        let safariViewController = SFSafariViewController(url: url)
        safariViewController.delegate = self
        store.dispatch(RoutingAction(destination: .safariViewController))
        present(safariViewController, animated: true)
    }

}

// MARK: - StoreSubscriber

extension RssFeedItemDetailsViewController: StoreSubscriber {

    func newState(state: RssFeedItemDetailsState) {
        title = state.rssItem?.title
        imageView.kf.setImage(with: state.rssItem?.mediaUrl)
        summaryLabel.text = state.rssItem?.summary
    }

}

// MARK: - SFSafariViewControllerDelegate

extension RssFeedItemDetailsViewController: SFSafariViewControllerDelegate {

    func safariViewController(_ controller: SFSafariViewController,
                              didCompleteInitialLoad didLoadSuccessfully: Bool) {
    }

    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true)
        store.dispatch(RoutingAction(destination: .rssItemDetails))
    }

}
