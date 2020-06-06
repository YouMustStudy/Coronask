//
//  SalesClass.swift
//  Coronask
//
//  Created by kpugame on 2020/06/06.
//  Copyright © 2020 Gurnwoo Kim. All rights reserved.
//

import Foundation

struct STORE_RESULT : Codable {
    let address: String
    let count: Int
    let stores: [STORE_INFO]
}

struct STORE_INFO : Codable {
    let addr: String
    let code: String
    let created_at: String?
    let lat: Float
    let lng: Float
    let name: String
    let remain_stat: String?
    let stock_at: String?
    let type: String
}
