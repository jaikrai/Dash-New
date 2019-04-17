//
//  IntentHandler.swift
//  MotivationIntent
//
//  Created by Jared Breedlove on 4/17/19.
//  Copyright © 2019 iMac. All rights reserved.
//

import Intents
import CoreData

class IntentHandler: INExtension {
    
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        let fetchRequest: NSFetchRequest<Board> = Board.fetchRequest()
        do{
            let boardName = try PersistenceService.context.fetch(fetchRequest)
           print(boardName.count)
            
        }catch{
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
        
        guard intent is MotivateIntent else {
            fatalError("Unhandled intent type: \(intent)")
        }
        
        return MotivateIntentHandler()
    }
    
}
