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
import RxSwiftExt
import Alamofire
import SVProgressHUD

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
        
        let title = Variable<String>("")
        let description = Variable<String>("")
        let language = Variable<String>("")
        let stars = Variable<String>("")
        
        let disposeBag = DisposeBag()
        
        init(item: SearchResult.Item) {
            self.updateVariables(from: item)
            self.updateRepositoryData(from: item.url)
        }
        
        private func updateVariables(from item: SearchResult.Item) {
            self.title.value = item.name ?? ""
            self.description.value = item.description ?? ""
            self.language.value = "Language: \(item.language ?? "N/A")"
            let starsCount: Int = item.stargazersCount ?? 0
            let starsText = starsCount <= 1 ? "Star: \(starsCount)" : "Stars: \(starsCount)"
            self.stars.value = starsText
        }
        
        private func updateRepositoryData(from url: URL) {
            self.pollRepository(from: url)
                .repeatWithBehavior(RepeatBehavior.delayed(maxCount: UInt.max, time: 1.0))
                .subscribe(onNext: { (item) in
                    self.updateVariables(from: item)
                }, onError: { (error) in
                    SVProgressHUD.showError(withStatus: error.localizedDescription)
                }).disposed(by: disposeBag)
        }
        
        private func pollRepository(from url: URL) -> Observable<SearchResult.Item> {
            
            return Observable.create({ (observer) -> Disposable in
                
                AF.request(url, headers: AppConstants.noCacheHeader)
                    .responseDecodable(
                        decoder: AppConstants.decoder,
                        completionHandler: { (response: DataResponse<SearchResult.Item>) in
                            
                        switch response.result {
                        case .success(let value):
                            observer.onNext(value)
                            
                        case .failure(let error):
                            observer.onError(error)
                        }
                        observer.onCompleted()
                    })
                
                return Disposables.create()
            })
            
        }
    }
}
