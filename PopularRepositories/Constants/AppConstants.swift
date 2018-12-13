//
//  AppConstants.swift
//  PopularRepositories
//
//  Created by Syed Haris Hussain on 13/12/2018.
//  Copyright © 2018 UMI Urban Mobility International GmbH. All rights reserved.
//

import Foundation
import Alamofire

struct AppConstants {
    static let apiUrl: String = "https://api.github.com/search/repositories?q=stars%3A%3E0&s=stars&type=Repositories"
    static let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
        }()
    
    static let noCacheHeader: Alamofire.HTTPHeaders = ["Cache-Control": "no-cache"]
}
