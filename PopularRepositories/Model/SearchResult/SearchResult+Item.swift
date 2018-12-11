//
//  SearchResult+Item.swift
//  PopularRepositories
//
//  Created by Syed Haris Hussain on 12/12/2018.
//  Copyright © 2018 UMI Urban Mobility International GmbH. All rights reserved.
//

import Foundation

extension SearchResult {
    public struct Item {
        let id: Int
        let nodeId: String
        let name: String
        let fullName: String
        let owner: [SearchResult.Item.Owner]
        let `private`: Bool
        let htmlUrl: String
        let description: String
        let fork: Bool
        let url: URL
        let createdAt: Date
        let updatedAt: Date
        let pushedAt: Date
        let homepage: String
        let size: Int
        let stargazersCount: Int
        let watchersCount: Int
        let language: String
        let forksCount: Int
        let openIssuesCount: Int
        let masterBranch: String
        let defaultBranch: String
        let score: Double
    }
}

extension SearchResult.Item {
    struct Owner {
        let login: String
        let id: Int
        let nodeId: String
        let avatarUrl: URL
        let gravatarId: String
        let url: URL
        let receivedEventsUrl: URL
        let type: String
    }
}
