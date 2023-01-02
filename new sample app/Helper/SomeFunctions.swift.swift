//
//  SomeFunctions.swift.swift
//  new sample app
//
//  Created by Majid on 16/12/2021.
//

import AVKit
import WebKit
import CareKit
import SwiftUI
import CareKitUI
import Foundation
import CareKitStore

func fetchOptionalActivities() {
    
//    var listViewController = OCKListViewController()
    let labelV = OCKLabel(textStyle: .headline, weight: .thin)
    labelV.text = "OT Tasks"
    
    // Static view
    CareKitUI.NumericProgressTaskView(title: Text("Steps (Static)"),
                                      progress: Text("0"),
                                      goal: Text("100"),
                                      isComplete: false)

}

struct ActivityDetailView: View {
    
    let currentTask: OCKTask
    @State var activityTitle: String
    @State var activityAsset: String
    @State var activityInstructions: String
    @State var activitySchedule: String
    
    @State var restSeconds: Int = 3
    @State var exerciseSeconds: Int = 5
    
    @State private var scale: CGFloat = 1.0
    @State private var enlargeImage = false
    
    @State private var showVideo = false
    @State private var isYouTubeVideo = false
    
    @State private var showActivityPerformanceView = false
    
    @State var videoPath: String = "https://www.youtube.com/embed/JpiNdJNf114"
    var videoPath1 = "https://bit.ly/swswift"
    
//    @State private var youTubeURL: String = "https://www.youtube.com/embed/JpiNdJNf114"
    @State private var youTubeVideoID: String = ""
    @State private var validYouTubeURL = false
    
//    @Environment(\.storeManager) private var storeManager
        
    var body: some View {
        ZStack {
            Color.yellow.edgesIgnoringSafeArea(.all)
            enlargeImage ? AnyView( showEnlargeImage ) : AnyView( activityDetailScreen )
        }
    }
    
    var showEnlargeImage: some View {
        
        NavigationView {
//            ScrollView (.horizontal) {
                Image( self.activityAsset )
                    .resizable()
                    .scaleEffect(self.scale)
//                    .frame(width: 500, height: 500)
                    .gesture(MagnificationGesture()
                        .onChanged { value in
                            self.scale = value.magnitude
                        }
                    )
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Close") {
                                self.enlargeImage = false
                            }
                        }
                        
                    }
//            }   // End of ScrollView
        }   // End of NavigationView
    }   //  End of showEnlargeImage
    
    var activityDetailScreen: some View {
        
        VStack {
            GeometryReader { geometry in
                NavigationView {
                    ScrollView {
                        VStack{
                            if activityAsset != nil && !showVideo {
                                Image( activityAsset )
                                    .resizable()
                                    .scaledToFit()
                                    .onTapGesture {
                                        self.enlargeImage = true
                                    }
                            }
                            
                            if showVideo && videoPath1 != nil {
                                
                                if !isYouTubeVideo {
                                    
                                    videoPlayer(videoURL: URL(string: videoPath1)!).frame(height: 320)
                                }
                                else if isYouTubeVideo {
                                    
//                                    print("play YT Video")
                                    VStack {
                                      if validYouTubeURL {
                                        WebView(videoID: self.youTubeVideoID)
                                        .frame(height: 320)
                                             }
                                     }.onAppear {
                                         if let videoID = self.videoPath.extractYoutubeID() {
                                             videoPath = ""
                                             self.youTubeVideoID = videoID
                                             self.validYouTubeURL = true
                                         } else {
                                             videoPath = ""
                                         }
                                    }   //  End of VStack
                                }
                            }
                            
                            VStack {
                                Text( activityTitle )
                                    .font( .largeTitle )
                                    .multilineTextAlignment(.leading)
                                Spacer()
                                Text( activitySchedule ?? "" )
                                    .multilineTextAlignment(.leading)
                                Spacer()
                                Text( activityInstructions ?? "" )
        //                            .multilineTextAlignment(.center)
                                    .padding(.leading, 25)
                                    .padding(.trailing, 25)
                                Spacer()

                                Button {
                                    showActivityPerformanceView.toggle()
                                } label: {
                                    Text("Get Started")
                                        .padding()
//                                        .background(Color.pink.cornerRadius(8))
                                        .foregroundColor(Color.white)
                                }
                                .sheet(isPresented: $showActivityPerformanceView) {
                                    
                                } content: {
                                    ActivityPerformance(activityTitle: $activityTitle, activityAsset: $activityAsset, activitySchedule: $activitySchedule, activityInstructions: $activityInstructions, restSeconds: $restSeconds, exerciseSeconds: $exerciseSeconds)
                                }
                                .frame(width: 250, height: 50)
                                .background(Color.pink.cornerRadius( 8 ))
                                
                            }
                        }
                        
                    }
    //                .navigationTitle("Welcome")
                    .toolbar {
                        
                        ToolbarItem(placement: .navigationBarLeading) {
                            
                            if showVideo {
                                Button("Show Image") {
                                    print("Show image tapped!")
                                    self.showVideo = false
                                }
                            }
                            else {
                                Button("Watch Video") {
                                    print("Watch video tapped!")
                                    self.showVideo = true
                                    self.isYouTubeVideo = !isYouTubeVideo
                                }
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
            
            
            
        }
    }   //  End of activityDetailScreen
}   //  End of Struct ActivityDetailView


struct videoPlayer: UIViewControllerRepresentable {
    
    let videoURL: URL
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let avPlayerVC = AVPlayerViewController()

        let player = AVPlayer(url: videoURL)
        avPlayerVC.player = player
        player.play()
        return avPlayerVC
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        
    }
    
//    typealias UIViewControllerType = AVPlayerViewController
    
    
}

/*For YouTuve*/

 struct WebView: UIViewRepresentable {
     
     let videoID: String
     
     func makeUIView(context: Context) -> WKWebView {
         return WKWebView()
     }
     
     func updateUIView(_ uiView: WKWebView, context: Context) {
         guard let youTubeURL = URL(string:"https://www.youtube.com/embed/\(videoID)") else { return }

         uiView.scrollView.isScrollEnabled = false
         uiView.load(URLRequest(url: youTubeURL))
     }
 }

 extension String {
     func extractYoutubeID() -> String? {
         let pattern = "((?<=(v|V)/)|(?<=be/)|(?<=(\\?|\\&)v=)|(?<=embed/))([\\w-]++)"
         
         let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
         let range = NSRange(location: 0, length: self.count)
         
         guard let result = regex?.firstMatch(in: self, range: range) else { return nil }
         return (self as NSString).substring(with: result.range)
     }
 }
