//
//  MotivateIntentHandler.swift
//  MotivationIntent
//
//  Created by Jared Breedlove on 4/17/19.
//  Copyright © 2019 iMac. All rights reserved.
//

import Foundation
import CoreData

class MotivateIntentHandler: NSObject, MotivateIntentHandling{
    func confirm(intent: MotivateIntent, completion: @escaping (MotivateIntentResponse) -> Void) {
            completion(MotivateIntentResponse(code: .ready, userActivity: nil))
        }
    
    func handle(intent: MotivateIntent, completion: @escaping (MotivateIntentResponse) -> Void) {
        let fetchRequest: NSFetchRequest<Affirmation> = Affirmation.fetchRequest()
        do{
            let affirmationList = try PersistenceService.context.fetch(fetchRequest)
            let randAffirmation = affirmationList[Int(arc4random_uniform(UInt32(affirmationList.count)))]
            
            completion(MotivateIntentResponse.success(test: randAffirmation.title!))
        }catch{
            print("The fetch could not be performed: \(error.localizedDescription)")
            completion(MotivateIntentResponse(code: .failure, userActivity: nil))
        }
    }
}
