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

    @IBOutlet weak var volume: UISlider!
    @IBOutlet weak var distanceSensibility: UISlider!

    var lastRev : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let read = GetDocumentOperation(id: "configuration", databaseName: CloudantClient.dbName) { (response, httpInfo, error) in
            if let error = error {
                print("Encountered an error while reading a document. Error:\(error)")
            } else {
                DispatchQueue.main.async {
                    print("Read document: \(response)")
                    if let data = response {
                        self.volume.value = (data["volume"] as! NSNumber).floatValue
                        self.distanceSensibility.value = (data["distanceSensibility"] as! NSNumber).floatValue
                        self.lastRev = data["_rev"] as! String
                    }
                }
            }
        }
        CloudantClient.client.add(operation:read)
    }
    
    @IBAction func save(_ sender: Any) {
        // Create a document
        let create = PutDocumentOperation(id: "configuration", body: ["volume": volume.value, "distanceSensibility": distanceSensibility.value, "_rev": lastRev!], databaseName: CloudantClient.dbName) {(response, httpInfo, error) in
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
        CloudantClient.client.add(operation:create)
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
