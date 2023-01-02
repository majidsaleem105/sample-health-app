//
//  ActivityPerformance.swift
//  new sample app
//
//  Created by Majid on 22/12/2021.
//

import AVKit
import Combine
import SwiftUI
import AVFoundation

struct ActivityPerformance: View {
    
    @Binding var activityTitle: String
    @Binding var activityAsset: String
    @Binding var activitySchedule: String
    @Binding var activityInstructions: String
    @Binding var restSeconds: Int
    @Binding var exerciseSeconds: Int
    
    @State var totalReps: Int = 3
    @State var totalSets: Int = 2
    
    @State var currentReps: Int = 1
    @State var currentSets: Int = 1
    
    @State var timerCall = ""
    @State var timeRemaining = 0
    @State var isExerciseTimerRunning = true
    @State private var isSetCompleted = false
    @State private var isTimerStarted: Bool = true
    @State var timer = Timer.publish(every: 1, on: .main, in: .common) .autoconnect()
    
    @State var BDPlayer: AVAudioPlayer?
    @State private var blinkScale:CGFloat = 0
    
    func convertSecondsToTime( timeInSeconds : Int ) -> String {
        
        let minutes = timeInSeconds / 60
        let seconds = timeInSeconds % 60
        return String(format: "%02i:%02i", minutes, seconds)
    }
    
    func startTimer() {
        isTimerStarted = true
        self.timer = Timer.publish(every: 1, on: .main, in: .common) .autoconnect()
    }
    func stopTimer() {
        isTimerStarted = false
        self.timer.upstream.connect().cancel()
    }
    func increamentSet()
    {
        currentSets += 1
        isTimerStarted = true
        currentReps = currentSets <= totalSets ? 1 : totalReps
    }
    
    func setTimer( )
    {
        if timerCall == "" {
            timeRemaining = exerciseSeconds
            timerCall = "exercise timer"
            speakText(text: "Start")
        }
        
        if( isExerciseTimerRunning && timeRemaining == 0 ) {
            
            speakText(text: "Rest")
//            print("Set Timer to Rest Seconds: \(timerCall)")
            timeRemaining = restSeconds
            isExerciseTimerRunning = false
            timerCall = "rest timer"
            
        }
        else if( !isExerciseTimerRunning && timeRemaining == 0 ) {
            
            speakText(text: "Start")
//            print("Set Timer to Exercise Seconds: \(timerCall)")
            timeRemaining = exerciseSeconds
            isExerciseTimerRunning = true
            timerCall = "exercise timer"
        }
    }
    
    func playAudio( filename: String ) {
        
        self.BDPlayer?.currentTime = 0
        if let BDURL = Bundle.main.url(forResource: filename, withExtension: "mp3") {
            do {
                try BDPlayer = AVAudioPlayer(contentsOf: BDURL) /// make the audio player
                BDPlayer?.volume = 5
                BDPlayer?.play()
            } catch {
            print("Couldn't play audio. Error: \(error)")
            }
        }
    }
    
    func speakText( text: String ) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
//        utterance.rate = 0.1

        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }
    
    var body: some View {
        
        if( isSetCompleted )
        {
            RestBtwSetsScreen
        }
        else
        {
            VStack {
                GeometryReader { geometry in
                    
                    NavigationView {
                        ScrollView {
                            
                            VStack{
    //                            HStack (alignment: .bottom) {
    //                                Text("Clip: Connected")
    //                                    .frame(width: 200, height: 50, alignment: .leading)
    //
    //                                Text("Counts: 10")
    //                                    .frame(width: 200, height: 50, alignment: .trailing)
    //                            }
    ////                            .frame(width: geometry.size.width, height: 300)
    //                            .background(Color.pink)
                                
                                HStack (spacing: 0) {
                                    HStack{
                                        Text("Clip:")
                                            .padding(.leading, 0)
                                        Button{
                                            
                                        } label: {
                                            Circle()
                                                .fill(
                                                    RadialGradient(
    //                                                    gradient: Gradient(colors: [Color.green, Color(UIColor.blue)]),
                                                        gradient: Gradient(colors: [Color.red, Color(UIColor.green)]),
                                                        center: .center,
                                                        startRadius: 10,
                                                        endRadius: 30
                                                    )
                                                )
                                                .shadow(
                                                    color: Color.red,
                                                    radius: 5,
                                                    x: 0.0, y: 0.0)
    //                                            .strokeBorder(Color.gray, lineWidth: 1)
    //                                            .background(Circle().fill(Color.green))
    ////                                            .overlay(Circle().fill(Color.red))
                                                .frame(width: 20, height: 20)
                                                .padding(.leading, 10)
                                                .scaleEffect(blinkScale)
                                                .animation(.easeIn, value: blinkScale)
                                            
                                            Text("Disconnected")
                                                .foregroundColor(Color.red)
                                                .minimumScaleFactor(0.1)
                                        }
    //                                    .scaleEffect(blinkScale)
    //                                    .animation(.easeIn, value: blinkScale)
                                       
                                    }
                                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
    //                                .background(Color.blue)
                                    Spacer()
                                    HStack {
                                        Text("Movements:")
                                        Text("40")
                                            .padding(.trailing, 10)
                                    }
                                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
    //                                .background(Color.green)
                                }
                                .padding()
                                //.frame(width: (geometry.size.width / 2), alignment: .leading)
    //                            .equalWidth()
    //                            .frame(width: geometry.size.width, alignment: .leading)
    //                            .background(Color.pink)
                                
                                Spacer()
    //                            Button("Create account", action: {})
    //                                        .padding()
    //                                        .foregroundColor(.white)
    //                                        .background(RoundedRectangle(cornerRadius: 20).style(
    //                                            withStroke: Color.primary,
    //                                            lineWidth: 2,
    //                                            fill: LinearGradient(
    //                                gradient: Gradient(colors: [.blue, .black]),
    //                                startPoint: .top,
    //                                endPoint: .bottom
    //                            )
    //                                        ))
                                
                                VStack {
                                    Text( String( currentReps ) + " of " + String( totalReps ) + " Reps" )
                                        .font( .largeTitle )
                                        .multilineTextAlignment(.leading)
                                    Spacer()
                                    Text( String( currentSets ) + " of " + String( totalSets ) + " Sets" )
                                        .font( .headline )
                                        .multilineTextAlignment(.leading)
                                    Spacer()
                                    Text( activitySchedule ?? "" )
                                        .multilineTextAlignment(.center)
                                    Spacer()
                                    Text( convertSecondsToTime(timeInSeconds: timeRemaining ))
                                        .padding()
                                        .font(.system(size: 30))
                                        .onAppear(perform: {
                                            setTimer()
                                            
                                        })
                                        .onReceive(timer) { _ in
                                            //speakText(text: "Start")
                                            blinkScale = blinkScale == 1 ? 0.8 : 1
                                            
                                            if timeRemaining > 0 {
                                                timeRemaining -= 1
                                            }
                                            else if timeRemaining == 0 {
                                                setTimer()
                                            }
                                            
                                            if( (timerCall == "rest timer") && (timeRemaining == 0 ) )
                                            {
                                                currentReps = currentReps <= totalReps ? ( currentReps + 1 ) : currentReps;
                                                print( "\(currentReps) : \(totalReps) && \(currentSets) < \(totalSets)" )
                                                if(currentReps > totalReps && currentSets < totalSets)
                                                {
                                                    print("Entered.")
                                                    stopTimer()
                                                    currentReps = totalReps
//                                                    AnyView( RestBtwSetsScreen )
                                                    isSetCompleted = true
                                                }
                                                
                                                else if( (currentSets >= totalSets) && (currentReps > totalReps) ) {
                                                    stopTimer()
                                                    currentReps = totalReps
                                                }
                                            }
                                            
                                            if( timerCall == "exercise timer" && timeRemaining <= 3 )
                                            {
                                                speakText(text: String( timeRemaining ))
                                            }
                                        }
                                    Spacer()
                                    Text( activityInstructions ?? "" )
            //                            .multilineTextAlignment(.center)
                                        .padding(.leading, 25)
                                        .padding(.trailing, 25)
                                    Spacer()
                                    
                                }
                                if activityAsset != nil {
                                    Image( activityAsset )
                                        .resizable()
                                        .scaledToFit()
                                }
                            }
                            
                        }
        //                .navigationTitle("Welcome")
                        .toolbar {
                            
                            ToolbarItem(placement: .navigationBarLeading) {
                                
                                Button {
                                    
                                    isTimerStarted ? stopTimer() : startTimer()
                                    !isTimerStarted ? speakText(text: "Timer Paused") : speakText(text: "Timer Resumed")
                                    
                                } label: {
                                    
                                    Text( (isTimerStarted ? "Pause" : "Resume") )
                                }
                            
                            }
                            
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button("Close") {
                                    print("Close tapped!")
                                    appDel.dismissTopMostViewController()
                                }
                            }
                            
                        }
                    }   //  End of NavigationView
                    .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                    .edgesIgnoringSafeArea(.all)
                }
                
                
                
            }   //  End of VStack (first one)
        }   //  End of ElsE
    }   //  End of Body View
    
    var RestBtwSetsScreen: some View {
        
        VStack {
            GeometryReader { geometry in
                
                NavigationView {
                    ScrollView {
                    Text("Ready to start your next set? ")
                        .font(.title)
                        .fontWeight(.semibold)
//                        .frame(width: .infinity, height: 30, alignment: .center)
//                        .background(Color.red)
                    Spacer()
                    
                        Image( uiImage: UIImage(named: "img_rest" + String( Int.random(in: 0..<18) ) + ".JPG")!)
                        .resizable()
                        .scaledToFit()
                    
                    Spacer()

                    Button {
                        print("Start Next button is called.")
//                        appDel.dismissTopMostViewController()
                        isSetCompleted = false
                        increamentSet()
                        
                    } label: {
                        Text("Start Next")
                            .padding()
//                                        .background(Color.pink.cornerRadius(8))
                            .foregroundColor(Color.white)
                    }
                    .frame(width: 250, height: 50)
                    .background(Color.pink.cornerRadius( 8 ))
                }
                
                .toolbar {
                   
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Stop") {
                            print("Stop tapped!")
                            appDel.dismissTopMostViewController()
                        }
                    }
                }   //  End of .toolbar
            }
            }   //  End of GeometryReader
        }   //  End of VStack
    }   //  End of RestBtwSetsScreen
    
}

//struct ActivityPerformance_Previews: PreviewProvider {
//
//    @Binding var activityTitle: String
//    @Binding var activityAsset: String
//    @Binding var activitySchedule: String
//    @Binding var activityInstructions: String
//    @Binding var restSeconds: Int
//    @Binding var exerciseSeconds: Int
//
//    static var previews: some View {
//
//        ActivityPerformance(activityTitle: $activityTitle, activityAsset: $activityAsset, activitySchedule: $activitySchedule, activityInstructions: $activityInstructions, restSeconds: $restSeconds, exerciseSeconds: $exerciseSeconds)
//    }
//}
