//
//  RssFeedItemDetailsViewController.swift
//  BBCRssReader
//
//  Created by Artem Kalinovsky on 4/12/19.
//  Copyright © 2019 DataArt. All rights reserved.
//

import ReSwift
import Kingfisher

final class RssFeedItemDetailsViewController: UIViewController {

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var summaryLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        store.dispatch(setRssFeedItem)
    }

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
