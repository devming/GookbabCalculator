//
//  OpenSourceViewController.swift
//  GookBabCalculator
//
//  Created by Minki on 2019/10/26.
//  Copyright © 2019 devming. All rights reserved.
//

import UIKit

class OpenSourceViewController: UIViewController {
    
    @IBOutlet weak var listTableView: UITableView!
    
    let list = ["Google-Mobile-Ads-SDK", "Firebase/Analytics", "Firebase/AdMob"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listTableView.dataSource = self
    }
}

extension OpenSourceViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "openCell", for: indexPath)
        
        cell.textLabel?.text = list[indexPath.row]
        
        return cell
    }
}
