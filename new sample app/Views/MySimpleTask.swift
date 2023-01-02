//
//  MySimpleTask.swift
//  new sample app
//
//  Created by Majid on 14/12/2021.
//

import SwiftUI
import CareKitUI
import CareKit
import CareKitStore

class CustomSimpleTaskViewController: OCKSimpleTaskViewController {

    override func didSelectTaskView(_ taskView: UIView & OCKTaskDisplayable, eventIndexPath: IndexPath) {
        let event = controller.eventFor(indexPath: eventIndexPath)
        let task = event?.task

        // Use the event and corresponding task as needed here...
    }
    
    
}

// 1. Custom view that displays a task.
class CustomTaskView: UIView, OCKTaskDisplayable {

    // Use the delegate to send out notifications when certain events occur in the UI.
    var delegate: OCKTaskViewDelegate?

    // ...
    
}

// 2. Custom view synchronizer that updates the view when the data in the store changes.
final class CustomTaskViewSynchronizer: OCKSimpleTaskViewSynchronizer {
    
    override func makeView() -> OCKSimpleTaskView {
        let newV = super.makeView()
        
//        newV.headerView.backgroundColor = .red
//        newV.headerView.titleLabel.text = "Okay!"
        newV.headerView.detailLabel.isHidden = true
        print("called newV")
        return newV
    }
}

// 3. Custom controller responsible for manipulating the data in the store. You can start with subclassing our default controller, and override
// methods as needed.
class CustomTaskController: OCKTaskController {

    // Override methods as needed...
}

// 4. Custom view controller responsible tying all the pieces together. You can start with subclassing our default view controller, and override
// methods as needed.
class CustomTaskViewController: OCKTaskViewController<CustomTaskController, CustomTaskViewSynchronizer> {

    // Override methods as needed...
}
