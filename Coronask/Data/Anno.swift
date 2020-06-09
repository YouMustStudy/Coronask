//
//  Anno.swift
//  Coronask
//
//  Created by kpugame on 2020/06/09.
//  Copyright © 2020 Gurnwoo Kim. All rights reserved.
//

import Foundation
import MapKit
import Contacts

class Anno : NSObject, MKAnnotation {
    let title: String?
    let _subtitle: String
    var coordinate: CLLocationCoordinate2D
    init(title: String, _subtitle: String, coord: CLLocationCoordinate2D) {
        self.title = title
        self._subtitle = _subtitle
        self.coordinate = coord
        super.init()
    }
    var subtitle: String? {
        return _subtitle
    }
    func mapItem() -> MKMapItem {
        let addressDict = [CNPostalAddressStreetKey: subtitle!]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        return mapItem
    }
}
