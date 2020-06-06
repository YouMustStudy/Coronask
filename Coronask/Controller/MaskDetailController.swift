//
//  DetailController.swift
//  Coronask
//
//  Created by kpugame on 2020/05/26.
//  Copyright © 2020 Gurnwoo Kim. All rights reserved.
//

import UIKit

class MaskDetailController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var store_info: STORE_INFO = STORE_INFO(addr: "", code: "", created_at: "", lat: 0.0, lng: 0.0, name: "", remain_stat: "", stock_at: "", type: "")
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
        return 5
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: nil)
        switch (indexPath.row) {
        case 0:
            cell.textLabel?.text = "이름"
            cell.detailTextLabel?.text = store_info.name
            break
            
        case 1:
            cell.textLabel?.text = "주소"
            cell.detailTextLabel?.text = store_info.addr
            break
        case 2:
            cell.textLabel?.text = "재고상황"
            cell.detailTextLabel?.text = (store_info.remain_stat == nil) ? "정보없음" : store_info.remain_stat
            break
            
        case 3:
            cell.textLabel?.text = "입고시간"
            cell.detailTextLabel?.text = (store_info.stock_at == nil) ? "정보없음" : store_info.stock_at
            break
            
        case 4:
            cell.textLabel?.text = "갱신시간"
            cell.detailTextLabel?.text = (store_info.created_at == nil) ? "정보없음" : store_info.created_at
            break
        default:
            break
        }
        return cell
    }
}
