//
//  TableRefreshViewController.swift
//  swiftStyle
//
//  Created by Qing Zhang on 11/20/16.
//  Copyright © 2016 Qing Zhang. All rights reserved.
//

import UIKit
import AFNetworking
import SwiftyJSON

class CellItem : NSObject {
    let firstName, lastName, phoneNum :String
    
    init(_ first: String, _ last: String, _ phone: String) {
        firstName = first
        lastName = last
        phoneNum = phone
        
        super.init()
    }
    
    var name : String {
        get {
            return firstName + " " + lastName
        }
    }
}

class TableRefreshViewController: BaseViewController {
    var tableView :UITableView!
    var resultArray :[CellItem] = []
    var manager :AFHTTPSessionManager!
    var httpUrl :String = "http://192.168.93.167:10001/api/contacts/refresh"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        manager = AFHTTPSessionManager()
        setupViews()
    }

    func setupViews(){
        tableView = UITableView(frame: self.view.bounds)
        tableView.backgroundColor = RGB(242, 242, 242)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        
        addPullToRefreshForScrollView(tableView, refreshSel: #selector(refresh))
        refresh()
    }
    
    func networkRequest() {
        manager = AFHTTPSessionManager()
        manager.get(httpUrl, parameters: nil,
                    progress: nil,
                    success: {(operation :URLSessionDataTask, responseObject :Any?) -> Void in
                        print("JSON: " + responseObject.debugDescription)
                        self.parseJSON(responseObject as! NSArray)
                        self.tableView.reloadData()
                    },
                    failure: {(operation :URLSessionDataTask?, err: Error) -> Void in
                        print("Error: " + err.localizedDescription)
                    })
    }
    
    func parseJSON(_ arrayFromNetworking: NSArray) {
        var tmpArray :[CellItem] = []
        for var obj in arrayFromNetworking as! [[String: String]] {
            let item = CellItem(obj["firstName"]!, obj["lastName"]!, obj["phoneNumber"]!)
            tmpArray.append(item)
        }
        resultArray = tmpArray
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension TableRefreshViewController {
    func refresh() {
        manager.get(httpUrl, parameters: nil,
            progress: nil,
            success: {(operation :URLSessionDataTask, responseObject :Any?) -> Void in
            print("JSON: " + responseObject.debugDescription)
            self.parseJSON(responseObject as! NSArray)
            self.tableView.reloadData()
                
            self.endRefreshing(self.tableView)
            },
            failure: {(operation :URLSessionDataTask?, err: Error) -> Void in
            self.endRefreshing(self.tableView)
            print("Error: " + err.localizedDescription)
            })
    }
}

extension TableRefreshViewController :UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "cell")
        let item :CellItem = resultArray[indexPath.row]
        cell.textLabel?.text = item.name
        cell.detailTextLabel?.text = item.phoneNum
        
        return cell;
    }
}

extension TableRefreshViewController :UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false);
    }
}



