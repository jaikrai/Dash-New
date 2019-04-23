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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setToolbarHidden(false, animated: true)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(share(sender:)))
        let fetchRequest: NSFetchRequest<Board> = Board.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", boardId)
        do{
            let boardName = try PersistenceService.context.fetch(fetchRequest)
            board = boardName.first
        }catch{
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
        loadImages()
        title = board.title
    }
    
    @objc func share(sender:UIView){
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let objectsToShare = [image] as! [UIImage]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = sender
            self.present(activityVC, animated: true, completion: nil)
    }
    
    func loadImages(){
        imageViews.removeAll()
        for image in (board.images!){
            let curImage = image as! Image
            let imageview = UIImageView (image: UIImage.init(data: curImage.picture! as Data))
        imageview.isUserInteractionEnabled = true
        imageview.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(DetailViewController.draggedImage(_:))))
        imageview.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(DetailViewController.scaleImage(_:))))
        imageview.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(deleteItem(_:))))
        imageview.frame = CGRect (x: CGFloat(curImage.xpos), y: CGFloat(curImage.ypos), width: CGFloat(curImage.width) , height: CGFloat(curImage.height))
        self.view.addSubview(imageview)
        imageViews.append(imageview)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func pickImagePressed(_ sender: Any) {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerController.SourceType.photoLibrary
        image.allowsEditing = false
        self.present(image, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        let imageview = UIImageView (image: UIImage.init(data: image.jpegData(compressionQuality: 0.75)!))
        imageview.isUserInteractionEnabled = true
        imageview.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(DetailViewController.draggedImage(_:))))
        imageview.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(DetailViewController.scaleImage(_:))))
                    imageview.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(deleteItem(_:))))
        self.view.addSubview(imageview)
        let height = image.size.height * (150/image.size.width)
        imageview.frame = CGRect (x: 100, y: 100, width: 150 , height: height)
        self.imageViews.append(imageview)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func draggedImage(_ sender:UIPanGestureRecognizer){
        let viewDrag = sender.view! as! UIImageView
        if sender.state == .began{
            self.imageViews.remove(at: self.imageViews.firstIndex(of: viewDrag)!)
        }
        self.view.bringSubviewToFront(viewDrag)
        let translation = sender.translation(in: self.view)
        viewDrag.center = CGPoint(x: viewDrag.center.x + translation.x, y: viewDrag.center.y + translation.y)
        sender.setTranslation(CGPoint.zero, in: self.view)
        if sender.state == .ended{
        self.imageViews.append(viewDrag)
            saveData()
        }
    }
    
    @objc func scaleImage(_ sender: UIPinchGestureRecognizer) {
        let viewDrag = sender.view! as! UIImageView
        if sender.state == .began{
            self.imageViews.remove(at: self.imageViews.firstIndex(of: viewDrag)!)
        }
        sender.view!.transform = CGAffineTransform(scaleX: sender.scale, y: sender.scale)
        if sender.state == .ended{
            self.imageViews.append(viewDrag)
            saveData()
        }
    }
    
    @objc func deleteItem(_ sender: UILongPressGestureRecognizer){
        let alert = UIAlertController(title: "Delete This Item?", message: nil, preferredStyle: .alert)
        sender.view?.alpha = 0.5
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
            sender.view?.alpha = 1
        }
        let action = UIAlertAction(title: "Delete", style: .destructive) { action in
        sender.view?.isHidden = true
            self.imageViews.remove(at: self.imageViews.firstIndex(of: sender.view as! UIImageView)!)
        }
        alert.addAction(cancelAction)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func saveData(){
            for image in self.board.images!{
                let curImage = image as! Image
                self.board.removeFromImages(curImage)
                PersistenceService.context.delete(curImage)
            }
            for imageView in self.imageViews {
                let boardImage = Image(context: PersistenceService.context)
                boardImage.picture = NSData(data: imageView.image!.pngData()!)
                boardImage.xpos = Float(imageView.frame.origin.x)
                boardImage.ypos = Float(imageView.frame.origin.y)
                boardImage.width = Float(imageView.frame.width)
                boardImage.height = Float(imageView.frame.height)
                self.board.addToImages(boardImage)
            }
            PersistenceService.saveContext()
    }

    
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent:parent)
        if parent == nil {
          saveData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setToolbarHidden(false, animated: true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewControllerB = segue.destination as? AddTextViewController {
            viewControllerB.callback = { message in
                let imageview = UIImageView (image: message)
                imageview.isUserInteractionEnabled = true
                imageview.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(DetailViewController.draggedImage(_:))))
                imageview.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(DetailViewController.scaleImage(_:))))
                imageview.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(self.deleteItem(_:))))
                self.view.addSubview(imageview)
                let height = message.size.height * (150/message.size.width)
                imageview.frame = CGRect (x: 100, y: 100, width: 150 , height: height)
                self.imageViews.append(imageview)
            }
        }
        
        if let viewControllerB = segue.destination as? ImageSearchViewController{
            viewControllerB.initialSearchTerm = board.title!
            viewControllerB.callback = { message in
                let imageview = UIImageView ()
                imageview.loadNew(url: URL(string: (message as? String)!)!)
                imageview.isUserInteractionEnabled = true
                imageview.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(DetailViewController.draggedImage(_:))))
                imageview.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(DetailViewController.scaleImage(_:))))
                imageview.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(self.deleteItem(_:))))
                self.view.addSubview(imageview)
                self.imageViews.append(imageview)
            }
        }
    }
}

extension UIImageView {
    func loadNew(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                            let width = image.size.width * (150/image.size.height)
                            self?.frame = CGRect (x: 100, y: 100, width: width , height: 150)
                        }
                    }
                }
            }
        }
    }

