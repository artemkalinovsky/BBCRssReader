//
//  Loadable.swift
//  BBCRssReader
//
//  Created by Artem Kalinovsky on 4/15/19.
//  Copyright © 2019 DataArt. All rights reserved.
//

import Foundation

enum Loadable<T> {

    case initial
    case loading
    case value(T)
    case error(Error)
}
