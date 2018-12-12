//
//  SearchResultCell.swift
//  PopularRepositories
//
//  Created by Syed Haris Hussain on 13/12/2018.
//  Copyright © 2018 UMI Urban Mobility International GmbH. All rights reserved.
//

import UIKit

class SearchResultCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var starsLabel: UILabel!
    
    func configureViews(item: SearchResult.Item) {
        titleLabel.text = item.name
        descriptionLabel.text = item.description
        languageLabel.text = "Language: \(item.language ?? "N/A")"
        let stars: Int = item.stargazersCount ?? 0
        starsLabel.text = stars <= 1 ? "Star: \(stars)" : "Stars: \(stars)"
    }
}
