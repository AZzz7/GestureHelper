//
//  GestureBasicTableViewController.swift
//  GestureHelper
//
//  Created by AZ on 2018/7/24.
//  Copyright © 2018年 AZ. All rights reserved.
//

import UIKit

class GestureBasicTableViewController: UITableViewController {

    private var mCellTitles : Array<String> = ["Add Remote Basic Gestures(Select/Menu/PlayPause)","Add Touch Surface Gestures(Swipe,SignleTap)", "Add Custom Define Gestures(Left Or Right Long Press)","Add All Gestures"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return mCellTitles.count
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        cell.textLabel?.text = mCellTitles[indexPath.row]
        return cell
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let respondVC = GesutreRespndViewController()
        respondVC.index = indexPath.row
        navigationController?.pushViewController(respondVC, animated: true)
    }

}
