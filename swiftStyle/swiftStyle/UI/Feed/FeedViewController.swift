//
//  FeedViewController.swift
//  swiftStyle
//
//  Created by Qing Zhang on 11/24/16.
//  Copyright © 2016 Qing Zhang. All rights reserved.
//

import UIKit
import SwiftyJSON

class FeedViewController: UIViewController {
    var entityArray :[FeedEntity] = []
    var tableView :UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        title = "Feed"
        setupViews()
        buildTestDataThen(){
            self.tableView.reloadData()
        }
    }

    func setupViews() {
        tableView = {
            let tv = UITableView(frame: view.bounds)
            tv.dataSource = self
            tv.delegate = self
            self.view.addSubview(tv)
            
            tv.register(FeedCell.self, forCellReuseIdentifier: "feedCell")
            return tv
        }()
    }
    
    func buildTestDataThen(_ thenCallback: (()->Void)?) {
        
        DispatchQueue.global().async {
            if let path = Bundle.main.path(forResource: "data", ofType: "json") {
                do {
                    let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                    let jsonObj = JSON(data: data)
                    if jsonObj != JSON.null {
                        let feedDics = jsonObj["feed"].arrayValue
                        self.entityArray = feedDics.map({
                            return FeedEntity($0.dictionaryObject as? [String:String])
                        })
                    } else {
                        print("Could not get json from file, make sure that file contains valid json.")
                    }
                } catch let error {
                    print(error.localizedDescription)
                }
            } else {
                print("Invalid filename/path.")
            }
            DispatchQueue.main.async {
                if let callback = thenCallback {
                    callback()
                }
            }
        }
    }
    
    func printEntityArray() {
       _ = entityArray.map { (feedEntity) -> Void in
            print(feedEntity)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension FeedViewController :UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entityArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell", for: indexPath) as! FeedCell
        if indexPath.row >= 0 && indexPath.row < entityArray.count {
            cell.feedEntity = entityArray[indexPath.row]
        }
        
        return cell
    }
}

extension FeedViewController :UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
