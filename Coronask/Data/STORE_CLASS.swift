//
//  SalesClass.swift
//  Coronask
//
//  Created by kpugame on 2020/06/06.
//  Copyright © 2020 Gurnwoo Kim. All rights reserved.
//

import Foundation
import MapKit

let REMAIN_STAT = ["plenty", "some", "few", "empty", "break"]
let REMAIN_STAT_MAP = [REMAIN_STAT[0]: "충분", REMAIN_STAT[1]: "보통", REMAIN_STAT[2]: "부족", REMAIN_STAT[3]: "품절", REMAIN_STAT[4]: "판매중지"]

struct STORE_RESULT : Codable {
    //let address: String
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
