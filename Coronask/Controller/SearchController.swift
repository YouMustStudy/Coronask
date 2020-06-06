//
//  SearchController.swift
//  Coronask
//
//  Created by kpugame on 2020/05/24.
//  Copyright © 2020 Gurnwoo Kim. All rights reserved.
//

import UIKit



class SearchController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var cityTextView: UITextField!
    @IBOutlet weak var resultTableView: UITableView!
    var isSearch: Bool = false
    var isFirst: Bool = false
    var decoder = JSONDecoder()
    var store_result: STORE_RESULT = STORE_RESULT(address: "", count: 0, stores: [])
    let main_url: String = "https://8oi9s0nnth.apigw.ntruss.com/corona19-masks/v1/storesByAddr/json?address="
    var selected_row: Int = 0
    
    @IBAction func ClickSearch()
    {
        let url = (main_url + cityTextView.text!).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        guard let complete_url = URL(string: url) else {
            print("ERROR : complete_url")
            return
        }
        
        var jsonData: Data?
        do {
            jsonData = try String(contentsOf: complete_url).data(using: .utf8)
        } catch {}
        
        if let dat = jsonData {
            do {
                store_result = try JSONDecoder().decode(STORE_RESULT.self, from: dat)
            } catch {
                print("ERROR : JSONDecoder().decode")
                return
            }
        } else {
            print("ERROR : string to data")
            return }
        
        if store_result.count > 0 { isSearch = true }
        else { isSearch = false }
        isFirst = true
        resultTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        isSearch = false
        cityTextView.text = "경기도 안양시 동안구 호계동"
    }
    
    //TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        var retval = 0
        if isSearch {
            resultTableView.separatorStyle = .singleLine
            retval = 1
            resultTableView.backgroundView = nil
        } else {
            let noDataLabel: UILabel = UILabel(frame: resultTableView.bounds)
            noDataLabel.text = (!isFirst) ? "구, 동까지 입력해주세요" : "검색결과없음"
            noDataLabel.textColor = UIColor.gray
            noDataLabel.textAlignment = .center
            resultTableView.backgroundView = noDataLabel
            resultTableView.separatorStyle = .none
        }
        return retval
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return store_result.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        cell.textLabel?.text = store_result.stores[indexPath.row].name
        cell.detailTextLabel?.text = "재고현황 : "
        cell.detailTextLabel?.text? += ((store_result.stores[indexPath.row].remain_stat) != nil) ? store_result.stores[indexPath.row].remain_stat! : "정보없음"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selected_row = indexPath.row
        performSegue(withIdentifier: "SegueMaskDetail", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SegueMaskDetail" {
            if let maskdetailcontroller = segue.destination as? MaskDetailController {
                maskdetailcontroller.store_info = store_result.stores[selected_row]
            }
        }
    }
}
