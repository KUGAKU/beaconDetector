//
//  ContentInsideView.swift
//  BeaconDetector
//
//  Created by 竹ノ内愛斗 on 2020/12/21.
//

import SwiftUI

struct ContentInsideView: View {
    var contentText: ContentText

    var body: some View {
        Text(contentText.getText())
            .modifier(BigText())
            .background(Color.gray)
            .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
    }
}

struct ContentInsideView_Previews: PreviewProvider {
    static var previews: some View {
        ContentInsideView(contentText: ContentText(clProximity: .far))
            .previewLayout(.sizeThatFits)
    }
}
