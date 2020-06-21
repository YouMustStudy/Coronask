//
//  SearchController.swift
//  Coronask
//
//  Created by kpugame on 2020/05/24.
//  Copyright © 2020 Gurnwoo Kim. All rights reserved.
//

import UIKit
import Speech


class SearchController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var cityTextView: UITextField!
    @IBOutlet weak var resultTableView: UITableView!
    @IBOutlet weak var searchFooter: SearchFooter!
    @IBOutlet weak var MIC: UIButton!
    @IBOutlet weak var ChartBtn: UIBarButtonItem!
    
    var isSearch: Bool = false
    var isFirst: Bool = false
    var decoder = JSONDecoder()
    var store_result: STORE_RESULT = STORE_RESULT(count: 0, stores: [])
    let main_url: String = "https://8oi9s0nnth.apigw.ntruss.com/corona19-masks/v1/storesByAddr/json?address="
    var selected_row: Int = 0
    
    //SearchController
    var filteredData = [STORE_INFO]()
    let searchController = UISearchController(searchResultsController: nil)
    let filterScope = ["모두"] + REMAIN_STAT_KOR
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
        
        if store_result.count > 0 {
            isSearch = true
            ChartBtn.isEnabled = true
        }
        else {
            isSearch = false
            ChartBtn.isEnabled = false
        }
        isFirst = true
        resultTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        isSearch = false
        ChartBtn.isEnabled = false
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
        cell.detailTextLabel?.text = ((selected_store.remain_stat) != nil) ? REMAIN_STAT_MAP[selected_store.remain_stat!] : "정보없음"

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
        } else if segue.identifier == "SegueShowChart" {
            if let chartcontroller = segue.destination as? ChartViewController {
                var counts = [Int]()
                for i in 0..<4 {
                    counts.append(store_result.stores.filter {$0.remain_stat == REMAIN_STAT[i]}.count)
                }
                chartcontroller.counts = counts
            }
        }
    }
    
    //Speech Recognition
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ko-KR"))!
    private var speechRecognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var speechRecognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    private var isMIC: Bool = false
    private var isAuthorized: Bool = false
    
    @IBAction func MICAction(_ sender: Any) {
        if !isAuthorized {
            authoriseSR()
        }
        if !isMIC {
            isMIC = true
            MIC.setTitle("STOP", for: .normal)
            try! startSession()
        } else {
            stopListen()
        }
    }
    
    func stopListen() {
        isMIC = false
        MIC.setTitle("MIC", for: .normal)
        if audioEngine.isRunning {
            audioEngine.stop()
            speechRecognitionRequest?.endAudio()
        }
    }
    
    func startSession() throws {
        if let recognitionTask = speechRecognitionTask {
            recognitionTask.cancel()
            self.speechRecognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        speechRecognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        guard let recognitionRequest = speechRecognitionRequest else
        { fatalError("SFSpeechAudioBufferRecognitionRequest Object creation failed" )}
        
        let inputNode = audioEngine.inputNode
        recognitionRequest.shouldReportPartialResults = true
        
        speechRecognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
            var finished = false
            if let result = result {
                self.cityTextView.text = result.bestTranscription.formattedString
                finished = result.isFinal
            }
            if error != nil || finished {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 8)
                self.speechRecognitionRequest = nil
                self.speechRecognitionTask = nil
                self.stopListen()
            }
        }
        
        let recordingFormat = inputNode.outputFormat(forBus: 8)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) {
            (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.speechRecognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        try audioEngine.start()
    }
    
    func authoriseSR(){
        SFSpeechRecognizer.requestAuthorization { authStatus in
            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
                    self.MIC.isEnabled = true
                    self.isAuthorized = true
                    break
                case .denied:
                    self.MIC.isEnabled = false
                    self.MIC.setTitle("Speech recognition access denied by user", for: .disabled)
                    break
                case .restricted:
                    self.MIC.isEnabled = false
                    self.MIC.setTitle("Speech recognition restricted on device", for: .disabled)
                    break
                case .notDetermined:
                    self.MIC.isEnabled = false
                    self.MIC.setTitle("Speech recognition not authorized", for: .disabled)
                    break
                }
            }
        }
    }
    
    //Search Controller
    func filterContentForSearchText(_ searchText: String, scope: Int = 0) {
        filteredData = store_result.stores.filter({( info : STORE_INFO) -> Bool in
            let doesCategoryMatch = (scope == 0) || (info.remain_stat == REMAIN_STAT[scope-1])
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
