//
//  SearchViewController.swift
//  MyRoute
//
//  Created by xiaoming han on 15/1/6.
//  Copyright (c) 2015年 AutoNavi. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, MAMapViewDelegate, AMapSearchDelegate, UISearchBarDelegate, UISearchResultsUpdating, UITableViewDataSource, UITableViewDelegate, UISearchControllerDelegate {

    var mapView: MAMapView!
    var userLocationCatched :Bool = false
    var tableView: UITableView!
    var search: AMapSearchAPI!
    var searchBar: UISearchBar!
    var searchResultController: UISearchController!
    var searchPOIs :[AMapPOI] = []
    var searchPlaceholder :AMapPOI!
    var city :String?
    var targetPOI :AMapPOI?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Search Demo"
        self.edgesForExtendedLayout = UIRectEdge.bottom
        
        initMapView()
        initTableView()
        initSearch()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mapView.isShowsUserLocation = true
        mapView.userTrackingMode = MAUserTrackingMode.follow
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if (searchResultController?.isActive)! {
            tableView.frame = CGRect.init(origin: CGPoint.init(x: 0, y: 20), size: view.bounds.size)
        } else {
            tableView.frame = CGRect.init(x: 0, y: 0, width: view.bounds.width, height: 44)
        }
    }
    
    //MARK:- Helpers
    
    func initMapView() {
        mapView = MAMapView(frame: self.view.bounds)
        mapView.delegate = self
        self.view.addSubview(mapView!)
    }
    
    func initTableView() {
        tableView = UITableView.init(frame: self.view.bounds, style: UITableViewStyle.plain)
        tableView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.7)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: view.bounds.width, height: 0.1))
        view.addSubview(tableView)
    }
    
    func initSearch() {
        search = AMapSearchAPI()
        search.delegate = self
        
        searchBar = UISearchBar()
        searchBar.searchBarStyle = UISearchBarStyle.default
        searchBar.delegate = self
        view.addSubview(searchBar)
        
        searchResultController = ({
            let controller = UISearchController.init(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.delegate = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.delegate = self
            controller.searchBar.sizeToFit()
            
            return controller
        })()
        
        searchPlaceholder = AMapPOI()
        tableView.tableHeaderView = searchResultController.searchBar
        view.addSubview(searchBar)
    }
    
    func searchReGeocodeWithCoordinate(coordinate: CLLocationCoordinate2D!) {
        let regeo: AMapReGeocodeSearchRequest = AMapReGeocodeSearchRequest()
        
        regeo.location = AMapGeoPoint.location(withLatitude: CGFloat(coordinate.latitude), longitude: CGFloat(coordinate.longitude))
        print("regeo :\(regeo)")
        
        self.search!.aMapReGoecodeSearch(regeo)
    }
    
    func searchPOI(keyword: String) {
        let req :AMapPOIKeywordsSearchRequest = AMapPOIKeywordsSearchRequest.init()
        req.keywords = keyword
        req.city = self.city
        req.requireExtension = true
        
        self.search!.aMapPOIKeywordsSearch(req)
    }
    
    func addAnnotation(_ annotation: MAPointAnnotation) {
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(annotation)
        mapView.setCenter(annotation.coordinate, animated: false)
        
        let region = MACoordinateRegionMakeWithDistance(annotation.coordinate, 1000, 1000)
        mapView.setRegion(region, animated: true)
    }
    
    func parseAMapAddressComponent(addressComponent: AMapAddressComponent?) {
        city = addressComponent?.city
        if city == nil || city!.lengthOfBytes(using: String.Encoding.utf8) == 0 {
            city = addressComponent?.province
        }
    }
    
    //MARK:- MAMapViewDelegate
    
    func mapView(_ mapView: MAMapView!, didSingleTappedAt coordinate: CLLocationCoordinate2D) {
        searchReGeocodeWithCoordinate(coordinate: coordinate)
    }
    
    func mapView(_ mapView: MAMapView!, didUpdate userLocation: MAUserLocation!, updatingLocation: Bool) {
        if !userLocationCatched {
            searchReGeocodeWithCoordinate(coordinate: userLocation.coordinate)
        }
    }
    
    //MARK:- AMapSearchDelegate
    
    func aMapSearchRequest(_ request: Any!, didFailWithError error: Error!) {
        print("request :\(request), error: \(error)")
    }
    
    func onReGeocodeSearchDone(_ request: AMapReGeocodeSearchRequest, response: AMapReGeocodeSearchResponse) {
        
        print("request :\(request)")
        print("response :\(response)")
        
        if (response.regeocode != nil) {
            let coordinate = CLLocationCoordinate2DMake(Double(request.location.latitude), Double(request.location.longitude))
            
            let annotation = MAPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = response.regeocode.formattedAddress
            annotation.subtitle = response.regeocode.addressComponent.province
            if !userLocationCatched {
                parseAMapAddressComponent(addressComponent: response.regeocode.addressComponent)
                userLocationCatched = true
            }
            self.addAnnotation(annotation)
        }
    }
    
    func onPOISearchDone(_ request: AMapPOISearchBaseRequest!, response: AMapPOISearchResponse!) {
        
        if response.pois != nil {
            let pois = response.pois as [AMapPOI]
            searchPOIs = pois
        }
        print(searchPOIs.count)
        tableView.reloadData()
    }
    
    //MARK:- UISearchBarDelegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let text = searchBar.text
        if text == nil || text!.lengthOfBytes(using: String.Encoding.utf8) == 0 {
            searchPOIs.removeAll()
            return
        }
        self.searchPOI(keyword: text!)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let text = searchBar.text
        if text == nil || text!.lengthOfBytes(using: String.Encoding.utf8) == 0 {
            return
        }
        self.searchPOI(keyword: text!)
    }
    
    //MARK:- UISearchResultsUpdating
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    //MARK:- UITableViewDataSource
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchPOIs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: UITableViewCellStyle.subtitle, reuseIdentifier: "reuseduser")
        cell.backgroundColor = tableView.backgroundColor
        
        var poi:AMapPOI!
        if indexPath.row < searchPOIs.count && indexPath.row >= 0 {
            poi = searchPOIs[indexPath.row]
        } else {
            poi = searchPlaceholder
        }
        
        if poi == searchPlaceholder {
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.textLabel?.text = "正在搜索..."
            return cell
        }
        
        cell.textLabel?.text = poi.name;
        cell.textLabel?.textColor = UIColor.black;
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16);
        cell.detailTextLabel?.textColor = RGB(102, 102, 102);
        cell.detailTextLabel?.text = poi.address;
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 12);
        cell.selectionStyle = UITableViewCellSelectionStyle.default;
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)

        if indexPath.row >= 0 && indexPath.row < searchPOIs.count {
            targetPOI = searchPOIs[indexPath.row]
            searchResultController.isActive = false
        }
    }
    
    //MARK:- UISearchControllerDelegate
    func willPresentSearchController(_ searchController: UISearchController) {
        targetPOI = nil
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        if targetPOI != nil {
            let annotation = MAPointAnnotation.init()
            let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(Double((targetPOI?.location.latitude)!), Double((targetPOI?.location.longitude)!))
            annotation.coordinate = coordinate
            self.addAnnotation(annotation)
        }
        
        searchPOIs.removeAll()
        tableView.reloadData()
    }
}
