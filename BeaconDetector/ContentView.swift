import SwiftUI
import Combine
import CoreLocation

class BeaconDetector: NSObject, ObservableObject, CLLocationManagerDelegate {
    var didChange = PassthroughSubject<CLProximity, Never>()
    var locationManager:  CLLocationManager?
    var lastDistance = CLProximity.unknown
    
    override init() {
        super.init()
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.requestAlwaysAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if (CLLocationManager.isRangingAvailable()) {
                    startScanning()
                }
            }
        } else if (status == .authorizedAlways) {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if (CLLocationManager.isRangingAvailable()) {
                    startScanning()
                }
            }
        }
    }
    
    func startScanning() {
        let uuid = UUID(uuidString: "FFFE2D12-1E4B-0FA4-994E-CEB531F40545")!
        let constraint = CLBeaconIdentityConstraint(uuid: uuid, major: 13330, minor: 30806)
        let beaconRegion = CLBeaconRegion(beaconIdentityConstraint: constraint, identifier: "bitlock MINI")
        locationManager?.startMonitoring(for: beaconRegion)
        locationManager?.startRangingBeacons(satisfying: constraint)
    }
    
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        print("didDetermineState")
    }
    
    func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying beaconConstraint: CLBeaconIdentityConstraint) {
        print("didRange Event beacons:---------------------------------------------------------------------------------")
        if let beacon = beacons.first {
            print("beacon:",beacon)
            update(distance: beacon.proximity)
        } else {
            update(distance: .unknown)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("didEnterRegion")
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("didExitRegion")
    }
    
    func update(distance: CLProximity) {
        lastDistance = distance
        print("lastDistance",lastDistance.rawValue)
        didChange.send(lastDistance)
    }
}

struct BigText: ViewModifier {
    func body(content: Content) -> some View {
        content.font(Font.system(size: 35, design: .rounded)).frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealWidth: .infinity, maxWidth: 0,  maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
    }
}

struct ContentView: View {
    @ObservedObject var detector = BeaconDetector()
    var body: some View {
        if detector.lastDistance == .immediate {
            return Text("RIGHT HERE")
                .modifier(BigText())
                .background(Color.gray)
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            
        } else if detector.lastDistance == .near{
            return Text("NEAR")
                .modifier(BigText())
                .background(Color.gray)
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            
        } else if (detector.lastDistance == .far) {
            return Text("FAR")
                .modifier(BigText())
                .background(Color.gray)
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            
        } else {
            return Text("iBeacon Detector")
                .modifier(BigText())
                .background(Color.gray)
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
