//
//  BaseCellProtocol.swift
//  BBCRssReader
//
//  Created by Artem Kalinovsky on 4/11/19.
//  Copyright © 2019 DataArt. All rights reserved.
//

import UIKit

protocol BaseCellProtocol: NibLoadable {
    static var id: String { get }
    static var cellNib: UINib { get }
    static var cellHeight: CGFloat { get }
}

extension BaseCellProtocol {

    static var id: String {
        return String(describing: self)
    }

    static var cellNib: UINib {
        return UINib(nibName: id, bundle: Bundle.main)
    }

    static var cellHeight: CGFloat {
        return 44
    }
}
