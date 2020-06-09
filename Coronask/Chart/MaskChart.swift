//
//  SwiftUIView.swift
//  Coronask
//
//  Created by kpugame on 2020/06/09.
//  Copyright © 2020 Gurnwoo Kim. All rights reserved.
//

import SwiftUI

struct MaskChart: View {
    var counts: [Int]
    var max_count: Int
    var max_height: Double
    let status = ["충분", "보통", "부족", "품절"]
    
    var body: some View {
        VStack {
            Text("마스크 재고현황")
                .offset(x: 0, y: 150)
            
            HStack {
                ForEach(0..<4) { index in
                    VStack {
                        Spacer()
                        Text(String(self.counts[index]))
                            .font(.footnote)
                            .offset(y: 0)
                            .zIndex(1)
                        
                        Rectangle()
                            .fill(Color.green)
                            .frame(width: 20, height: self.getHeight(idx: index))
                        Text(self.status[index])
                            .font(.footnote)
                            .frame(height: 20)
                    }
                    
                }
                } .offset(x: 0, y: -200)
            
        }
        
        
        
    }
    
    func getHeight(idx: Int) -> CGFloat {
        return CGFloat(self.counts[idx]) * CGFloat(self.max_height) / CGFloat(self.max_count)
    }
}

    
    struct MaskChart_Previews: PreviewProvider {
    static var previews: some View {
        MaskChart(counts: [15, 20, 11, 12], max_count: 20, max_height: 150.0)
    }
}
