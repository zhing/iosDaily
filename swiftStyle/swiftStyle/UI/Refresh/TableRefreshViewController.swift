//
//  TableRefreshViewController.swift
//  swiftStyle
//
//  Created by Qing Zhang on 11/20/16.
//  Copyright © 2016 Qing Zhang. All rights reserved.
//

import UIKit
import SwiftyJSON

class CellItem : NSObject {
    let firstName, lastName, phoneNum :String?
    
    init(_ dic :[String:String]?) {
        firstName = dic?["firstName"]
        lastName = dic?["lastName"]
        phoneNum = dic?["phoneNumber"]
        
        super.init()
    }
    
    var name : String {
            return firstName ?? "" + " " + (lastName ?? "")
    }
}

class TableRefreshViewController: BaseViewController {
    var tableView :IGTableView!
    var emptyView :EmptyDataView!
    var resultArray :[CellItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }

    func setupViews(){
        tableView = {
            let tableView = IGTableView(frame: self.view.bounds, style: UITableViewStyle.plain)
            tableView.backgroundColor = RGB(242, 242, 242)
            tableView.dataSource = self
            tableView.delegate = self
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
            view.addSubview(tableView)
            return tableView
        }()
        
        emptyView = EmptyDataView(frame: tableView.frame)
        emptyView.emptyDelegate = self
        emptyView.setImage("empty.png", text: "没有新数据哟", buttonTitle: "刷新")
        tableView.setBlankView(emptyView)
    }
    
    func parseJSON(_ responseObj: JSON) -> [CellItem]{
        let arrayFromNetworking = responseObj.arrayValue
        return arrayFromNetworking.map {
            let obj = $0.dictionaryObject as? [String:String]
            return CellItem(obj)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension TableRefreshViewController:EmptyDataViewActionDelegate {
    func didClickEmptyButton() {
        addPullToRefreshForScrollView(tableView, refreshSel: #selector(refresh))
        refresh()
    }
}

extension TableRefreshViewController {
    func refresh() {
        _ = APIService.GET("api/contacts/refresh", params: nil, success: {
            if let jsonObj = $0, jsonObj != JSON.null {
                let tmpArr = self.parseJSON(jsonObj)
                self.resultArray = tmpArr
                self.tableView.reloadData()
                
                self.endRefreshing(self.tableView)
                if tmpArr.count >= 20 {
                    self.addLoadMoreForTableView(self.tableView, loadMoreSel: #selector(self.loadMore))
                } else {
                    self.removeLoadMoreForTableView(self.tableView)
                }
            }
        }, failure: {
            self.endRefreshing(self.tableView)
            print("Error: " + $0)
        })
    }
        
    func loadMore() {
        _ = APIService.GET("api/contacts/refresh", params: nil, success: {
            if let jsonObj = $0, jsonObj != JSON.null {
                let tmpArr = self.parseJSON(jsonObj)
                self.resultArray.append(contentsOf: tmpArr)
                self.tableView.reloadData()
                
                self.endLoadMore(self.tableView)
                if tmpArr.count < 20 {
                    self.removeLoadMoreForTableView(self.tableView)
                }
            }
        }, failure: {
            self.endLoadMore(self.tableView)
            print("Error: " + $0)
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



