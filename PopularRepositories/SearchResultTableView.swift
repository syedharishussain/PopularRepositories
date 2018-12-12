//
//  SearchResultTableView.swift
//  PopularRepositories
//
//  Created by Syed Haris Hussain on 13/12/2018.
//  Copyright © 2018 UMI Urban Mobility International GmbH. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SearchResultTableView: UITableView {
    
    var items = Variable<[SearchResult.Item]>([])
    let disposeBag = DisposeBag()

    func bindDataSource() {
        self.items
            .asObservable()
            .bind(to: self.rx.items(
                    cellIdentifier: String(describing: SearchResultCell.self),
                    cellType: SearchResultCell.self
                )
            )
            { row, item, cell in
                cell.configureViews(item: item)
            }
            .disposed(by: disposeBag)
    }
}
