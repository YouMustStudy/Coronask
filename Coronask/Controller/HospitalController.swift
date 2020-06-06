//
//  SearchController.swift
//  Coronask
//
//  Created by kpugame on 2020/05/24.
//  Copyright © 2020 Gurnwoo Kim. All rights reserved.
//

import UIKit

class HospitalController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var cityTextView: UITextField!
    @IBOutlet weak var resultTableView: UITableView!
    
    var isSearch: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        createPickerView(tagNo: 0)
        dismissPickerView()
        // Do any additional setup after loading the view.
        isSearch = true
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
            noDataLabel.text = "검색결과없음"
            noDataLabel.textColor = UIColor.gray
            noDataLabel.textAlignment = .center
            resultTableView.backgroundView = noDataLabel
            resultTableView.separatorStyle = .none
        }
        return retval
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = "양평군 진료소"
        cell.detailTextLabel?.text = "진료 : ~~"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "SegueHospitalDetail", sender: nil)
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
