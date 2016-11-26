//
//  LocationManager.swift
//  MapTodo
//
//  Created by Hitomi Fukushima on 2016/11/26.
//  Copyright © 2016年 fukushima. All rights reserved.
//

import Foundation
import CoreData
import CoreLocation
import MapKit


final class LocationManager: NSObject, CLLocationManagerDelegate {
    static let sharedLocationManager = LocationManager()
    private let lm: CLLocationManager = CLLocationManager()
    private override init() {
        super.init()
        lm.delegate = self
        //lm.requestWhenInUseAuthorization()
        lm.requestAlwaysAuthorization()

        lm.desiredAccuracy = kCLLocationAccuracyBestForNavigation //測定の制度を設定
        lm.pausesLocationUpdatesAutomatically=false //位置情報が自動的にOFFにならない様に設定
        lm.distanceFilter=100.0// 100m以上移動した場合に位置情報を取得

    }
    
    func startMonitoring(center: CLLocationCoordinate2D, radius: Double, identifier: String) {
        lm.startMonitoring(for: CLCircularRegion.init(center: center, radius: radius, identifier: identifier))
    }

    func stopMonitoring(center: CLLocationCoordinate2D, radius: Double, identifier: String) {
        lm.stopMonitoring(for: CLCircularRegion.init(center: center, radius: radius, identifier: identifier))
    }
    
    func monitoredRegionsCount() -> Int {
        return lm.monitoredRegions.count
    }

    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        let predicate: NSPredicate = NSPredicate(format: "uuid = %@", argumentArray: [region.identifier])
        let place = Place.mr_findFirst(with: predicate)! as Place
        let notification = UILocalNotification()
        notification.alertBody = place.name! + "に到着"
        UIApplication.shared.scheduleLocalNotification(notification)
    }
}

