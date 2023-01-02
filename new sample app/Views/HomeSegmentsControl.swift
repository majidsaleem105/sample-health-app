//
//  HomeSegmentsControl.swift
//  new sample app
//
//  Created by Majid on 16/12/2021.
//

import CareKit
import CareKitStore
import CareKitUI
import Foundation
import SwiftUI



struct HomeScreenTabs: View {
    
    @State var selectedTab = 0

    private let allTabs = ["Physical", "Optional", "Surveys"]
    
    var body: some View {
        VStack(spacing: 0) {

            VStack {

                Picker(selection: $selectedTab, label: Text("Platform")) {
                    ForEach(0..<allTabs.count) { index in
                        Text(self.allTabs[index])
                            .tag(index)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                Divider()
            }

//            Text("Selected Tab: \(selectedTab)")
            
            switch( selectedTab ){
            case 1:
//                PhyicalActivitiesView()
                Text("All optional activities are displayed here.")
            case 2:
//                SurveysView()
                Text("All surveys are displayed here.")
            default:
                Text("All Physicall activities are displayed here.")
            }
        }
    }
}

@available(iOS 14, *)
private struct PhyicalActivitiesView: View {

    
//    let labelV = OCKLabel(textStyle: .headline, weight: .thin)
//        labelV.text = "OT Tasks"
        
    var body: some View {
        
        let v = CareKitUI.OCKLabel(textStyle: .headline, weight: .thin)
        
        // Static view
        CareKitUI.NumericProgressTaskView(title: Text("Steps (Static)"),
                                          progress: Text("0"),
                                          goal: Text("100"),
                                          isComplete: false)
            .padding([.vertical], 100)
        
    }
}

@available(iOS 14, *)
private struct SurveysView: View {
    
    var body: some View{
        
        let v = CareKitUI.OCKLabel(textStyle: .headline, weight: .thin)
        
        // Static view
        CareKitUI.NumericProgressTaskView(title: Text("Walk Steps (Static)"),
                                          progress: Text("0"),
                                          goal: Text("100"),
                                          isComplete: false)
            .padding([.vertical], 100)

    }
}
