//
//  CloudantClient.swift
//  HelpingHand
//
//  Created by Student on 04/03/20.
//  Copyright © 2020 Student. All rights reserved.
//

import Foundation
import SwiftCloudant

class CloudantClient {
    
    static let client = CouchDBClient(url:URL(string:"https://1fc81221-991d-4153-8784-026f5ca369e0-bluemix.cloudantnosqldb.appdomain.cloud")!, username:"1fc81221-991d-4153-8784-026f5ca369e0-bluemix", password:"98d3fc0cbd6afb73c7f88bef1e2ea58c06477b290bdf37b0fb340f7a07c8388b")
    static let dbName = "helpinghand"
}
