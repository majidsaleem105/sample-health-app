//
//  AppDelegate.swift
//  new sample app
//
//  Created by Majid on 13/12/2021.
//

import CareKit
import CareKitStore
import Contacts
import UIKit
import HealthKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    lazy private(set) var coreDataStore = OCKStore(name: "SampleAppStore", type: .inMemory)
    lazy private(set) var healthKitStore = OCKHealthKitPassthroughStore(store: coreDataStore)

    lazy private(set) var synchronizedStoreManager: OCKSynchronizedStoreManager = {
        let coordinator = OCKStoreCoordinator()
        coordinator.attach(eventStore: healthKitStore)
        coordinator.attach(store: coreDataStore)
        return OCKSynchronizedStoreManager(wrapping: coordinator)
    }()
    
    private(set) lazy var peer = OCKWatchConnectivityPeer()
    private(set) lazy var cdStore = OCKStore(name: "carekit-catalog-cd", type: .inMemory, remote: peer)
    private(set) lazy var hkStore = OCKHealthKitPassthroughStore(store: cdStore)

    private lazy var sessionManager: SessionManager = {
        let sessionManager = SessionManager()
        sessionManager.peer = self.peer
        sessionManager.store = self.cdStore
        return sessionManager
    }()

    private(set) lazy var storeManager: OCKSynchronizedStoreManager = {

//        cdStore.fillWithDummyData()
//        hkStore.fillWithDummyData()

        let coordinator = OCKStoreCoordinator()
        coordinator.attach(store: cdStore)
        coordinator.attach(eventStore: hkStore)

        return OCKSynchronizedStoreManager(wrapping: coordinator)
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        coreDataStore.populateSampleData()
        healthKitStore.populateSampleData()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func getTopMostViewController() -> UIViewController? {
        
//        var topMostViewController = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController
        
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        var topMostViewController = window?.rootViewController
        
        while let presentedViewController = topMostViewController?.presentedViewController {
            topMostViewController = presentedViewController
        }

        return topMostViewController
    }
    
    func dismissTopMostViewController() {
        
//        var topMostViewController = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController
        
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        var topMostViewController = window?.rootViewController
        
        while let presentedViewController = topMostViewController?.presentedViewController {
            topMostViewController = presentedViewController
        }

        topMostViewController?.dismiss(animated: true, completion: nil)
//        return topMostViewController
    }

}


private extension OCKStore {

    // Adds tasks and contacts into the store
    func populateSampleData() {

        let thisMorning = Calendar.current.startOfDay(for: Date())
        let aFewDaysAgo = Calendar.current.date(byAdding: .day, value: -4, to: thisMorning)!
        let beforeBreakfast = Calendar.current.date(byAdding: .hour, value: 8, to: aFewDaysAgo)!
        let afterLunch = Calendar.current.date(byAdding: .hour, value: 14, to: aFewDaysAgo)!

        let schedule = OCKSchedule(composing: [
            OCKScheduleElement(start: beforeBreakfast, end: nil,
                               interval: DateComponents(day: 1)),

            OCKScheduleElement(start: afterLunch, end: nil,
                               interval: DateComponents(day: 2))
        ])

        var doxylamine = OCKTask(id: "doxylamine", title: "Take Doxylamine",
                                 carePlanUUID: nil, schedule: schedule)
        doxylamine.instructions = "Take 25mg of doxylamine when you experience nausea."
        doxylamine.asset = "" //posterior-plank
        let nauseaSchedule = OCKSchedule(composing: [
            OCKScheduleElement(start: beforeBreakfast, end: nil, interval: DateComponents(day: 1),
                               text: "Anytime throughout the day", targetValues: [], duration: .allDay)
            ])

        var nausea = OCKTask(id: "nausea", title: "Track your nausea",
                             carePlanUUID: nil, schedule: nauseaSchedule)
        nausea.asset = "" // hand-up-down
        nausea.impactsAdherence = false
        nausea.instructions = "Tap the button below anytime you experience nausea."

        let kegelElement = OCKScheduleElement(start: beforeBreakfast, end: nil, interval: DateComponents(day: 2))
        let kegelSchedule = OCKSchedule(composing: [kegelElement])
        var kegels = OCKTask(id: "kegels", title: "Kegel Exercises", carePlanUUID: nil, schedule: kegelSchedule)
        kegels.asset = "" //posterior-plank
        kegels.impactsAdherence = true
        kegels.instructions = "Perform kegel exercies"
        
        var nsh = OCKTask(id: "nsh", title: "Track Your Performance", carePlanUUID: nil, schedule: kegelSchedule)
        nsh.impactsAdherence = true
        nsh.instructions = "Perform kegel exercies"
        
        var homeass = OCKTask(id: "homeass", title: "Study Plan", carePlanUUID: nil, schedule: kegelSchedule)
        homeass.impactsAdherence = true
        homeass.instructions = "Perform kegel exercies"
        

        addTasks([nausea, doxylamine, kegels, nsh, homeass], callbackQueue: .main, completion: nil)

        var contact1 = OCKContact(id: "jane", givenName: "Jane",
                                  familyName: "Daniels", carePlanUUID: nil)
        contact1.asset = "JaneDaniels"
        contact1.title = "Family Practice Doctor"
        contact1.role = "Dr. Daniels is a family practice doctor with 8 years of experience."
        contact1.emailAddresses = [OCKLabeledValue(label: CNLabelEmailiCloud, value: "janedaniels@icloud.com")]
        contact1.phoneNumbers = [OCKLabeledValue(label: CNLabelWork, value: "(324) 555-7415")]
        contact1.messagingNumbers = [OCKLabeledValue(label: CNLabelWork, value: "(324) 555-7415")]

        contact1.address = {
            let address = OCKPostalAddress()
            address.street = "2598 Reposa Way"
            address.city = "San Francisco"
            address.state = "CA"
            address.postalCode = "94127"
            return address
        }()

        var contact2 = OCKContact(id: "matthew", givenName: "Matthew",
                                  familyName: "Reiff", carePlanUUID: nil)
        contact2.asset = "MatthewReiff"
        contact2.title = "OBGYN"
        contact2.role = "Dr. Reiff is an OBGYN with 13 years of experience."
        contact2.phoneNumbers = [OCKLabeledValue(label: CNLabelWork, value: "(324) 555-7415")]
        contact2.messagingNumbers = [OCKLabeledValue(label: CNLabelWork, value: "(324) 555-7415")]
        contact2.address = {
            let address = OCKPostalAddress()
            address.street = "396 El Verano Way"
            address.city = "San Francisco"
            address.state = "CA"
            address.postalCode = "94127"
            return address
        }()

        addContacts([contact1, contact2])
    }
}

extension OCKHealthKitPassthroughStore {

    func populateSampleData() {

        let schedule = OCKSchedule.dailyAtTime(
            hour: 8, minutes: 0, start: Date(), end: nil, text: nil,
            duration: .hours(12), targetValues: [OCKOutcomeValue(2000.0, units: "Steps")])

        let steps = OCKHealthKitTask(
            id: "steps",
            title: "Steps",
            carePlanUUID: nil,
            schedule: schedule,
            healthKitLinkage: OCKHealthKitLinkage(
                quantityIdentifier: .stepCount,
                quantityType: .cumulative,
                unit: .count()))

        addTasks([steps]) { result in
            switch result {
            case .success: print("Added tasks into HealthKitPassthroughStore!")
            case .failure(let error): print("Error: \(error)")
            }
        }
    }
}

private class SessionManager: NSObject {

    fileprivate var peer: OCKWatchConnectivityPeer!
    fileprivate var store: OCKStore!

    func session(
//        _ session: WCSession,
        didReceiveMessage message: [String: Any],
        replyHandler: @escaping ([String: Any]) -> Void) {

        print("Did receive message!")

        peer.reply(to: message, store: store) { reply in
            replyHandler(reply)
        }
    }
}
