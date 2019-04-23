//
//  AddTextViewController.swift
//  Dash-New
//
//  Created by Jared Breedlove on 4/20/19.
//  Copyright © 2019 iMac. All rights reserved.
//

import UIKit

class AddTextViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate{
    
    @IBOutlet weak var textImage: UIImageView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var fontSizeStepper: UIStepper!
    @IBOutlet weak var fontPicker: UIPickerView!
    @IBOutlet weak var fontSizeLabel: UILabel!
    var fonts = [UIFont]()
    var fontSize = 12
    var stepperValue = 12
    var callback : ((UIImage) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setToolbarHidden(true, animated: true)
        for fontFamily in UIFont.familyNames{
            for font in UIFont.fontNames(forFamilyName: fontFamily)
            {
                fonts.append(UIFont(name: font, size: 12)!)
            }
        }
        self.navigationItem.title = "New Quote"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(passImage))
        fontSizeStepper.value = Double(stepperValue)
        fontPicker.delegate = self
        fontPicker.dataSource = self
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        textField.delegate = self
        textImage.image = generateUIImage()
        fontSizeLabel.text = "Font Size: " + String(fontSize + stepperValue) + "pt"
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func passImage(){
        callback?(generateUIImage())
        navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        stepperValue = Int(sender.value)
        fontSizeLabel.text = "Font Size: " + String(fontSize + stepperValue) + "pt"
        textImage.image = generateUIImage()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        textImage.image = generateUIImage()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return fonts.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textImage.image = generateUIImage()
    }
    
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView
    {
        let pickerLabel = UILabel()
        pickerLabel.textColor = UIColor.black
        pickerLabel.text = fonts[row].familyName
        pickerLabel.font = UIFont(name: fonts[row].fontName, size: 15)
        pickerLabel.textAlignment = NSTextAlignment.center
        return pickerLabel
    }
    
    func generateUIImage() -> UIImage{
        let font  = UIFont(name: fonts[fontPicker.selectedRow(inComponent: 0)].fontName, size: (CGFloat(fontSize + stepperValue)))
        let frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        let nameLabel = UILabel(frame: frame)
        nameLabel.numberOfLines = 0
        nameLabel.textAlignment = .center
        nameLabel.textColor = .black
        nameLabel.font = font
        nameLabel.text = textField.text
        UIGraphicsBeginImageContext(frame.size)
        if let currentContext = UIGraphicsGetCurrentContext() {
            nameLabel.layer.render(in: currentContext)
            let nameImage = UIGraphicsGetImageFromCurrentImageContext()!
            return nameImage
        }
        return textImage.image!
    }
}
