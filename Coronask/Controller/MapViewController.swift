//
//  MapViewController.swift
//  Coronask
//
//  Created by kpugame on 2020/06/09.
//  Copyright © 2020 Gurnwoo Kim. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var decoder = JSONDecoder()
    var store_result: STORE_RESULT = STORE_RESULT(count: 0, stores: [])
    let main_url: String = "https://8oi9s0nnth.apigw.ntruss.com/corona19-masks/v1/storesByGeo/json?"
    
    let LCManager = CLLocationManager()
    var lat: Double = 33.0
    var lng: Double = 124.0
    var rad: Int = 3000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        LCManager.delegate = self
        LCManager.desiredAccuracy = kCLLocationAccuracyBest
        LCManager.requestWhenInUseAuthorization()
        
        mapView.showsUserLocation = true
        mapView.delegate = self
        
        LCManager.startUpdatingLocation()
    }
        func centerMapOnLocation(location: CLLocation) {
            let regionRadius: CLLocationDistance = 1000
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        centerMapOnLocation(location: location)
        lat = location.coordinate.latitude
        lng = location.coordinate.longitude
        parseJson()
        for info in store_result.stores {
            let remain_stat = ((info.remain_stat) != nil) ? info.remain_stat! : "정보없음"
            let anno = Anno(title: info.name
                , _subtitle: remain_stat, coord: CLLocationCoordinate2D(latitude: CLLocationDegrees(info.lat), longitude: CLLocationDegrees(info.lng)))
            mapView.addAnnotation(anno)
        }
        
        LCManager.stopUpdatingLocation()
    }
    
    func parseJson() {
        let url = (main_url + "lat=\(lat)&lng=\(lng)&m=\(rad)").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        guard let complete_url = URL(string: url) else {
            print("ERROR : complete_url")
            return
        }
        
        var jsonData: Data?
        do {
            jsonData = try String(contentsOf: complete_url).data(using: .utf8)
        } catch {}
        
        if let dat = jsonData {
            do {
                store_result = try JSONDecoder().decode(STORE_RESULT.self, from: dat)
            } catch {
                print("ERROR : JSONDecoder().decode")
                return
            }
        } else {
            print("ERROR : string to data")
            return }
    }
}
