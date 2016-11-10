//
//  AMapViewController.swift
//  swiftStyle
//
//  Created by Qing Zhang on 11/10/16.
//  Copyright © 2016 Qing Zhang. All rights reserved.
//

import UIKit
import MapKit

//let APIKey = "239c18e5ca7eeefe7956278ed922a326"

class AMapViewController: UIViewController, MAMapViewDelegate, AMapSearchDelegate {

    var mapView: MAMapView!
    var search: AMapSearchAPI!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "AMap"
        self.view.backgroundColor = UIColor.white
        AMapServices.shared().apiKey = APIKey
        
        initMapView()
        initSearch()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mapView.isShowsUserLocation = true
        mapView.userTrackingMode = MAUserTrackingMode.follow
    }
    
    func initMapView() {
        mapView = MAMapView(frame: self.view.bounds)
        mapView.delegate = self
        self.view.addSubview(mapView)
    }
    
    func initSearch() {
        search = AMapSearchAPI()
        search.delegate = self
    }
    
    //MARK:- MAMapViewDelegate
    func mapView(_ mapView: MAMapView!, didSingleTappedAt coordinate: CLLocationCoordinate2D) {
        // 长按地图触发回调，在长按点进行逆地理编码查询
        searchReGeocodeWithCoordinate(coordinate: coordinate)
    }
    
    func mapView(_ mapView: MAMapView!, didUpdate userLocation: MAUserLocation!, updatingLocation: Bool) {
        if updatingLocation {
            addAnnotation(coordinate: userLocation.coordinate)
        }
    }
    
    //MARK:- AMapSearchDelegate
    func aMapSearchRequest(_ request: Any!, didFailWithError error: Error!) {
        print("request :\(request), error: \(error)")
    }
    
    // 逆地理查询回调
    func onReGeocodeSearchDone(_ request: AMapReGeocodeSearchRequest, response: AMapReGeocodeSearchResponse) {
        
        print("response :\(response.formattedDescription())")
        
        if (response.regeocode != nil) {
            let coordinate = CLLocationCoordinate2DMake(Double(request.location.latitude), Double(request.location.longitude))
            
            let annotation = MAPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = response.regeocode.formattedAddress
            annotation.subtitle = response.regeocode.addressComponent.province
            self.addAnnotation(annotation: annotation)
        }
    }
    
    //MARK:- Helper
    func addAnnotation(coordinate: CLLocationCoordinate2D) {
        let annotation = MAPointAnnotation()
        annotation.coordinate = coordinate
        addAnnotation(annotation: annotation)
    }
    
    func addAnnotation(annotation: MAPointAnnotation) {
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(annotation)
        mapView.setCenter(annotation.coordinate, animated: true)
        let region = MACoordinateRegionMakeWithDistance(annotation.coordinate, 500, 500)
        mapView.setRegion(region, animated: true)
    }
    
    // 发起逆地理编码请求
    func searchReGeocodeWithCoordinate(coordinate: CLLocationCoordinate2D!) {
        let regeo: AMapReGeocodeSearchRequest = AMapReGeocodeSearchRequest()
        regeo.location = AMapGeoPoint.location(withLatitude: CGFloat(coordinate.latitude), longitude: CGFloat(coordinate.longitude))
        print("rego :\(regeo)")
        
        self.search!.aMapReGoecodeSearch(regeo)
    }
}
