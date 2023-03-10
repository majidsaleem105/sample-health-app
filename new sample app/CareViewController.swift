/*
 Copyright (c) 2019, Apple Inc. All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification,
 are permitted provided that the following conditions are met:
 
 1.  Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.
 
 2.  Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation and/or
 other materials provided with the distribution.
 
 3. Neither the name of the copyright holder(s) nor the names of any contributors
 may be used to endorse or promote products derived from this software without
 specific prior written permission. No license is granted to the trademarks of
 the copyright holders even if such marks are included in this software.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

import Foundation
import UIKit
import CareKit
import CareKitUI
import CareKitStore
import SwiftUI
//import CareKitTests_iOS

var lastCareViewController = OCKListViewController()

class CareViewController: OCKDailyPageViewController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(title: "+ Upload Video", style: .plain, target: self,
                            action: #selector(presentContactsListViewController))
        
        self.navigationController?.navigationBar.backgroundColor = UIColor.systemGroupedBackground
        self.view.backgroundColor = UIColor.systemGroupedBackground
        
        if #available(iOS 13.0, *) {
            
            let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            let statusBarHeight: CGFloat = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0 //app.statusBarFrame.size.height
            
            let statusbarView = UIView()
            statusbarView.backgroundColor = UIColor.systemGroupedBackground
            view.addSubview(statusbarView)
          
            statusbarView.translatesAutoresizingMaskIntoConstraints = false
            statusbarView.heightAnchor
                .constraint(equalToConstant: statusBarHeight).isActive = true
            statusbarView.widthAnchor
                .constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true
            statusbarView.topAnchor
                .constraint(equalTo: view.topAnchor).isActive = true
            statusbarView.centerXAnchor
                .constraint(equalTo: view.centerXAnchor).isActive = true
          
        }
    }
    
    @objc private func presentContactsListViewController() {
        let viewController = OCKContactsListViewController(storeManager: storeManager)
        viewController.title = "+ Upload Video"
        viewController.isModalInPresentation = true
        viewController.navigationItem.rightBarButtonItem =
            UIBarButtonItem(title: "Done", style: .plain, target: self,
                            action: #selector(dismissContactsListViewController))

        let navigationController = UINavigationController(rootViewController: viewController)
        present(navigationController, animated: true, completion: nil)
    }

    @objc private func dismissContactsListViewController() {
        dismiss(animated: true, completion: nil)
    }
    
    
    // This will be called each time the selected date changes.
    // Use this as an opportunity to rebuild the content shown to the user.
    override func dailyPageViewController(_ dailyPageViewController: OCKDailyPageViewController,
                                          prepare listViewController: OCKListViewController, for date: Date) {

        lastCareViewController = listViewController
        let identifiers = ["doxylamine", "nausea", "kegels", "steps", "heartRate", "nsh", "homeass"]
        var query = OCKTaskQuery(for: date)
        query.ids = identifiers
        query.excludesTasksWithNoEvents = true
        
        storeManager.store.fetchAnyTasks(query: query, callbackQueue: .main) { result in
            switch result {
            case .failure(let error): print("Error: \(error)")
            case .success(let tasks):

                // Add a non-CareKit view into the list
                let tipTitle = "Benefits of exercising"
                let tipText = "Learn how activity can promote a healthy pregnancy."

                // Only show the tip view on the current date
                if Calendar.current.isDate(date, inSameDayAs: Date()) {
                    let tipView = TipView()
                    tipView.headerView.titleLabel.text = tipTitle
                    tipView.headerView.detailLabel.text = tipText
                    tipView.imageView.image = UIImage(named: "exercise.jpg")
//                    listViewController.appendView(tipView, animated: false)
                }

                if #available(iOS 14, *), let walkTask = tasks.first(where: { $0.id == "steps" }) {

                    let view = NumericProgressTaskView(
                        task: walkTask,
                        eventQuery: OCKEventQuery(for: date),
                        storeManager: self.storeManager)
                        .padding([.vertical], 10)

//                    listViewController.appendViewController(view.formattedHostingController(), animated: false)
                    
                    let lblView = LabeledValueTaskView(
                        task: walkTask,
                        eventQuery: .init(for: Date()),
                        storeManager: self.storeManager
                    ) .padding([.vertical], 10)
                    
                    listViewController.appendViewController(lblView.formattedHostingController(), animated: true)
                    
                }
                
                listViewController.appendViewController(HomeScreenTabs().formattedHostingController(), animated: true)
                
                if( HomeScreenTabs() .selectedTab == 1 )
                {
                    print("In tab: ", HomeScreenTabs() .selectedTab )
                    let labelV = OCKLabel(textStyle: .headline, weight: .thin)
                    labelV.text = "Optional Tasks"
                    listViewController.appendView(labelV, animated: true)
                }
                else if( HomeScreenTabs() .selectedTab == 2 )
                {
                    print("In tab: ", HomeScreenTabs() .selectedTab )
                    let labelV = OCKLabel(textStyle: .headline, weight: .thin)
                    labelV.text = "Surveys Tasks"
                    listViewController.appendView(labelV, animated: true)
                }
                else if( HomeScreenTabs() .selectedTab == 0 )
                {
                    print("In tab: ", HomeScreenTabs() .selectedTab )
                    let labelV = OCKLabel(textStyle: .headline, weight: .thin)
                    labelV.text = "Daily Tasks"
                    listViewController.appendView(labelV, animated: true)
                
                    // Since the kegel task is only scheduled every other day, there will be cases
                    // where it is not contained in the tasks array returned from the query.
                    if let kegelsTask = tasks.first(where: { $0.id == "kegels" }) {
    //                    let kegelsCard = OCKSimpleTaskViewController(task: kegelsTask, eventQuery: .init(for: date),
    //                                                                 storeManager: self.storeManager)
                        
//                        let kegelsCard = OCKGridTaskViewController(task: kegelsTask, eventQuery: .init(for: date), storeManager: self.storeManager)
                        
                        let kegelsCard = ActivitiesViewController(viewSynchronizer: ActivitiesViewSynchronizer(), task: kegelsTask, eventQuery: .init(for: date), storeManager: self.storeManager)

//                        kegelsCard.taskView.headerView.detailLabel.isHidden = true
                        listViewController.appendViewController(kegelsCard, animated: false)
                    }

                    // Create a card for the doxylamine task if there are events for it on this day.
                    if let doxylamineTask = tasks.first(where: { $0.id == "doxylamine" }) {

    //                    let doxylamineCard = OCKChecklistTaskViewController(
    //                        task: doxylamineTask,
    //                        eventQuery: .init(for: date),
    //                        storeManager: self.storeManager)
                        
//                        let doxylamineCard = OCKGridTaskViewController(
//                            task: doxylamineTask,
//                            eventQuery: .init(for: date),
//                            storeManager: self.storeManager)
                        
                        let doxylamineCard = ActivitiesViewController(viewSynchronizer: ActivitiesViewSynchronizer(), task: doxylamineTask, eventQuery: .init(for: date), storeManager: self.storeManager)
//                        doxylamineCard.taskView.headerView.detailLabel.isHidden = false
                        listViewController.appendViewController(doxylamineCard, animated: false)
                    }

                    // Create a card for the nausea task if there are events for it on this day.
                    // Its OCKSchedule was defined to have daily events, so this task should be
                    // found in `tasks` every day after the task start date.
                    if let nauseaTask = tasks.first(where: { $0.id == "nausea" }) {

                        // dynamic gradient colors
                        let nauseaGradientStart = UIColor { traitCollection -> UIColor in
                            return traitCollection.userInterfaceStyle == .light ? #colorLiteral(red: 0.9960784314, green: 0.3725490196, blue: 0.368627451, alpha: 1) : #colorLiteral(red: 0.8627432641, green: 0.2630574384, blue: 0.2592858295, alpha: 1)
                        }
                        let nauseaGradientEnd = UIColor { traitCollection -> UIColor in
                            return traitCollection.userInterfaceStyle == .light ? #colorLiteral(red: 0.9960784314, green: 0.4732026144, blue: 0.368627451, alpha: 1) : #colorLiteral(red: 0.8627432641, green: 0.3598620686, blue: 0.2592858295, alpha: 1)
                        }

                        // Create a plot comparing nausea to medication adherence.
                        let nauseaDataSeries = OCKDataSeriesConfiguration(
                            taskID: "nausea",
                            legendTitle: "Nausea",
                            gradientStartColor: nauseaGradientStart,
                            gradientEndColor: nauseaGradientEnd,
                            markerSize: 10,
                            eventAggregator: OCKEventAggregator.countOutcomeValues)

                        let doxylamineDataSeries = OCKDataSeriesConfiguration(
                            taskID: "doxylamine",
                            legendTitle: "Doxylamine",
                            gradientStartColor: .systemGray2,
                            gradientEndColor: .systemGray,
                            markerSize: 10,
                            eventAggregator: OCKEventAggregator.countOutcomeValues)

                        let insightsCard = OCKCartesianChartViewController(
                            plotType: .bar,
                            selectedDate: date,
                            configurations: [nauseaDataSeries, doxylamineDataSeries],
                            storeManager: self.storeManager)

                        insightsCard.chartView.headerView.titleLabel.text = "Nausea & Doxylamine Intake"
                        insightsCard.chartView.headerView.detailLabel.text = "This Week"
                        insightsCard.chartView.headerView.accessibilityLabel = "Nausea & Doxylamine Intake, This Week"
                        
    //                    listViewController.appendViewController(insightsCard, animated: false)
                        
                        var labelVv = OCKLabel(textStyle: .headline, weight: .thin)
                        labelVv.text = "NAVIGATOR"
                        listViewController.appendView(labelVv, animated: true)
                        
                        // Also create a card that displays a single event.
                        // The event query passed into the initializer specifies that only
                        // today's log entries should be displayed by this log task view controller.
                        let nauseaCard = OCKButtonLogTaskViewController(task: nauseaTask, eventQuery: .init(for: date),
                                                                        storeManager: self.storeManager)
                        
                        listViewController.appendViewController(nauseaCard, animated: false)
                        
                        labelVv = OCKLabel(textStyle: .headline, weight: .semibold)
                        labelVv.text = "Optionals"
                        listViewController.appendView(labelVv, animated: true)
                        
                        // Also create a card that displays a single event.
                        // The event query passed into the initializer specifies that only
                        // today's log entries should be displayed by this log task view controller.
                        let nauseaCardG = OCKGridTaskViewController(task: nauseaTask, eventQuery: .init(for: date),
                                                                        storeManager: self.storeManager)
                        
                        listViewController.appendViewController(nauseaCardG, animated: false)
                        
                        labelVv = OCKLabel(textStyle: .headline, weight: .semibold)
                        labelVv.text = "Surveys"
                        listViewController.appendView(labelVv, animated: true)
                        
                        if let SimpleS = tasks.first(where: { $0.id == "nsh" }) {
                            
//                            let simplesCard = OCKSimpleTaskViewController(taskID: SimpleS.id, eventQuery: .init(for: date), storeManager:self.storeManager)
                            
                            let simplesCard = OCKSimpleTaskViewController(task: SimpleS, eventQuery: .init(for: date),
                                                                         storeManager: self.storeManager)

                            simplesCard.taskView.headerView.detailLabel.isHidden = true
                            listViewController.appendViewController(simplesCard, animated: false)
                        }
                        
                        if let SimpleS = tasks.first(where: { $0.id == "homeass" }) {
                            
//                            let simplesCard = OCKSimpleTaskViewController(taskID: SimpleS.id, eventQuery: .init(for: date), storeManager:self.storeManager)
                            
                            let simplesCard = OCKSimpleTaskViewController(task: SimpleS, eventQuery: .init(for: date),
                                                                         storeManager: self.storeManager)

                            simplesCard.taskView.headerView.detailLabel.isHidden = true
                            listViewController.appendViewController(simplesCard, animated: false)
                        }
                        
                    }   //  End of if( HomeScreenTabs() .selectedTab == 0 )
                    
                }
            }
        }
    }
}

extension View {
    func formattedHostingController() -> UIHostingController<Self> {
        let viewController = UIHostingController(rootView: self)
        viewController.view.backgroundColor = .clear
        return viewController
    }
}
