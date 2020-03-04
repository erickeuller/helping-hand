//
//  ConfigurationViewController.swift
//  HelpingHand
//
//  Created by Student on 03/03/20.
//  Copyright © 2020 Student. All rights reserved.
//

import UIKit
import SwiftCloudant
import Foundation

class ConfigurationViewController: UIViewController {

    @IBOutlet weak var soundInterval: UISlider!
    @IBOutlet weak var distanceSensibility: UISlider!
    
    let client = CouchDBClient(url:URL(string:"https://1fc81221-991d-4153-8784-026f5ca369e0-bluemix.cloudantnosqldb.appdomain.cloud")!, username:"1fc81221-991d-4153-8784-026f5ca369e0-bluemix", password:"98d3fc0cbd6afb73c7f88bef1e2ea58c06477b290bdf37b0fb340f7a07c8388b")
    let dbName = "helpinghand"
    var lastRev : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let read = GetDocumentOperation(id: "configuration", databaseName: dbName) { (response, httpInfo, error) in
            if let error = error {
                print("Encountered an error while reading a document. Error:\(error)")
            } else {
                DispatchQueue.main.async {
                    print("Read document: \(response)")
                    if let data = response {
                        self.soundInterval.value = (data["soundInterval"] as! NSNumber).floatValue
                        self.distanceSensibility.value = (data["distanceSensibility"] as! NSNumber).floatValue
                        self.lastRev = data["_rev"] as! String
                    }
                }
            }
        }
        client.add(operation:read)
    }
    
    @IBAction func save(_ sender: Any) {
        // Create a document
        let create = PutDocumentOperation(id: "configuration", body: ["soundInterval": soundInterval.value, "distanceSensibility": distanceSensibility.value, "_rev": lastRev!], databaseName: dbName) {(response, httpInfo, error) in
            if let error = error as? SwiftCloudant.Operation.Error {
                switch error {
                case .http(let httpError):
                    print("http error status code: \(httpError.statusCode)  response: \(httpError.response)")
                default:
                    print("Encountered an error while creating a document. Error:\(error)")
                }
            } else {
                print("Created document \(response?["id"]) with revision id \(response?["rev"])")
            }
        }
        client.add(operation:create)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
