//
//  ChartViewController.swift
//  Coronask
//
//  Created by kpugame on 2020/06/09.
//  Copyright © 2020 Gurnwoo Kim. All rights reserved.
//

import UIKit
import SwiftUI

class ChartViewController: UIViewController {
var counts = [Int]()
    @IBOutlet weak var charts: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        charts.alpha = 0.0
        UIView.animate(withDuration: 2.0, delay: 0.0, options: .curveEaseIn, animations: { self.charts.alpha = 1.0 }, completion: nil)
        // Do any additional setup after loading the view.
    }
    
    @IBSegueAction func embedSwiftUIView(_ coder: NSCoder) -> UIViewController? {
        return UIHostingController(coder: coder, rootView: MaskChart(counts: counts, max_count: counts.max()!, max_height: 150.0))
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
