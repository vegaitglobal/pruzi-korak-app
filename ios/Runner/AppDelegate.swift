import UIKit
import Flutter
import HealthKit

@main
@objc class AppDelegate: FlutterAppDelegate {
    
    let healthStore = HKHealthStore()
    let stepCountType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
    var flutterChannel: FlutterMethodChannel?
    let includeManualSteps = false

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        let controller = window?.rootViewController as! FlutterViewController
        flutterChannel = FlutterMethodChannel(
            name: "org.pruziKorak.healthkit/callback",
            binaryMessenger: controller.binaryMessenger
        )

        flutterChannel?.setMethodCallHandler { [weak self] call, result in
            guard let self = self else {
                result(FlutterError(code: "internal", message: "self is nil", details: nil))
                return
            }

            switch call.method {
            case "getStepsToday":
                self.fetchStepsToday { steps in
                    result(steps)
                }

            case "getStepsFromCampaignStart":
                if let timestamp = call.arguments as? Double {
                    let campaignStart = Date(timeIntervalSince1970: timestamp)
                    self.fetchStepsFromCampaignStart(campaignStart) { steps in
                        result(steps)
                    }
                } else {
                    result(FlutterError(code: "invalid_argument", message: "Expected timestamp", details: nil))
                }

            default:
                result(FlutterMethodNotImplemented)
            }
        }

        if HKHealthStore.isHealthDataAvailable() {
            print("📥 Requesting HealthKit authorization...")
            requestHealthKitAuthorization()
        }

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    private func requestHealthKitAuthorization() {
        healthStore.requestAuthorization(toShare: nil, read: [stepCountType]) { [weak self] success, error in
            DispatchQueue.main.async {
                if success {
                    print("✅ HealthKit authorization granted")
                    self?.enableBackgroundDelivery()
                    self?.observeStepChanges()
                } else if let error = error {
                    print("❌ HealthKit authorization error: \(error.localizedDescription)")
                } else {
                    print("❌ HealthKit authorization failed for unknown reason")
                }
            }
        }
    }

    private func observeStepChanges() {
        let query = HKObserverQuery(sampleType: stepCountType, predicate: nil) { [weak self] _, _, error in
            guard error == nil else {
                print("❌ ObserverQuery error: \(error!.localizedDescription)")
                return
            }

            print("📡 Step count change detected")
            self?.notifyFlutterAboutStepChange()
        }

        healthStore.execute(query)
    }

    private func enableBackgroundDelivery() {
        healthStore.enableBackgroundDelivery(for: stepCountType, frequency: .immediate) { success, error in
            if success {
                print("✅ Background delivery enabled for stepCount")
            } else if let error = error {
                print("❌ Failed to enable background delivery: \(error.localizedDescription)")
            }
        }
    }

    private func notifyFlutterAboutStepChange() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.flutterChannel?.invokeMethod("stepCountChanged", arguments: nil)
        }
    }
    
    func fetchStepsToday(completion: @escaping (Double) -> Void) {
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        fetchSteps(from: startOfDay, to: now, includeManual: includeManualSteps, completion: completion)
    }

    func fetchStepsFromCampaignStart(_ campaignStart: Date, completion: @escaping (Double) -> Void) {
        let now = Date()
        fetchSteps(from: campaignStart, to: now, includeManual: includeManualSteps, completion: completion)
    }

    private func fetchSteps(from startDate: Date, to endDate: Date, includeManual: Bool = false, completion: @escaping (Double) -> Void) {
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        let query = HKSampleQuery(
            sampleType: stepCountType,
            predicate: predicate,
            limit: HKObjectQueryNoLimit,
            sortDescriptors: nil
        ) { _, results, error in
            guard let stepSamples = results as? [HKQuantitySample], error == nil else {
                print("❌ SampleQuery error: \(error?.localizedDescription ?? "unknown")")
                completion(0)
                return
            }
            let filteredSamples = includeManual ? stepSamples : stepSamples.filter { step in
                let isUserEntered = step.sourceRevision.source.name == "Health" || (step.metadata?[HKMetadataKeyWasUserEntered] as? Bool ?? false)
                return !isUserEntered
            }
            let totalSteps = filteredSamples.reduce(0.0) { total, step in total + step.quantity.doubleValue(for: .count()) }
            completion(totalSteps)
        }
        healthStore.execute(query)
    }
}
