//
//  LocationController.swift
//  RemindMe
//
//  Created by Garrett Votaw on 5/18/18.
//  Copyright © 2018 Garrett Votaw. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class LocationController: UITableViewController, MKLocalSearchCompleterDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    var locationRequest: MKLocalSearchRequest?
    var region: MKCoordinateRegion?
    var locations: [MKMapItem] = []
    lazy var manager: LocationManager = {
        return LocationManager(locationDelegate: self)
    }()
    var regionID: String?
    var monitoredRegion: CLRegion?
    var onArrival: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            try manager.requestWhenInUseAuthorization()
            try manager.requestAlwaysAuthorization()
            manager.requestLocation()
        } catch {
            print(error)
        }
        
        searchBar.delegate = self
        tableView.estimatedRowHeight = 73.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as! LocationCell
        guard !locations.isEmpty else {return cell}
        let placemark = locations[indexPath.row].placemark
        guard let city = placemark.locality, let state = placemark.administrativeArea, let address = placemark.thoroughfare, let zip = placemark.postalCode else {return cell}
        let formattedLocation = "\(address) \(city), \(state) \(zip)"
        cell.titleLabel.text = locations[indexPath.row].name
        cell.addressLabel.text = formattedLocation
        

        return cell
    }
    
    //MARK: - TEST CASE HERE
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let regionID = regionID else {return}
        guard let onArrival = onArrival else {return}
        
        //==========================================================================================
        
        let center = locations[indexPath.row].placemark.coordinate
        /*Simply uncomment the below line and add it into the below function as the center parameter. Then upon running the app, select the location button just above the console and choose "TestLocations". This will navigate in and out of the Apple Headquarters geofence and trigger continuous notifications ever 5 seconds or so. You can delete the reminder and it will remove monitoring process*/
        
        //let apple = CLLocationCoordinate2D(latitude: 37.331695, longitude: -122.0322801)
        
        monitorRegionAtLocation(center: center, identifier: regionID, onEntry: onArrival)
        
        //==========================================================================================
        
        navigationController?.popViewController(animated: true)
        let previousViewController = navigationController?.viewControllers[1] as! ReminderDetailsController
        previousViewController.monitoredRegion = monitoredRegion
    }
 

    func monitorRegionAtLocation(center: CLLocationCoordinate2D, identifier: String, onEntry: Bool) {
        // Make sure the app is authorized.
        if CLLocationManager.authorizationStatus() == .authorizedAlways {
            // Make sure region monitoring is supported.
            if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
                // Register the region.
                
                let region = CLCircularRegion(center: center, radius: 100.0, identifier: identifier)
                if onEntry {
                    region.notifyOnEntry = true
                    region.notifyOnExit = false
                } else {
                    region.notifyOnExit = true
                    region.notifyOnEntry = false
                }
                self.monitoredRegion = region
                
                
                manager.startMonitoring(region)
            }
        }
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("taco")
        let nextVC = segue.destination as! ReminderDetailsController
        nextVC.monitoredRegion = monitoredRegion
    }

}

// MARK: - Extensions

extension LocationController: LocationManagerDelegate {
    func obtainedCoordinates(_ location: CLLocation) {
        let region = MKCoordinateRegionMakeWithDistance(location.coordinate, 30000.0, 30000.0)
        self.region = region
        print("received coordinate")
    }
    
    func failedWithError(_ error: LocationError) {
        
    }
    
    func didChangeAuthorizationStatus(_ status: CLAuthorizationStatus) {
        
    }
    
    
}


extension LocationController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let region = region else {return}
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = searchText
        request.region = region
        locationRequest = request
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let request = locationRequest else {return}
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            if let response = response {
                self.locations = response.mapItems
                self.tableView.reloadData()
            }
            if let error = error {
                self.locations = []
                print("Tacos")
                print(error)
            }
        }
    }
}
