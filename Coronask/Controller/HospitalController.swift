//
//  SearchController.swift
//  Coronask
//
//  Created by kpugame on 2020/05/24.
//  Copyright © 2020 Gurnwoo Kim. All rights reserved.
//

import UIKit

class HospitalController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, XMLParserDelegate {
    
    @IBOutlet weak var cityTextView: UITextField!
    @IBOutlet weak var resultTableView: UITableView!
    
    var isSearch: Bool = false
    var isFirst: Bool = false
    let main_url: String = "https://openapi.gg.go.kr/EmgMedInfo?key=8061088846964e22afc0bd5e0770d7a3&sigun_nm="
    var selected_row: Int = 0
    
    var parser = XMLParser()
    var posts = NSMutableArray()
    var elements = NSMutableDictionary()
    var element = NSString()
    var name = NSMutableString()
    var type = NSMutableString()
    var telno = NSMutableString()
    var addr = NSMutableString()
    var lat = NSMutableString()
    var lon = NSMutableString()
    var checker:Set<String> = []
    
    @IBAction func ClickSearch()
    {
        posts = []
        checker = []
        let request_url = (main_url + cityTextView.text!).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        parser = XMLParser(contentsOf: URL(string: request_url)!)!
        parser.delegate = self
        parser.parse()
        isSearch = true
        isFirst = true
        resultTableView!.reloadData()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        element = elementName as NSString
        if(elementName as NSString).isEqual(to: "row")
        {
            elements = NSMutableDictionary()
            elements = [:]
            name = NSMutableString()
            name = ""
            type = NSMutableString()
            type = ""
            telno = NSMutableString()
            telno = ""
            addr = NSMutableString()
            addr = ""
            lat = NSMutableString()
            lat = ""
            lon = NSMutableString()
            lon = ""
        }
    }
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if element.isEqual(to: "MEDCARE_INST_NM") {
            name.append(string)
        } else if element.isEqual(to: "DISTRCT_DIV_NM") {
            type.append(string)
        } else if element.isEqual(to: "EMGNCY_CENTER_TELNO") {
            telno.append(string)
        } else if element.isEqual(to: "REFINE_ROADNM_ADDR") {
            addr.append(string)
        } else if element.isEqual(to: "REFINE_WGS84_LAT") {
            lat.append(string)
        } else if element.isEqual(to: "REFINE_WGS84_LOGT") {
            lon.append(string)
        }
    }
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if (elementName as NSString).isEqual(to: "row") {
            if !name.isEqual(nil) {
                elements.setObject(name, forKey: "name" as NSCopying)
            }
            if !type.isEqual(nil) {
                elements.setObject(type, forKey: "type" as NSCopying)
            }
            if !telno.isEqual(nil) {
                elements.setObject(telno, forKey: "telno" as NSCopying)
            }
            if !addr.isEqual(nil) {
                elements.setObject(addr, forKey: "addr" as NSCopying)
            }
            if !lat.isEqual(nil) {
                elements.setObject(lat, forKey: "lat" as NSCopying)
            }
            if !lon.isEqual(nil) {
                elements.setObject(lon, forKey: "lon" as NSCopying)
            }
            let s_name = name as NSString as String
            if !checker.contains(s_name) {
                posts.add(elements)
                checker.insert(s_name)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        isSearch = false
        isFirst = false
        cityTextView.text = Citys[0]
        createPickerView(tagNo: 0)
        dismissPickerView()
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
            noDataLabel.text = (!isFirst) ? "지역을 선택하신 후 검색버튼을 눌러주세요" : "검색결과없음"
            noDataLabel.textColor = UIColor.gray
            noDataLabel.textAlignment = .center
            resultTableView.backgroundView = noDataLabel
            resultTableView.separatorStyle = .none
        }
        return retval
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HospitalCell", for: indexPath)
        cell.textLabel?.text = (posts.object(at: indexPath.row) as AnyObject).value(forKey: "name") as! NSString as String
        cell.detailTextLabel?.text = (posts.object(at: indexPath.row) as AnyObject).value(forKey: "type") as! NSString as String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selected_row = indexPath.row
        //performSegue(withIdentifier: "SegueHospitalDetail", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SegueHospitalDetail" {
            if let HDC = segue.destination as? HospitalDetailController {
                let cell = sender as! UITableViewCell
                let idx = resultTableView.indexPath(for: cell)
                selected_row = idx!.row
                
                HDC.name = (posts.object(at: selected_row) as AnyObject).value(forKey: "name") as! NSString as String
                
                HDC.type = (posts.object(at: selected_row) as AnyObject).value(forKey: "type") as! NSString as String
                
                HDC.addr = (posts.object(at: selected_row) as AnyObject).value(forKey: "addr") as! NSString as String
                
                HDC.telno = (posts.object(at: selected_row) as AnyObject).value(forKey: "telno") as! NSString as String
                
                HDC.lat = ((posts.object(at: selected_row) as AnyObject).value(forKey: "lat") as! NSString).floatValue
                
                HDC.lon = ((posts.object(at: selected_row) as AnyObject).value(forKey: "lon") as! NSString).floatValue
            }
        }
    }
    
    //PickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Citys.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Citys[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        cityTextView.text = Citys[row]
    }
    func createPickerView(tagNo : Int) {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        cityTextView.inputView = pickerView
    }
    func dismissPickerView(){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let button = UIBarButtonItem(title: "선택", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.action))
        toolbar.setItems([button], animated: true)
        toolbar.isUserInteractionEnabled = true
        cityTextView.inputAccessoryView = toolbar
    }
    @objc func action () {
        self.cityTextView.resignFirstResponder()
    }
}
