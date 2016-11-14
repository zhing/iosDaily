//
//  MainViewController.swift
//  MyRoute
//
//  Created by xiaoming han on 14-7-21.
//  Copyright (c) 2014 AutoNavi. All rights reserved.
//

import UIKit

let APIKey = "239c18e5ca7eeefe7956278ed922a326"

class MainViewController: UIViewController, MAMapViewDelegate {
    
    var mapView: MAMapView!
    var _isRecording :Bool = false
    var locationButton: UIButton!
    var searchButton: UIButton!
    var imageLocated: UIImage!
    var imageNotLocate: UIImage!
    var tipView: TipView!
    var statusView: StatusView!
    var currentRoute: Route?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.white
        self.edgesForExtendedLayout = UIRectEdge.bottom
        
        AMapServices.shared().apiKey = APIKey
        
        initToolBar()
        initMapView()
        initTipView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tipView!.frame = CGRect(x: 0, y: view.bounds.height - 30, width: view.bounds.width, height: 30)
    }

    //MARK:- Initialization
    
    func initMapView() {
        
        mapView = MAMapView(frame: self.view.bounds)
        mapView.delegate = self
        self.view.addSubview(mapView)
        self.view.sendSubview(toBack: mapView)
        
        mapView.isShowsUserLocation = true
        mapView.userTrackingMode = MAUserTrackingMode.follow
        mapView.pausesLocationUpdatesAutomatically = false
//        mapView.allowsBackgroundLocationUpdates = true
        mapView.distanceFilter = 10.0
        mapView.desiredAccuracy = kCLLocationAccuracyBestForNavigation
    }
    
    func initToolBar() {
        
        let rightButtonItem: UIBarButtonItem = UIBarButtonItem.init(title: "details", style: UIBarButtonItemStyle.plain, target: self, action: #selector(actionHistory))
        navigationItem.rightBarButtonItem = rightButtonItem
        
        let topButton: UIButton = UIButton.init(type: UIButtonType.custom)
        topButton.bounds = CGRect.init(x: 0, y: 0, width: 30, height: 30)
        topButton.setImage(UIImage(named: "icon_play.png")?.reSizeImage(size: CGSize.init(width: 30, height: 30)).imageWithTintColor(tintColor: UIColor.red), for: UIControlState.normal)
        topButton.setImage(UIImage(named: "icon_stop.png")?.reSizeImage(size: CGSize.init(width: 30, height: 30)).imageWithTintColor(tintColor: UIColor.red), for: UIControlState.selected)
        topButton.imageView?.contentMode = UIViewContentMode.center
        topButton.addTarget(self, action: #selector(actionRecordAndStop), for: UIControlEvents.touchUpInside)
        self.navigationItem.titleView = topButton
        
        imageLocated = UIImage(named: "location_yes.png")?.imageWithTintColor(tintColor: RGB(21, 126, 251))
        imageNotLocate = UIImage(named: "location_no.png")?.imageWithTintColor(tintColor: RGB(21, 126, 251))
        
        locationButton = UIButton(frame: CGRect(x: 20, y: view.bounds.height - 80, width: 40, height: 40))
        
        locationButton!.autoresizingMask = [UIViewAutoresizing.flexibleRightMargin, UIViewAutoresizing.flexibleTopMargin]
        locationButton!.backgroundColor = UIColor.white
        locationButton!.layer.cornerRadius = 5
        locationButton!.layer.shadowColor = UIColor.black.cgColor
        locationButton!.layer.shadowOffset = CGSize(width: 5, height: 5)
        locationButton!.layer.shadowRadius = 5
        
        locationButton!.addTarget(self, action: #selector(MainViewController.actionLocation(sender:)), for: UIControlEvents.touchUpInside)
        
        locationButton!.setImage(imageNotLocate, for: UIControlState.normal)
        locationButton!.setImage(imageLocated, for: UIControlState.selected)
        
        view.addSubview(locationButton!)
        
        //
        searchButton = UIButton(frame: CGRect(x: view.bounds.width - 60, y: view.bounds.height - 80, width: 40, height: 40))
        searchButton!.autoresizingMask = [UIViewAutoresizing.flexibleLeftMargin, UIViewAutoresizing.flexibleTopMargin]
        searchButton!.backgroundColor = UIColor.white
        searchButton!.layer.cornerRadius = 5
        searchButton!.setImage(UIImage(named:"search.png")?.reSizeImage(size: CGSize.init(width: 30, height: 30)).imageWithTintColor(tintColor: RGB(21, 126, 251)), for: UIControlState.normal)
        searchButton!.imageView?.contentMode = UIViewContentMode.center
        
        searchButton!.addTarget(self, action: #selector(MainViewController.actionSearch(sender:)), for: UIControlEvents.touchUpInside)
        view.addSubview(searchButton!)
    }
    
    func initTipView() {
        tipView = TipView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 30))
        view.addSubview(tipView!)
        statusView = StatusView(frame: CGRect(x: 5, y: 35, width: 150, height: 150))
        
        statusView!.showStatusInfo(info: nil)
        
        view.addSubview(statusView!)
        tipView.isHidden = true
    }
    
    var isRecording: Bool {
        get { return _isRecording}
        set {
            if newValue {
                tipView?.isHidden = true
            } else {
                tipView?.isHidden = false
            }
            
            _isRecording = newValue
        }
    }
    
    //MARK:- Actions
    
    func stopLocationIfNeeded() {
        if !isRecording {
            print("stop location")
            mapView!.setUserTrackingMode(MAUserTrackingMode.none, animated: false)
            mapView!.isShowsUserLocation = false
        }
    }
    
    func actionHistory() {
        print("actionHistory")
        
        let historyController = RecordViewController(nibName: nil, bundle: nil)
        historyController.title = "Records"
        
        navigationController!.pushViewController(historyController, animated: true)
    }
    
    func actionRecordAndStop() {
        print("actionRecord")
        
        isRecording = !isRecording
        
        if isRecording {
            
            showTip(tip: "Start recording...")
            (self.navigationItem.titleView as! UIButton).isSelected = true
            
            if currentRoute == nil {
                currentRoute = Route()
            }
            
            addLocation(location: mapView!.userLocation.location)
        }
        else {
            (self.navigationItem.titleView as! UIButton).isSelected = false

            addLocation(location: mapView!.userLocation.location)
            hideTip()
            saveRoute()
        }

    }
    
    func actionLocation(sender: UIButton) {
        print("actionLocation")
        
        if mapView!.userTrackingMode == MAUserTrackingMode.follow {
            
            mapView!.setUserTrackingMode(MAUserTrackingMode.none, animated: false)
            mapView!.isShowsUserLocation = false
        }
        else {
            mapView!.setUserTrackingMode(MAUserTrackingMode.follow, animated: true)
        }
    }
    
    func actionSearch(sender: UIButton) {
        
        let searchDemoController = SearchViewController(nibName: nil, bundle: nil)
        navigationController!.pushViewController(searchDemoController, animated: true)
    }
    
    //MARK:- Helpers
    
    func addLocation(location: CLLocation?) {
        let success = currentRoute!.addLocation(location: location)
        if success {
            showTip(tip: "locations: \(currentRoute!.locations.count)")
        }
    }
    
    func saveRoute() {

        if currentRoute == nil {
            return
        }
        
        let name = currentRoute!.title()
        
        let path = FileHelper.recordPathWithName(name: name)
        
//        println("path: \(path)")
        
        NSKeyedArchiver.archiveRootObject(currentRoute!, toFile: path!)
        
        currentRoute = nil
    }
    
    func showTip(tip: String?) {
        tipView!.showTip(tip: tip)
    }
    
    func hideTip() {
        tipView!.isHidden = true
    }
    
    //MARK:- MAMapViewDelegate
    
    func mapView(_ mapView: MAMapView!, didUpdate userLocation: MAUserLocation!, updatingLocation: Bool) {
        
        if isRecording {
            // filter the result
            if userLocation.location.horizontalAccuracy < 80.0 {
                
                addLocation(location: userLocation.location)
            }
        }
        
        let location: CLLocation? = userLocation.location
        
        if location == nil {
            return
        }
        
        var speed = location!.speed
        if speed < 0.0 {
            speed = 0.0
        }
        
        let infoArray: [(String, String)] = [
            ("coordinate", NSString(format: "<%.4f, %.4f>", location!.coordinate.latitude, location!.coordinate.longitude) as String),
            ("speed", NSString(format: "%.2fm/s(%.2fkm/h)", speed, speed * 3.6) as String),
            ("accuracy", "\(location!.horizontalAccuracy)m"),
            ("altitude", NSString(format: "%.2fm", location!.altitude) as String)]
        
        statusView!.showStatusInfo(info: infoArray)
    }
    
    /** 
    - (void)mapView:(MAMapView *)mapView didChangeUserTrackingMode:(MAUserTrackingMode)mode animated:(BOOL)animated;
    */
    func mapView(_ mapView: MAMapView, didChange mode: MAUserTrackingMode, animated: Bool) {
        if mode == MAUserTrackingMode.none {
            locationButton.isSelected = false
        } else {
            locationButton.isSelected = true
        }
    }

}
