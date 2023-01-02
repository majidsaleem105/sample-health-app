//
//  ActivitiesViewController.swift
//  new sample app
//
//  Created by Majid on 17/12/2021.
//

import UIKit
import CareKit
import CareKitUI
import CareKitStore

import SwiftUI
import ResearchKit

var lastOCKTask: OCKTask?
var selectedTask: OCKAnyTask?
var selectedEvent: OCKAnyEvent?

let appDel = UIApplication.shared.delegate as! AppDelegate

class ActivitiesViewController: OCKGridTaskViewController, OCKTaskViewControllerDelegate, ORKTaskViewControllerDelegate, ORKDeviceMotionRecorderDelegate {
    
    fileprivate var lastTaskViewController: ORKTaskViewController!
    
    func taskViewController<C, VS>(_ viewController: OCKTaskViewController<C, VS>, didEncounterError error: Error) where C : OCKTaskController, VS : OCKTaskViewSynchronizerProtocol {
        
    }
    
    func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {
        
    }
    
    func recorder(_ recorder: ORKRecorder, didCompleteWith result: ORKResult?) {
        
    }
    
    func recorder(_ recorder: ORKRecorder, didFailWithError error: Error) {
        
    }
    
    override func didSelectTaskView(_ taskView: UIView & OCKTaskDisplayable, eventIndexPath: IndexPath) {
        
        print("called didSelectTaskView function", taskView)
//        let viewController = try! controller.initiateDetailsViewController(forIndexPath: eventIndexPath)
        selectedEvent = controller.eventFor(indexPath: eventIndexPath)
        let currentTask = selectedEvent?.task
        print("# 125 " + (currentTask?.title)! + " is clicked and it's Group Identifier is: ") //+ (currentTask?.groupIdentifier)! )
        lastOCKTask = (currentTask as! OCKTask)
//        print("clicked task: ", currentTask!)
        
//        let taskIdentifier:[String] = [currentTask!.id]
        let thisMorning = Calendar.current.startOfDay(for: Date())
//        let tonight = Calendar.current.date(byAdding: DateComponents(day: 1, second: -1), to: thisMorning)!

//                let outcomeAnchor = OCKOutcomeAnchor.taskIdentifiers([taskIdentifier])
        var query = OCKOutcomeQuery(for: thisMorning)
        query.taskIDs = [currentTask!.id]
//
//        storeManager.store.fetchAnyOutcome(query: query, callbackQueue: .main) { (outComeResult) in
//            switch outComeResult {
//            case .failure(let outComeFailure):
//
//                print("outComeFailure: ", outComeFailure)
//                print("nextTaskOccurence: \(self.nextTaskOccurence)")
////                        self.controller.appendOutcomeValue(withType: 100, at: IndexPath(item: nextTaskOccurence, section: 0), completion: nil)
//
//            case .success(let outComeSuccess):
//                print("outComeSuccess: ", outComeSuccess)
//
//                let outcomes = try! outComeResult.get()
//                self.nextTaskOccurence = outcomes.values.count
//
//                print("nextTaskOccurence: \(self.nextTaskOccurence)")
////                        self.controller.appendOutcomeValue(withType: 100, at: IndexPath(item: nextTaskOccurence, section: 0), completion: nil)
//            }
//        }
        
//        if currentTask?.groupIdentifier! == "Informational Activities" {
//
//            let taskViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ReadOnlyTableViewController") as! ReadOnlyTableViewController
//
//            let activityInfo = lastOCKTask?.userInfo
//
//            taskViewController.exerciseName = lastOCKTask?.title
//            taskViewController.exerciseDescription = lastOCKTask?.instructions
//            taskViewController.exerciseVideoURL = Exercise().getExerciseVideo(info: activityInfo!) as URL?
//
//
//            self.present(taskViewController, animated: true, completion: nil)
//        }

        let activityTitle = lastOCKTask?.title
        let activityImage = lastOCKTask?.asset
        
        var activitySchedule = "" //getExerciseSchedule(info: (lastOCKTask?.userInfo)!, short: false)
//        let activityVideo = getExerciseVideo(info: activityInfo)
//        print("activityImage: \(imageURL)")
        
//        ActivityDetailView(currentTask: lastOCKTask!, activityTitle: activityTitle!)
        
//        var OrderedTaskVC: UIViewControllerRepresentable
//        OrderedTaskVC.view = ActivityDetailView(currentTask: lastOCKTask!, activityTitle: activityTitle!)
//        let task = Exercise().taskActivity(activity: lastOCKTask!)
//        OrderedTaskVC = ORKTaskViewController(task: task, taskRun: nil)
//
//
//        lastTaskViewController = OrderedTaskVC
//        OrderedTaskVC.isNavigationBarHidden = false
//        OrderedTaskVC.showsProgressInNavigationBar = false
//        OrderedTaskVC.delegate = self
//
//        let OrderedTaskVC = UIViewController()
//        OrderedTaskVC.view.backgroundColor = .white
//
//        let closeBtn = UIBarButtonItem(title: "Close", style: .plain, target: self, action: nil)
//        OrderedTaskVC.navigationItem.rightBarButtonItem = closeBtn
//
//        OrderedTaskVC.navigationController?.navigationBar.backgroundColor = UIColor.systemGroupedBackground
////        OrderedTaskVC.navigationItem.rightBarButtonItem = closeBtn

        activitySchedule = "Twice Daily\n2 Sets of 3 reps\n2 Exercise seconds\n3 Rest seconds"
        let OrderedTaskVC = UIHostingController(rootView: ActivityDetailView(currentTask: lastOCKTask!, activityTitle: activityTitle!, activityAsset: activityImage!, activityInstructions: (lastOCKTask?.instructions ?? ""), activitySchedule: activitySchedule))
        
//        appDel.getTopMostViewController()!.present(OrderedTaskVC, animated: true, completion: nil)
        
        
//        ActivityDetailView(currentTask: lastOCKTask!, activityTitle: activityTitle!)
//        AdaptedActivityView(currentTask: lastOCKTask, activityTitle: activityTitle)
        print("Last Row# 112 with asset: ", activityImage)
    }

//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view.
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
}

class ActivitiesViewSynchronizer: OCKGridTaskViewSynchronizer {
    
    // Customize the initial state of the view
    override func makeView() -> OCKGridTaskView {
        print("from# 47")
        let instructionsView = super.makeView()
//        instructionsView.collectionView.backgroundView?.backgroundColor = .red
//        instructionsView.completionButton.label.text = "Start Survey"
        
        instructionsView.headerView.detailLabel.isHidden = true
        instructionsView.contentStackView.subviews[ 1 ].isHidden = true
//        instructionsView.contentStackView.isUserInteractionEnabled = false
        
        let randomInt = Int.random(in: 1..<15)
        print("randomInt: ", randomInt)
        instructionsView.headerView.detailDisclosureImage?.image = UIImage(named: ( randomInt % 2 == 0 ? "alarm" : "alarm-set" ))
        instructionsView.headerView.detailLabel.isUserInteractionEnabled = false
        
        return instructionsView
    }
    
    // Customize how the view updates
    override func updateView(_ view: OCKGridTaskView,
                             context: OCKSynchronizationContext<OCKTaskEvents>) {
        print("from# 56")
        
        super.updateView(view, context: context)
        
//        selectedTask = context.viewModel?.firstEvent?.task
        selectedTask = context.viewModel.tasks.first
        
//        lastOCKTask = (selectedTask as! OCKTask)
        
//        print( "survey name: \(String(describing: context.oldViewModel?.firstEvent?.task.title))" )
//        surveyTask = context.viewModel?.firstEvent?.task
//
//        // Check if an answer exists or not and set the detail label accordingly
//        if let answer = context.viewModel?.firstEvent?.outcome?.values.first?.integerValue {
//            view.headerView.detailLabel.text = "Pain Rating: \(answer)"
//        } else {
//            view.headerView.detailLabel.text = context.viewModel?.firstEvent?.task.id //"Rate your pain on a scale of 1 to 10"
//        }
    }
}
