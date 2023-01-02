//
//  General.swift
//  new sample app
//
//  Created by Majid on 20/12/2021.
//

import AVKit
import SwiftUI
import Foundation
import AVFoundation

func getExerciseSchedule(info: [String: String], short: Bool) -> String {
    
    let days = info["Days"]!
    let reps = info["Reps"]!
    let sets = info["Sets"]!
    let rest = info["Rest"]!
    let times = info["Times"]!
    let weekdays = info["WD"]! //info.object(forKey: "WD") as! String
    let activityType = info["OT"]!
    let exePerWeek = info["ExePerWeeks"]!
    let secs = activityType == "2" ? info["BPM"]! : info["Seconds"]!
    let weightLbs = info["WeightLBS"] != nil ? info["WeightLBS"]! : "0"
    
    var scheduleString = ""
    scheduleString += (times == "1" ? "Once" : (times == "2" ? "Twice" : times + " Times"))
    
    if (days != "0") {
        scheduleString += (days == "1" ? " Daily " : " Every " + days + " Days ")
    } else {
        scheduleString += " Every " + weekdays
    }
    scheduleString += exePerWeek != "0" ? "\n" + exePerWeek + "x a week" : ""
    if (!short && activityType != "4" ) {
        scheduleString += "\n"
        scheduleString += sets + " Set" + (sets != "1" ? "s" : "") + " of "
        scheduleString += reps + " rep" + (reps != "1" ? "s" : "") + "\n"
        
        if activityType == "2" {
            scheduleString += secs + " beep" + (secs != "1" ? "s" : "") + "\n"
        }
        else {
            scheduleString += secs + " Execise second" + (secs != "1" ? "s" : "") + "\n"
            scheduleString += rest + " Rest second" + (rest != "1" ? "s" : "") + "\n"
            scheduleString += (weightLbs != "0" ? "Weight: " + weightLbs + " lbs" : "")
        }
        
        scheduleString += "\n"
    }
    
    return NSLocalizedString(scheduleString, comment: "")
}

func playVideo() {
    // Get video path

//    guard let videoPath = Exercise().getExerciseRecordedVideo(id: (lastOCKTask?.id)!) else { return }
    let videoPath = URL(string: "https://www.youtube.com/watch?v=JpiNdJNf114&t=1554s")!
    
    // Present default video player
    let playerController = AVPlayerViewController()
    playerController.player = AVPlayer(url: videoPath as URL)
    
    let screenSize = UIScreen.main.bounds
    
    let retakeButton:UIButton = UIButton(type: .system)
    retakeButton.frame = CGRect(x:screenSize.width / 2 - 100, y:screenSize.height - 120, width:60, height:40) // X, Y, width, height
    retakeButton.backgroundColor = UIColor.clear
    retakeButton.setTitle("Retake", for: .normal)
    retakeButton.setTitleColor(UIColor.white, for: .normal)
//    retakeButton.addTarget(self, action: #selector(ActivitiesViewController.retakeVideo), for: .touchUpInside)
//    playerController.view.addSubview(retakeButton)
    
    let deleteButton:UIButton = UIButton(type: .system)
    deleteButton.frame = CGRect(x:screenSize.width / 2 + 40, y:screenSize.height - 120, width:60, height:40) // X, Y, width, height
    deleteButton.backgroundColor = UIColor.clear
    deleteButton.setTitle("Delete", for: .normal)
    deleteButton.setTitleColor(UIColor.white, for: .normal)
//    deleteButton.addTarget(self, action: #selector(ActivitiesViewController.deleteVideo), for: .touchUpInside)
//    playerController.view.addSubview(deleteButton)
    
//    playerController.navigationController?.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Retake Video", style: .plain, target: self, action: #selector(ActivitiesViewController.recordVideo))
    
//    lastViewController = playerController

    appDel.getTopMostViewController()!.present(playerController, animated: true, completion: nil)
}

// The button action triggers on swipes.
// (even when terminated outside the button)
struct SwipeButtonStyle: PrimitiveButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    Button(configuration)
      .gesture(
        DragGesture()
          .onEnded { _ in
            configuration.trigger()
          }
      )
  }
}

struct RoundedRectangleButtonStyle: ButtonStyle {
    
  func makeBody(configuration: Configuration) -> some View {
    HStack {
      Spacer()
      configuration.label.foregroundColor(.white)
      Spacer()
    }
    .padding()
    .background(Color.pink.cornerRadius(8))
    .scaleEffect(configuration.isPressed ? 0.95 : 1)
  }
}


extension Shape {
    func style<S: ShapeStyle, F: ShapeStyle>(
        withStroke strokeContent: S,
        lineWidth: CGFloat = 1,
        fill fillContent: F
    ) -> some View {
        self.stroke(strokeContent, lineWidth: lineWidth)
    .background(fill(fillContent))
    }
}
