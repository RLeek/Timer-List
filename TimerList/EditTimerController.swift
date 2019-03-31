//
//  EditTimerController.swift
//  TimerList
//
//  Created by Ricky Liu on 14/2/19.
//  Copyright © 2019 Ricky Liu. All rights reserved.
//

import UIKit

class EditTimerController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource,UITextFieldDelegate {

    
    
    var hours:[Int] = [];
    var min:[Int] = [];
    var sec:[Int] = [];
    var Save: Bool = false;
    var selectedhour: Int = 0;
    var selectedmin: Int = 0;
    var selectedsec: Int = 0;
    var totalseconds: Int = 0;
    var prev_name: String = "";
    var prev_sound: String = "";
    var row: Int = 0;
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
    @IBOutlet weak var TimerPicker: UIPickerView!
    
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
    
    @IBAction func unwindToSoundTable(_ unwindSegue: UIStoryboardSegue) {
        let vc = unwindSegue.source as! SoundController;
        self.prev_sound = vc.selectedsound!;
        Selectedsound.text = prev_sound;
        SaveButton.isEnabled = true;
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.Timer.delegate = self
        Timer.returnKeyType = UIReturnKeyType.done
        for i in 0...99 {
            self.hours.append((i));
        }
        for i in 0...59 {
            self.min.append(i);
            self.sec.append(i);
        }
        let navbar = self.navigationController!.navigationBar
        navbar.shadowImage = #imageLiteral(resourceName: "greycolor");
        SaveButton.isEnabled = false;        Timer.text = prev_name;
        TimerPicker.selectRow(totalseconds%60, inComponent:2, animated:true);
        TimerPicker.selectRow((totalseconds%3600)/60, inComponent:1, animated:true);
        TimerPicker.selectRow(totalseconds/3600, inComponent:0, animated:true);
        selectedhour = totalseconds/3600;
        selectedmin = (totalseconds%3600)/60;
        selectedsec = totalseconds%60;
        Selectedsound.text = prev_sound;

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
    
    
    @IBAction func Saving(_ sender: Any) {
        totalseconds = (self.selectedsec) + (self.selectedmin*60) + (self.selectedhour*3600);
        Save = true;
        performSegue(withIdentifier: "EditReverse", sender: self)
    }
    
    @IBAction func Cancelling(_ sender: Any) {
        Save = false;
        performSegue(withIdentifier: "EditReverse", sender: self)

    }

    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent  component: Int) {
        if (Timer.text != "") {
            SaveButton.isEnabled = true;
        }
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "EDIT") {
            let vc = segue.destination as! SoundController
            vc.edit = true;
            vc.selectedsound = prev_sound;
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
