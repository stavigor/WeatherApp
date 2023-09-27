//
//  WebViewVC.swift
//  WeatherApp
//
//  Created by Игорь Растегаев on 27.09.2023.
//

import UIKit
import SafariServices
import CoreLocation


class WebViewVC: UIViewController {
    
    @IBOutlet weak var holderView: UIView!
    
    let locationManager = CLLocationManager()
    var safariVC: SFSafariViewController!
    static var link = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestLocation()

        
    }
    

    func addViewControllerAsChildViewController(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
//        let urlString = "https://openweathermap.org/weathermap?basemap=map&cities=true&layer=temperature&zoom=10&&lat=\(latitude)&lon=\(longitude)"
        let urlString = "https://m.openweathermap.org/"
        print(urlString)
        safariVC = SFSafariViewController(url: URL(string: urlString)!)
        addChild(safariVC)
        self.view.addSubview(safariVC.view)
        safariVC.didMove(toParent: self)
        safariVC.isEditing = true
        self.setUpConstraints()
    }

    func setUpConstraints() {
        self.safariVC.view.translatesAutoresizingMaskIntoConstraints = false
        self.safariVC.view.topAnchor.constraint(equalTo: self.holderView.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        self.safariVC.view.bottomAnchor.constraint(equalTo: self.holderView.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        self.safariVC.view.leadingAnchor.constraint(equalTo: self.holderView.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        self.safariVC.view.trailingAnchor.constraint(equalTo: self.holderView.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
    }
}

//MARK: - CLLocationDelegate
extension WebViewVC: CLLocationManagerDelegate {
        
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            addViewControllerAsChildViewController(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
