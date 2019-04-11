//
//  NewsFeedItemTableViewCell.swift
//  BBCRssReader
//
//  Created by Artem Kalinovsky on 4/10/19.
//  Copyright © 2019 DataArt. All rights reserved.
//

import UIKit
import Kingfisher

final class NewsFeedItemTableViewCell: UITableViewCell, BaseCellProtocol {

    @IBOutlet private weak var newsItemImageView: UIImageView!
    @IBOutlet private weak var newsTitleLabel: UILabel!
    @IBOutlet private weak var newsSummaryLabel: UILabel!

    func configure(with rssNewsItem: RssNewsItem) {
        newsTitleLabel.text = rssNewsItem.title
        newsSummaryLabel.text = rssNewsItem.summary
        newsItemImageView.kf.setImage(with: rssNewsItem.mediaUrl)
    }
    
}
