//
//  SearchResultCell.swift
//  PopularRepositories
//
//  Created by Syed Haris Hussain on 13/12/2018.
//  Copyright © 2018 UMI Urban Mobility International GmbH. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SearchResultCell: UITableViewCell {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    private let disposeBag = DisposeBag()
    
    var viewModel: SearchResultCell.ViewModel? {
        didSet {
            guard let vm = self.viewModel else {return}
            
            vm.title.asObservable().bind(to: self.titleLabel.rx.text).disposed(by: disposeBag)
            vm.description.asObservable().bind(to: self.descriptionLabel.rx.text).disposed(by: disposeBag)
        }
    }
}

extension SearchResultCell {
    
    struct ViewModel {
        
        let title = Variable<String>("")
        let description = Variable<String>("")
        
        init(item: SearchResult.Item) {
            self.updateVariables(from: item)
        }
        
        private func updateVariables(from item: SearchResult.Item) {
            self.title.value = item.name ?? ""
            self.description.value = item.description ?? ""
        }
    }
}
