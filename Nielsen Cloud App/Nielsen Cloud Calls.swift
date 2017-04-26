//
//  Nielsen Cloud Calls.swift
//  Nielsen Cloud App
//
//  Created by Nielsen on 4/9/17.
//  Copyright © 2017 Nielsen. All rights reserved.
//

import Foundation


func NielsenCloud(Cloud_Event: String, Playhead_Time: String){
    
    
    let utcString = floor(Date().timeIntervalSince1970)
    
    let payloadString = "{\"devInfo\": {\"devId\": \"\(devid)\", \"apn\": \"\(apn)\", \"apv\": \"\(apv)\", \"uoo\": \"\(uoo)\"},"
    
    let metadataString = "\"metadata\": {\"static\": {}, \"content\": { \"type\": \"content\", \"assetid\": \"\(assetid)\", \"isfullepisode\": \"\(isfullepisode)\", \"program\": \"\(program)\", \"title\": \"\(title)\", \"length\": \"\(length)\", \"segB\": \"\(segB)\", \"segC\": \"\(segC)\", \"crossId1\": \"\(crossId1)\", \"crossId2\": \"\(crossId2)\", \"airdate\": \"\(airdate)\", \"adloadtype\": \"\(adloadtype)\", \"hasAds\": \"\(hasAds)\", \"progen\": \"\(progen)\"}, \"ad\": {}},"
    
    let eventString = "\"event\": \"\(Cloud_Event)\", \"position\": \"\(Playhead_Time)\", \"type\": \"content\", \"utc\": \"\(utcString)\"}"
    
    let fullPayloadString = payloadString + metadataString + eventString
    
    let urlString = "http://sandbox.cloudapi.imrworldwide.com/nmapi/v2/\(apid)/\(sessionID)/a?b=\(fullPayloadString)"
    
    let urlwithPercentEscapes = urlString.addingPercentEncoding( withAllowedCharacters: NSCharacterSet.urlQueryAllowed)

    sendGETRequest(url: urlwithPercentEscapes!)
}

func sendGETRequest(url: String) {
    var request = URLRequest(url: URL(string: url)!)
request.httpMethod = "GET"
let session = URLSession.shared

session.dataTask(with: request) {data, response, err in
    print("Entered the completionHandler")
    }.resume()
}
