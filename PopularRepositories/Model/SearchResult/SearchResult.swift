//
//  SearchResult.swift
//  PopularRepositories
//
//  Created by Syed Haris Hussain on 12/12/2018.
//  Copyright © 2018 UMI Urban Mobility International GmbH. All rights reserved.
//

import Foundation

struct SearchResult: Codable {
    let totalCount: Int?
    let incompleteResults: Bool?
    let items: [SearchResult.Item]
}
