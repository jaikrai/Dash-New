//
//  MotivateIntentHandler.swift
//  MotivationIntent
//
//  Created by Jared Breedlove on 4/17/19.
//  Copyright © 2019 iMac. All rights reserved.
//

import Foundation

class MotivateIntentHandler: NSObject, MotivateIntentHandling{
    func confirm(intent: MotivateIntent, completion: @escaping (MotivateIntentResponse) -> Void) {
            completion(MotivateIntentResponse(code: .ready, userActivity: nil))
        }
    
    func handle(intent: MotivateIntent, completion: @escaping (MotivateIntentResponse) -> Void) {

                completion(MotivateIntentResponse.success(test: "TEST"))
            }
}
