//
//  DetailViewController.swift
//  PopularRepositories
//
//  Created by Syed Haris Hussain on 13/12/2018.
//  Copyright © 2018 UMI Urban Mobility International GmbH. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DetailViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var starsLabel: UILabel!
    
    var viewModel: DetailViewController.ViewModel?
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bindViewModel()
    }
    
    private func bindViewModel() {
        guard let vm = self.viewModel else {return}
        
        vm.title.asObservable().bind(to: self.titleLabel.rx.text).disposed(by: disposeBag)
        vm.description.asObservable().bind(to: self.descriptionLabel.rx.text).disposed(by: disposeBag)
        vm.language.asObservable().bind(to: self.languageLabel.rx.text).disposed(by: disposeBag)
        vm.stars.asObservable().bind(to: self.starsLabel.rx.text).disposed(by: disposeBag)
    }
    
}

extension DetailViewController {
    struct ViewModel {
        let item: SearchResult.Item
        
        let title: Variable<String>
        let description: Variable<String>
        let language: Variable<String>
        let stars: Variable<String>
        
        init(item: SearchResult.Item) {
            self.item = item
            
            self.title = Variable<String>(item.name ?? "")
            self.description = Variable<String>(item.description ?? "")
            self.language = Variable<String>("Language: \(item.language ?? "N/A")")
            let starsCount: Int = item.stargazersCount ?? 0
            let starsText = starsCount <= 1 ? "Star: \(starsCount)" : "Stars: \(starsCount)"
            self.stars = Variable<String>(starsText)
        }
    }
}
