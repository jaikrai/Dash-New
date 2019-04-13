//
//  File.swift
//  Dash-New
//
//  Created by iMac on 4/10/19.
//  Copyright © 2019 iMac. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    var board1: Board?
    
    // This variable will hold the data being passed from the First View Controller
//    var receivedData = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(board1)
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
            label.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(DetailViewController.draggedView(_:))))
            label.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(DetailViewController.scaleImage(_:))))
            label.center = CGPoint(x: 160, y: 285)
            label.textAlignment = .center
            label.text = title
            self.view.addSubview(label)
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        
        let imageview = UIImageView (image: image)
        imageview.isUserInteractionEnabled = true
        imageview.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(DetailViewController.draggedView(_:))))
        imageview.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(DetailViewController.scaleImage(_:))))
        self.view.addSubview(imageview)
        
        imageview.frame = CGRect (x: 20, y: 20, width: 100 , height: 100)
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @objc func draggedView(_ sender:UIPanGestureRecognizer){
        print("Drag Function")
        let viewDrag = sender.view!
        self.view.bringSubviewToFront(viewDrag)
        let translation = sender.translation(in: self.view)
        viewDrag.center = CGPoint(x: viewDrag.center.x + translation.x, y: viewDrag.center.y + translation.y)
        sender.setTranslation(CGPoint.zero, in: self.view)
    }
    
    @objc func scaleImage(_ sender: UIPinchGestureRecognizer) {
        print("Scale Function")
        sender.view!.transform = CGAffineTransform(scaleX: sender.scale, y: sender.scale)
    }
    
}
