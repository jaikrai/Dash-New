//
//  IntentViewController.swift
//  MotivationIntentUI
//
//  Created by Jared Breedlove on 4/17/19.
//  Copyright © 2019 iMac. All rights reserved.
//

import IntentsUI
import CoreData

// As an example, this extension's Info.plist has been configured to handle interactions for INSendMessageIntent.
// You will want to replace this or add other intents as appropriate.
// The intents whose interactions you wish to handle must be declared in the extension's Info.plist.

// You can test this example integration by saying things to Siri like:
// "Send a message using <myApp>"

class IntentViewController: UIViewController, INUIHostedViewControlling {
    
    var board: Board!
    var imageViews: [UIImageView] = []
    var labelViews: [UILabel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let fetchRequest: NSFetchRequest<Board> = Board.fetchRequest()
        do{
            let boardList = try PersistenceService.context.fetch(fetchRequest)
            board = boardList[Int(arc4random_uniform(UInt32(boardList.count)))]
        }catch{
            print("The fetch could not be performed: \(error.localizedDescription)")
        }
        loadImages()
        loadQuotes()
        print("Loaded Images and Quotes")
    }
        
    // MARK: - INUIHostedViewControlling
    
    // Prepare your view controller for the interaction to handle.
    func configureView(for parameters: Set<INParameter>, of interaction: INInteraction, interactiveBehavior: INUIInteractiveBehavior, context: INUIHostedViewContext, completion: @escaping (Bool, Set<INParameter>, CGSize) -> Void) {
        // Do configuration here, including preparing views and calculating a desired size for presentation.

        completion(true, parameters, self.desiredSize)
    }
    
    var desiredSize: CGSize {
        return self.extensionContext!.hostedViewMaximumAllowedSize
    }
    
    func loadQuotes(){
        labelViews.removeAll()
        for quote in (board.quotes!){
            let curQuote = quote as! Quote
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
            label.center = CGPoint(x: CGFloat(curQuote.xpos), y: CGFloat(curQuote.ypos))
            label.textAlignment = .center
            label.text = curQuote.text
            label.font = label.font.withSize(CGFloat(curQuote.fontSize))
            self.view.addSubview(label)
            labelViews.append(label)
        }
    }
    
    func loadImages(){
        imageViews.removeAll()
        for image in (board.images!){
            let curImage = image as! Image
            let imageview = UIImageView (image: UIImage.init(data: curImage.picture! as Data))
            imageview.frame = CGRect (x: CGFloat(curImage.xpos), y: CGFloat(curImage.ypos), width: CGFloat(curImage.width) , height: CGFloat(curImage.height))
            self.view.addSubview(imageview)
            imageViews.append(imageview)
            
        }
    }
}
