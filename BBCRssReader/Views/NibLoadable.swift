//
//  NibLoadable.swift
//  BBCRssReader
//
//  Created by Artem Kalinovsky on 4/11/19.
//  Copyright © 2019 DataArt. All rights reserved.
//

import UIKit

protocol NibLoadable {

    associatedtype ViewType = Self
    static func instantiateFromNib() -> ViewType?

}

extension NibLoadable where Self: UIView {

    static func instantiateFromNib() -> ViewType? {
        return Bundle.main.loadNibNamed(String(describing: self), owner: nil, options: nil)?.first as? ViewType
    }

}
