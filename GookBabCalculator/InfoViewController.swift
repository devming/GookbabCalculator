//
//  InfoViewController.swift
//  GookBabCalculator
//
//  Created by Minki on 2019/10/26.
//  Copyright © 2019 devming. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {
    
    @IBOutlet weak var infoTableView: UITableView!
    var list: [String] = [
        "오픈소스 라이선스",
        "개발자 이메일: cmk330@naver.com",
        "앱 리뷰 쓰기"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        infoTableView.dataSource = self
        infoTableView.delegate = self
    }
    
}

extension InfoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "infoBasicCell", for: indexPath)
        
        cell.textLabel?.text = list[indexPath.row]
        
    
        return cell
    }

}

extension InfoViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            performSegue(withIdentifier: "opensourceSegue", sender: tableView.cellForRow(at: indexPath))
        } else if indexPath.row == 2 {
            if let reviewURL = URL(string: "itms-apps://itunes.apple.com/app/itunes-u/id\(1484660593)?ls=1&mt=8&action=write-review"), UIApplication.shared.canOpenURL(reviewURL) { // 유효한 URL인지 검사합니다.
                if #available(iOS 10.0, *) { //iOS 10.0부터 URL를 오픈하는 방법이 변경 되었습니다.
                    UIApplication.shared.open(reviewURL, options: [:], completionHandler: nil)
                } else { UIApplication.shared.openURL(reviewURL) }
                
            }
        }
    }
}
