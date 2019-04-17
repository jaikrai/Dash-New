
import UIKit
import CoreData

class NSCustomPersistentContainer: NSPersistentContainer {
    
    override open class func defaultDirectoryURL() -> URL {
        var storeURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.PrometheusConsulting.dash")
        storeURL = storeURL?.appendingPathComponent("Dash-New.sqlite")
        return storeURL!
    }
    
}
