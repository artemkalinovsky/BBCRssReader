//
//  ViewController.swift
//  BBCRssReader
//
//  Created by Artem Kalinovsky on 4/8/19.
//  Copyright © 2019 DataArt. All rights reserved.
//

import ReSwift

class ViewController: UIViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        store.subscribe(self) {
            $0.select {
                $0.rssFeedState
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        store.dispatch(fetchRssFeed)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        store.unsubscribe(self)
    }

}

// MARK: - StoreSubscriber
extension ViewController: StoreSubscriber {
    func newState(state: RssFeedState) {

    }
}

