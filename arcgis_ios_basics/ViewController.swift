//
//  ViewController.swift
//  arcgis_ios_basics
//
//  Created by Batuhan Duzgun on 02/12/2017.
//  Copyright © 2017 Batuhan Duzgun. All rights reserved.
//

import UIKit
import ArcGIS

class ViewController: UIViewController {

    @IBOutlet var mapView: AGSMapView!
    
    let portal = AGSPortal(url: URL(string: "https://www.arcgis.com")!, loginRequired: false)
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        let portalItem = AGSPortalItem(portal: self.portal, itemID: "8e9cc9c6906e46768b58919724af1208")
        let map = AGSMap(item: portalItem)
            
        map.load(completion: {[weak self] (error) in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            if map.bookmarks.count > 0 {
                print(map.bookmarks.count)
            }
            self?.mapView.map = map
        })
        
        self.mapView.layerViewStateChangedHandler = { (layer:AGSLayer, state:AGSLayerViewState) in
            switch state.status {
            case AGSLayerViewStatus.active:print("Active - ", layer.name)
            case AGSLayerViewStatus.notVisible:print("Not Visible - ", layer.name)
            case AGSLayerViewStatus.outOfScale:print("Out of Scale - ", layer.name)
            case AGSLayerViewStatus.loading:print("Loading - ", layer.name)
            case AGSLayerViewStatus.error:print("Error - ", layer.name)
            default:print("Unknown - ", layer.name)
            }
        }
        
        self.mapView.addObserver(self, forKeyPath: #keyPath(AGSMapView.drawStatus), options: .new, context: nil)

        self.mapView.locationDisplay.start { (error) in
            guard error == nil else {
                print(error!.localizedDescription)
                UIAlertView(title: "Error", message: error?.localizedDescription, delegate: nil, cancelButtonTitle: "Ok").show()
                return
            }
            print("Location Display Started ...")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if self.mapView.drawStatus == .inProgress {
            print("In progress ...")
        }
        else {
            print("Free to draw ...")
        }
    }
}

