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
let REMAIN_STAT_KOR = ["충분", "보통", "부족", "품절", "판매중지"]
let REMAIN_STAT_MAP = [REMAIN_STAT[0]: REMAIN_STAT_KOR[0],
                       REMAIN_STAT[1]: REMAIN_STAT_KOR[1],
                       REMAIN_STAT[2]: REMAIN_STAT_KOR[2],
                       REMAIN_STAT[3]: REMAIN_STAT_KOR[3],
                       REMAIN_STAT[4]: REMAIN_STAT_KOR[4]]

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
