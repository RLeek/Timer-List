//
//  NewTimerController.swift
//  TimerList
//
//  Created by Ricky Liu on 12/2/19.
//  Copyright © 2019 Ricky Liu. All rights reserved.
//

import UIKit

class NewTimerController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource,UITextFieldDelegate {
    
    var hours:[Int] = [];
    var min:[Int] = [];
    var sec:[Int] = [];
    var Save: Bool = false;
    var selectedhour: Int = 0;
    var selectedmin: Int = 0;
    var selectedsec: Int = 0;
    var sound: String = "None";
    var totalseconds: Int = 0;
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (component == 0) {
            return 100;
        } else {
            return 60
        }
    }
    

    @IBOutlet weak var Selectedsound: UILabel!
    @IBOutlet weak var Timer: UITextField!
    @IBOutlet weak var SaveButton: UIBarButtonItem!
    @IBOutlet weak var TimerPIcker: UIPickerView!
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        if (component == 1) {
            let attributedString = NSAttributedString(string: String(self.min[row]) , attributes: [NSAttributedString.Key.foregroundColor :  #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.9568627451, alpha: 1)])
            return attributedString
        } else if (component == 2) {
            let attributedString = NSAttributedString(string: String(self.sec[row]), attributes: [NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.9568627451, alpha: 1) ])
            return attributedString
        } else {
            let attributedString = NSAttributedString(string: String(self.hours[row]), attributes: [NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.9568627451, alpha: 1)])
            return attributedString
        }
    }

    override func viewDidLoad() {
        Timer.returnKeyType = UIReturnKeyType.done
        self.Timer.delegate = (self)

        super.viewDidLoad()
        for i in 0...99 {
            self.hours.append((i));
        }
        for i in 0...59 {
            self.min.append(i);
            self.sec.append(i);
        }
        let navbar = self.navigationController!.navigationBar
        navbar.shadowImage = #imageLiteral(resourceName: "greycolor");
        SaveButton.isEnabled = false;
        Selectedsound.text = sound;
                // Do any additional setup after loading the view.
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    @IBAction func TextValidation(_ sender: Any) {
        if Timer.text != "" {
            SaveButton.isEnabled = true;
        } else {
            SaveButton.isEnabled = false;
        }
    }
    
    @IBAction func unwindToSSaveTable(_ unwindSegue: UIStoryboardSegue) {
        let vc = unwindSegue.source as! SoundController;
        self.sound = vc.selectedsound!;
        Selectedsound.text = sound;
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "MOVE") {
            let vc = segue.destination as! SoundController;
            vc.selectedsound = sound;
        }
    }
    
    @IBAction func Saving(_ sender: Any) {
        totalseconds = (self.selectedsec) + (self.selectedmin*60) + (self.selectedhour*3600);
        Save = true;
        performSegue(withIdentifier: "ReverseTimer", sender: self)
    }
    
    @IBAction func Cancelling(_ sender: Any) {
        Save = false;
        performSegue(withIdentifier: "ReverseTimer", sender: self)
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent  component: Int) {
        if (component == 0) {
            selectedhour = hours[row];
        }
        if (component == 1) {
            selectedmin = min[row];
        }
        if (component == 2) {
            selectedsec = sec[row];
        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
