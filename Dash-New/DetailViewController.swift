//
//  File.swift
//  Dash-New
//
//  Created by iMac on 4/10/19.
//  Copyright © 2019 iMac. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    var board: Board!
    var boardId: String = ""
    var imageViews: [UIImageView] = []
    var labelViews: [UILabel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fetchRequest: NSFetchRequest<Board> = Board.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", boardId)
        do{
            let boardName = try PersistenceService.context.fetch(fetchRequest)
            board = boardName.first
            
        }catch{
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }

        loadQuotes()
        loadImages()
        //print(board1)
    }
    
    func loadQuotes(){
        for quote in (board.quotes!){
            let curQuote = quote as! Quote
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
            label.isUserInteractionEnabled = true
            label.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(DetailViewController.draggedText(_:))))
            label.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(DetailViewController.scaleImage(_:))))
            label.center = CGPoint(x: Int(curQuote.xpos), y: Int(curQuote.ypos))
            label.textAlignment = .center
            label.text = curQuote.text
            self.view.addSubview(label)
            labelViews.append(label)
            }
    }
    
    func loadImages(){
        for image in (board.images!){
            let curImage = image as! Image
            let imageview = UIImageView (image: UIImage.init(data: curImage.picture as! Data))
        imageview.isUserInteractionEnabled = true
        imageview.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(DetailViewController.draggedImage(_:))))
        imageview.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(DetailViewController.scaleImage(_:))))
            imageview.frame = CGRect (x: Int(curImage.xpos), y: Int(curImage.ypos), width: 100 , height: 100)

        self.view.addSubview(imageview)
        imageViews.append(imageview)

        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func pickImagePressed(_ sender: Any) {
        let image = UIImagePickerController()
        image.delegate = self
        
        image.sourceType = UIImagePickerController.SourceType.photoLibrary
        
        image.allowsEditing = false
        
        self.present(image, animated: true)
        {
            
        }
    }
    @IBAction func addText(_ sender: Any) {
        let alert = UIAlertController(title: "Create Board", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Text"
        }
        
        let action = UIAlertAction(title: "Save", style: .default) { action in
            let title = alert.textFields!.first!.text!;
            print(title)
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
            label.isUserInteractionEnabled = true
            label.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(DetailViewController.draggedText(_:))))
            label.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(DetailViewController.scaleImage(_:))))
            label.center = CGPoint(x: 160, y: 285)
            label.textAlignment = .center
            label.text = title
            self.view.addSubview(label)
            self.labelViews.append(label)
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        
        let imageview = UIImageView (image: image)
        imageview.isUserInteractionEnabled = true
        imageview.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(DetailViewController.draggedImage(_:))))
        imageview.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(DetailViewController.scaleImage(_:))))
        self.view.addSubview(imageview)
        imageview.frame = CGRect (x: 20, y: 20, width: 100 , height: 100)
        self.imageViews.append(imageview)
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @objc func draggedImage(_ sender:UIPanGestureRecognizer){
        print("Drag Function")
        let viewDrag = sender.view! as! UIImageView
        
        self.view.bringSubviewToFront(viewDrag)
        let translation = sender.translation(in: self.view)
        viewDrag.center = CGPoint(x: viewDrag.center.x + translation.x, y: viewDrag.center.y + translation.y)
        sender.setTranslation(CGPoint.zero, in: self.view)
    }
    
    @objc func draggedText(_ sender:UIPanGestureRecognizer){
        print("Drag Function")
        let viewDrag = sender.view! as! UILabel
        
        self.view.bringSubviewToFront(viewDrag)
        let translation = sender.translation(in: self.view)
        viewDrag.center = CGPoint(x: viewDrag.center.x + translation.x, y: viewDrag.center.y + translation.y)
        sender.setTranslation(CGPoint.zero, in: self.view)
    }
    
    @objc func scaleImage(_ sender: UIPinchGestureRecognizer) {
        print("Scale Function")
        sender.view!.transform = CGAffineTransform(scaleX: sender.scale, y: sender.scale)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("Closing Board: "  + self.board.id!)
        for image in self.board.images!{
            let curImage = image as! Image
            self.board.removeFromImages(curImage)
        }
        PersistenceService.saveContext()
        print("Removed All images")
        for quote in self.board.quotes!{
            let curQuote = quote as! Quote
            self.board.removeFromQuotes(curQuote)
        }
        PersistenceService.saveContext()
        print("Removed All Quotes")
        for imageView in self.imageViews {
            print("Creating Image")
            let boardImage = Image(context: PersistenceService.context)
            boardImage.picture = NSData(data: imageView.image!.pngData()!)
            boardImage.xpos = Float(imageView.frame.origin.x)
            boardImage.ypos = Float(imageView.frame.origin.y)
            boardImage.scale = 1
            boardImage.layer = 1
            self.board.addToImages(boardImage)
        }
        PersistenceService.saveContext()
        print("Added All Images")
        for labelView in self.labelViews {
            let quote = Quote(context: PersistenceService.context)
            quote.text = labelView.text!
            quote.xpos = Float(labelView.center.x)
            quote.ypos = Float(labelView.center.y)
            quote.scale = 1
            quote.layer = 1
            self.board.addToQuotes(quote)
        }
        PersistenceService.saveContext()
        print("Added All Quotes")
    }
}
