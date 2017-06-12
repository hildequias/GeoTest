//
//  ViewController.swift
//  SampleTest
//
//  Created by Hildequias Junior on 6/12/17.
//  Copyright © 2017 Pixonsoft. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var btnTurn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnTurn(_ sender: UIButton) {
        
        switch sender.tag {
        case 0:
            sender.setTitle("Turn Off", for: .normal)
            sender.tag = 1
            BackgroundLocationManager.instance.start()
            break
        
        case 1:
            sender.setTitle("Turn On", for: .normal)
            sender.tag = 0
            BackgroundLocationManager.instance.stop()
            self.performSegue(withIdentifier: "detailSegue", sender: nil)
            break
            
        default:
            break
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "detailSegue") {
            let detailVC = segue.destination as! DetailViewController
            detailVC.geolocations = BackgroundLocationManager.instance.geolocations
        }
    }
}

