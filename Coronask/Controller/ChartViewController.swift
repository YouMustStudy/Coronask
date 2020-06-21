//
//  ChartViewController.swift
//  Coronask
//
//  Created by kpugame on 2020/06/09.
//  Copyright © 2020 Gurnwoo Kim. All rights reserved.
//

import UIKit
import SwiftUI

let ScreenWidth = UIScreen.main.bounds.size.width
let ScreenHeight = UIScreen.main.bounds.size.height

class ChartViewController: UIViewController {
var counts = [Int]()
    @IBOutlet weak var charts: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let startX: CGFloat = 0
        let endX: CGFloat = ScreenWidth + 300.0
        let startY = 100.0
        
        let stars = StardustView(frame: CGRect(x: Double(startX), y: startY, width: 10.0, height: 10.0))
        self.view.addSubview(stars)
        self.view.sendSubviewToBack(stars)
        
        UIView.animate(withDuration: 3.0, delay: 0.0, options: .curveEaseOut, animations: {stars.center = CGPoint(x: Double(endX), y: startY)}, completion: {(value: Bool) in stars.removeFromSuperview()})
        
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
