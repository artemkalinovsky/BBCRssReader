//
//  NewsFeedItemTableViewCell.swift
//  BBCRssReader
//
//  Created by Artem Kalinovsky on 4/10/19.
//  Copyright © 2019 DataArt. All rights reserved.
//

import UIKit
import Kingfisher

protocol NewsFeedItemTableViewCellDelegate: class {

    func newsFeedItemTableViewCellTouchUpInsideImage(_ cell: NewsFeedItemTableViewCell)

}

final class NewsFeedItemTableViewCell: UITableViewCell, BaseCellProtocol {

    weak var delegate: NewsFeedItemTableViewCellDelegate?

    @IBOutlet private weak var newsItemImageView: UIImageView!
    @IBOutlet private weak var newsTitleLabel: UILabel!
    @IBOutlet private weak var newsSummaryLabel: UILabel!

    func configure(with rssNewsItem: RssNewsItem, cellDelegate: NewsFeedItemTableViewCellDelegate? = nil) {
        newsTitleLabel.text = rssNewsItem.title
        newsSummaryLabel.text = rssNewsItem.summary?.trunc(length: 60)
        newsItemImageView.kf.setImage(with: rssNewsItem.mediaUrl)
        delegate = cellDelegate
    }
    
    @IBAction private func touchUpInsideImage(_ sender: UIButton) {
        delegate?.newsFeedItemTableViewCellTouchUpInsideImage(self)
    }

}
