//
//  DetailController.swift
//  Coronask
//
//  Created by kpugame on 2020/05/26.
//  Copyright © 2020 Gurnwoo Kim. All rights reserved.
//

import UIKit
import MapKit

class MaskDetailController: UIViewController, UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    var store_info: STORE_INFO = STORE_INFO(addr: "", code: "", created_at: "", lat: 0.0, lng: 0.0, name: "", remain_stat: "", stock_at: "", type: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mapView.delegate = self
        let anno = Anno(title: store_info.name, _subtitle: store_info.addr, coord: CLLocationCoordinate2D(latitude: CLLocationDegrees(store_info.lat), longitude: CLLocationDegrees(store_info.lng)))
        mapView.addAnnotation(anno)
        centerMapOnLocation(location: CLLocation(latitude: CLLocationDegrees(store_info.lat), longitude: CLLocationDegrees(store_info.lng)))
    }
    
    //TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        let retval = 1
        return retval
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: nil)
        switch (indexPath.row) {
        case 0:
            cell.textLabel?.text = "이름"
            cell.detailTextLabel?.text = store_info.name
            break
            
        case 1:
            cell.textLabel?.text = "주소"
            cell.detailTextLabel?.text = store_info.addr
            break
        case 2:
            cell.textLabel?.text = "재고상황"
            cell.detailTextLabel?.text = ((store_info.remain_stat) != nil) ? REMAIN_STAT_MAP[store_info.remain_stat!] : "정보없음"
            break
            
        case 3:
            cell.textLabel?.text = "입고시간"
            cell.detailTextLabel?.text = (store_info.stock_at == nil) ? "정보없음" : store_info.stock_at
            break
            
        case 4:
            cell.textLabel?.text = "갱신시간"
            cell.detailTextLabel?.text = (store_info.created_at == nil) ? "정보없음" : store_info.created_at
            break
        default:
            break
        }
        return cell
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let regionRadius: CLLocationDistance = 500
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let anno = annotation as? Anno else { return nil }
        let identifier = "marker"
        var view: MKMarkerAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
            dequeuedView.annotation = anno
            view = dequeuedView
        } else {
            view = MKMarkerAnnotationView(annotation: anno, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
        }
        return view
    }
}
