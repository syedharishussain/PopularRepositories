//
//  SearchResult+Item.swift
//  PopularRepositories
//
//  Created by Syed Haris Hussain on 12/12/2018.
//  Copyright © 2018 UMI Urban Mobility International GmbH. All rights reserved.
//

import Foundation

extension SearchResult {
    struct Item: Codable {
        let name: String?
        let fullName: String?
        let description: String?
        let url: URL
        let stargazersCount: Int?
        let language: String?
    }
}
