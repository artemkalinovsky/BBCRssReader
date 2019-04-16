//
//  ZoomedImageViewController.swift
//  BBCRssReader
//
//  Created by Artem Kalinovsky on 4/12/19.
//  Copyright © 2019 DataArt. All rights reserved.
//

import ReSwift

final class ZoomedImageViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!

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
        store.dispatch(RoutingAction(destination: .rssItemsFeed))
        store.unsubscribe(self)
    }

    @IBAction private func touchUpInsideCloseButton(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
}

// MARK: - UIScrollViewDelegate

extension ZoomedImageViewController: UIScrollViewDelegate {

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

}

// MARK: - StoreSubscriber

extension ZoomedImageViewController: StoreSubscriber {

    func newState(state: RssFeedItemDetailsState) {
        imageView.kf.setImage(with: state.rssItem?.mediaUrl)
    }

}
