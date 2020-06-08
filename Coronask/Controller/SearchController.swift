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
    @IBOutlet weak var searchFooter: SearchFooter!
    @IBOutlet weak var searchView: UIView!
    var isSearch: Bool = false
    var isFirst: Bool = false
    var decoder = JSONDecoder()
    var store_result: STORE_RESULT = STORE_RESULT(address: "", count: 0, stores: [])
    let main_url: String = "https://8oi9s0nnth.apigw.ntruss.com/corona19-masks/v1/storesByAddr/json?address="
    var selected_row: Int = 0
    
    //SearchController
    var filteredData = [STORE_INFO]()
    let searchController = UISearchController(searchResultsController: nil)
    let filterScope = ["모두", "약국", "우체국", "농협"]
    var selected_scope:Int = 0
    
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
        
        //Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        searchController.searchBar.scopeButtonTitles = filterScope
        searchController.searchBar.delegate = self

        resultTableView.tableFooterView = searchFooter
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
        if isFiltering() {
            searchFooter.setIsFilteringToShow(filteredItemCount: filteredData.count, of: store_result.count)
            return filteredData.count
        } else {
            searchFooter.setNotFiltering()
            return store_result.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        let selected_store:STORE_INFO
        if isFiltering() {
            selected_store = filteredData[indexPath.row]
        } else {
            selected_store = store_result.stores[indexPath.row]
        }
        cell.textLabel?.text = selected_store.name
        cell.detailTextLabel?.text = "재고현황 : "
        cell.detailTextLabel?.text? += ((selected_store.remain_stat) != nil) ? selected_store.remain_stat! : "정보없음"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selected_row = indexPath.row
        performSegue(withIdentifier: "SegueMaskDetail", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SegueMaskDetail" {
            if let maskdetailcontroller = segue.destination as? MaskDetailController {
                let selected_store:STORE_INFO
                if isFiltering() {
                    selected_store = filteredData[selected_row]
                } else {
                    selected_store = store_result.stores[selected_row]
                }
                maskdetailcontroller.store_info = selected_store
            }
        }
    }
    
    //Search Controller
    func filterContentForSearchText(_ searchText: String, scope: Int = 0) {
        filteredData = store_result.stores.filter({( info : STORE_INFO) -> Bool in
            let doesCategoryMatch = (scope == 0) || (info.type == "0\(scope)")
            if searchBarIsEmpty() {
                return doesCategoryMatch
            } else {
                return doesCategoryMatch && info.name.lowercased().contains(searchText.lowercased())
            }
        })
        resultTableView.reloadData()
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool {
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (!searchBarIsEmpty() || searchBarScopeIsFiltering)
    }
}

extension SearchController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        selected_scope = selectedScope
        filterContentForSearchText(searchBar.text!, scope: selected_scope)
    }
}

extension SearchController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!, scope: selected_scope)
    }
    
}
