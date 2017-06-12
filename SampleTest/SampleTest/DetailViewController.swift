//
//  DetailViewController.swift
//  SampleTest
//
//  Created by Hildequias Junior on 6/12/17.
//  Copyright © 2017 Pixonsoft. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var txResult: UITextView!
    var geolocations: [Geolocation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        txResult.text = Utils().createJSON(geolocation: geolocations)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
