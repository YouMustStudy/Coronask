//
//  DetailController.swift
//  Coronask
//
//  Created by kpugame on 2020/05/26.
//  Copyright © 2020 Gurnwoo Kim. All rights reserved.
//

import UIKit

class MaskDetailController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        let retval = 1
        return retval
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.value2, reuseIdentifier: nil)
        switch (indexPath.row)
        {
        case 0:
            cell.textLabel?.text = "이름"
            cell.detailTextLabel?.text = "더미약국"
            break
        case 1:
            cell.textLabel?.text = "재고현황"
            cell.detailTextLabel?.text = "~~개"
            break
        case 2:
            cell.textLabel?.text = "주소"
            cell.detailTextLabel?.text = "~~"
            break
            
        default: break
        }
        return cell
    }
}
