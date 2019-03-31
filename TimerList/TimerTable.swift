//
//  TimerTable.swift
//  TimerList
//
//  Created by Ricky Liu on 11/2/19.
//  Copyright © 2019 Ricky Liu. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox
import UserNotifications

class Timercell: UITableViewCell {
    @IBOutlet weak var Chosen: UILabel!
    @IBOutlet weak var Title: UILabel!
    @IBOutlet weak var Time: UILabel!
    
    override func awakeFromNib() {
        print("PORKY")
        Chosen.layer.cornerRadius = 0.5 * Chosen.bounds.size.width
        Chosen.clipsToBounds = true
        Chosen.layer.borderWidth = 4;
        Chosen.layer.borderColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1);
    }
    
    
}

class TimerTable: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, AVAudioPlayerDelegate {

    @IBOutlet weak var AddButton: UIBarButtonItem!
    @IBOutlet weak var StartButton: UIButton!
    @IBOutlet weak var ResetButton: UIButton!
    @IBOutlet weak var Table: UITableView!
    var sec: Int = 0;
    var index = -1;
    var loops = 1;
    var maintimer = Timer();
    var start: Bool = false;
    var options:[Int] = [];
    var selectedrow: Int = -1;
    var sounds:[String] =  ["None", "Twig","Sanskirt", "Harajuku", "JFK Lo"];
    var urlsounds:[NSURL] = [NSURL(fileURLWithPath: Bundle.main.path(forResource: "Origin_ag_TWIGS_short_3-[AudioTrimmer.com]", ofType: "m4r")!), NSURL(fileURLWithPath: Bundle.main.path(forResource: "Origin_mg_SANSKRIT_short_3-[AudioTrimmer.com]", ofType: "m4r")!), NSURL(fileURLWithPath: Bundle.main.path(forResource: "Zen_mg_HARAJUKU_short", ofType: "m4r")!), NSURL(fileURLWithPath: Bundle.main.path(forResource: "Zen_mg_JFK_LO_short", ofType: "m4r")!)];
    var urlsoundss:[String] = ["None","Origin_ag_TWIGS_short_3-[AudioTrimmer.com].m4r", "Origin_mg_SANSKRIT_short_3-[AudioTrimmer.com].m4r", "Zen_mg_HARAJUKU_short.m4r", "Zen_mg_JFK_LO_short.m4r"];

    var player = AVAudioPlayer();

    @IBOutlet weak var TitleTime: UILabel!
    var timerlist: timerlist?

    override func viewDidLoad() {
        super.viewDidLoad()
        let navbar = self.navigationController!.navigationBar
        navbar.shadowImage = #imageLiteral(resourceName: "greycolor");
        StartButton.layer.cornerRadius = 0.6 * StartButton.bounds.size.width
        StartButton.clipsToBounds = true
        StartButton.layer.borderWidth = 1;
        StartButton.layer.borderColor = #colorLiteral(red: 0.1960784314, green: 0.8431372549, blue: 0.2941176471, alpha: 1);
        ResetButton.layer.cornerRadius = 0.6 * ResetButton.bounds.size.width
        ResetButton.clipsToBounds = true
        ResetButton.layer.borderWidth = 1;
        disableReset()
        ResetButton.isEnabled = false;
        for i in 1...99 {
            options.append(i);
        }
        if (timerlist?.getarray().count  == 0) {
            StartButton.isEnabled = false;
            disableStart();
        } else {
            StartButton.isEnabled = true;
            enableStart();
        }
        // Do any additional setup after loading the view.
    }
    
    func playsound(alarm: timer)->Int {
        if (alarm.getsound() == "None") {
            return 0;
        }
        var i = 0;
        var found = false;
        var index = 0;
        while (found == false) {
            if (alarm.getsound() == sounds[i]) {
                found = true;
                index = i;
            }
            i+=1;
        }

        index+=1;
        return index;
    }
    
    
    
    func saveme() {
        let count = self.navigationController?.viewControllers.count;
        let vc = self.navigationController?.viewControllers[count!-2] as! FirstTable;
        let encoder = JSONEncoder();
        let data = try! encoder.encode(vc.Timerlists);
        let url = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("untitled.json");
        try! data.write(to: url);
        
    }
    
    
    func disableReset() {
        ResetButton.layer.borderColor = #colorLiteral(red: 0.2549019608, green: 0.2549019608, blue: 0.2549019608, alpha: 1)
        ResetButton.layer.backgroundColor = #colorLiteral(red: 0.1294117647, green: 0.1294117647, blue: 0.1294117647, alpha: 1);
        ResetButton.setTitleColor(#colorLiteral(red: 0.2549019608, green: 0.2549019608, blue: 0.2549019608, alpha: 1), for: .normal)

    }
    func enablereset() {
        ResetButton.layer.borderColor = #colorLiteral(red: 0.9372549057, green: 0.9372549057, blue: 0.9568627477, alpha: 1);
        ResetButton.layer.backgroundColor = #colorLiteral(red: 0.2549019608, green: 0.2549019608, blue: 0.2549019608, alpha: 1);
        ResetButton.setTitleColor(#colorLiteral(red: 0.9372549057, green: 0.9372549057, blue: 0.9568627477, alpha: 1), for: .normal)
    }
    func disableStart() {
        StartButton.layer.borderColor = #colorLiteral(red: 0.07268114048, green: 0.3102197018, blue: 0.1115011613, alpha: 1)
        StartButton.layer.backgroundColor = #colorLiteral(red: 0.03858674035, green: 0.1646970178, blue: 0.05919646186, alpha: 1);
        StartButton.setTitleColor(#colorLiteral(red: 0.07268114048, green: 0.3102197018, blue: 0.1115011613, alpha: 1), for: .normal)
    }
    func enableStart() {
        StartButton.layer.borderColor = #colorLiteral(red: 0.2352941176, green: 1, blue: 0.3333333333, alpha: 1);
        StartButton.layer.backgroundColor = #colorLiteral(red: 0.07268114048, green: 0.3102197018, blue: 0.1115011613, alpha: 1);
        StartButton.setTitleColor(#colorLiteral(red: 0.2352941176, green: 1, blue: 0.3333333333, alpha: 1), for: .normal)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        StartButton.layer.cornerRadius = StartButton.frame.height / 2.0
        ResetButton.layer.cornerRadius = ResetButton.frame.height / 2.0

    }
    
    @IBAction func unwindToSaveTable(_ unwindSegue: UIStoryboardSegue) {
        let vc = unwindSegue.source as! NewTimerController;
        if (vc.Save == true) {
            timerlist?.appendarray(timer: timer(name: vc.Timer.text!, time: TimeInterval(vc.totalseconds), alarm: vc.sound))
            print("WKH:LSJDFL:KZJFKL:SJDFKL:S");
            print(vc.sound)
            sec = vc.totalseconds;
            saveme()

        }
        if (timerlist?.getarray().count  == 0) {
            StartButton.isEnabled = false;
            disableStart();
        } else {
            StartButton.isEnabled = true;
            enableStart();
        }
        Table.reloadData();
    }
    
    @IBAction func unwindToEditTable(_ unwindSegue: UIStoryboardSegue) {
        let vc = unwindSegue.source as! EditTimerController;
        if (vc.Save == true) {
            timerlist!.replacearray(index: vc.row, timer: timer(name: vc.Timer.text!, time: TimeInterval(vc.totalseconds), alarm: vc.prev_sound));
            saveme()

        }
        Table.reloadData();
    }
   /*
    @IBAction func unwindToFirstTable(_ unwindSegue: UIStoryboardSegue) {
        let sender = unwindSegue.source as! NewCellController
        if sender.save == true {
            timerlist!.appendarray(sender.timer);
            Table.reloadData();
        }
    }
    */
    
    // MARK: - Table
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timerlist!.getarray().count;
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Timercell", for: indexPath) as! Timercell
        cell.Title.text = timerlist?.getarray()[indexPath.row].getname();
        cell.Time.text = convert_to_time(sec: Int((timerlist?.getarray()[indexPath.row].gettime())!));
        if (index == indexPath.row) {
            cell.Chosen.layer.borderColor = #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.9568627451, alpha: 1);
        } else {
            cell.Chosen.layer.borderColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1);
        }
        cell.selectionStyle = .none;
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if (index == -1) {
            let action1 = UIContextualAction(style: .normal, title: "Edit") {(action,sourceView,completionHandler) in
                self.selectedrow = indexPath.row
                print(self.selectedrow)
                self.performSegue(withIdentifier: "EditForward", sender: self);
            }
        
        
            let action2 = UIContextualAction(style: .normal, title: "Delete") {(action,sourceView,completionHandler) in
                let deletepop = UIAlertController(title:nil , message: "\"" + (self.timerlist?.getarray()[indexPath.row].getname())! + "\"" + "will be permanently deleted", preferredStyle: .actionSheet);
                deletepop.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
                    self.timerlist?.removearray(index: indexPath.row);
                    tableView.setEditing(false, animated: true)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    if (self.timerlist?.getarray().count  == 0) {
                        self.StartButton.isEnabled = false;
                        self.disableStart();
                        self.AddButton.isEnabled = true;
                    }
                    self.saveme()
                }))
                
                deletepop.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ _ in
                    tableView.setEditing(false, animated: true)
                    
                }));
                
                self.present(deletepop, animated: true, completion: nil);
                
            }
            action1.backgroundColor = #colorLiteral(red: 0.05803687125, green: 0.4780174494, blue: 0.8318818808, alpha: 1)
            action2.backgroundColor = #colorLiteral(red: 0.8318818808, green: 0.2878107509, blue: 0.2076191494, alpha: 1)
            action2.image = #imageLiteral(resourceName: "cross.png");
            action1.image = #imageLiteral(resourceName: "final_wheel.png");
            let configuration = UISwipeActionsConfiguration(actions: [action2,action1])
            configuration.performsFirstActionWithFullSwipe = false
            return configuration
        } else {
           return UISwipeActionsConfiguration(actions: []);
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "EditForward") {
            let nc = segue.destination as! UINavigationController;
            let vc = nc.topViewController as! EditTimerController;
            vc.row = selectedrow;
            print(selectedrow);
            vc.prev_name = (timerlist?.getarray()[selectedrow].getname())!;
            vc.totalseconds = Int((timerlist?.getarray()[selectedrow].gettime())!);
            vc.prev_sound = (timerlist?.getarray()[selectedrow].getsound())!;
            print(vc.prev_sound);
        }
    }
    
    
    
    func convert_to_time(sec: Int)->String {
        let hour = (sec/3600);
        let minutes = (sec - (hour*3600))/60
        let seconds = sec%60
        var stringhour = "";
        var stringminutes = "";
        var stringseconds = "";
        if (String(hour).count == 1) {
            stringhour = "0" + String(hour)
        } else {
            stringhour  = String(hour)
        }
        if (String(minutes).count == 1) {
            stringminutes = "0" + String(minutes)
        } else {
            stringminutes  = String(minutes)
        }
        if (String(seconds).count == 1) {
            stringseconds = "0" + String(seconds)
        } else {
            stringseconds  = String(seconds)
        }
        return stringhour + ":" + stringminutes + ":" + stringseconds;
    }
    
    //Moves down the timers and starts countdown
    //Process repeats for all loops
    @IBAction func StartPressed(_ sender: Any) {
        if (index == -1) {
            UIApplication.shared.beginIgnoringInteractionEvents()
            Table.setEditing(false, animated: true);
            ResetButton.isEnabled = true;
            enablereset()
            StartButton.layer.backgroundColor = #colorLiteral(red: 0.4716846447, green: 0.1239690079, blue: 0.1107179309, alpha: 1);
            StartButton.layer.borderColor = #colorLiteral(red: 1, green: 0.3098039216, blue: 0.2666666667, alpha: 1);
            StartButton.setTitle("Stop", for: .normal)
            StartButton.setTitleColor(#colorLiteral(red: 1, green: 0.3098039216, blue: 0.2666666667, alpha: 1), for: .normal)
            _ = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(TimerTable.rest), userInfo: nil, repeats: false);
            /*
            startNextloop()
            ResetButton.isEnabled = true;
            enablereset()
            StartButton.layer.backgroundColor = #colorLiteral(red: 0.4716846447, green: 0.1239690079, blue: 0.1107179309, alpha: 1);
            StartButton.layer.borderColor = #colorLiteral(red: 1, green: 0.3098039216, blue: 0.2666666667, alpha: 1);
            StartButton.setTitle("Stop", for: .normal)
            StartButton.setTitleColor(#colorLiteral(red: 1, green: 0.3098039216, blue: 0.2666666667, alpha: 1), for: .normal)
            */
        } else {
            if (start == false) {
                maintimer.invalidate()
                StartButton.setTitle("Start", for: .normal)
                StartButton.layer.backgroundColor = #colorLiteral(red: 0.06334105879, green: 0.2814452052, blue: 0.100872986, alpha: 1);
                StartButton.layer.borderColor = #colorLiteral(red: 0.1960784314, green: 0.8431372549, blue: 0.2941176471, alpha: 1);
                StartButton.setTitleColor(#colorLiteral(red: 0.1960784314, green: 0.8431372549, blue: 0.2941176471, alpha: 1), for: .normal)
                start = true;
            } else {
                Table.reloadData();
                start = false;
                startNextcountdown()
                StartButton.layer.backgroundColor = #colorLiteral(red: 0.4716846447, green: 0.1239690079, blue: 0.1107179309, alpha: 1);
                StartButton.layer.borderColor = #colorLiteral(red: 1, green: 0.3098039216, blue: 0.2666666667, alpha: 1);
                StartButton.setTitle("Stop", for: .normal)
                StartButton.setTitleColor(#colorLiteral(red: 1, green: 0.3098039216, blue: 0.2666666667, alpha: 1), for: .normal)

            }
        }
    }
    
    @objc func rest() {
        startNextloop()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    
    @IBAction func ResetPressed(_ sender: Any) {
        maintimer.invalidate();
        loops = 1;
        index = -1;
        LoopPicker.selectRow(0, inComponent: 0, animated: true)
        disableReset()
        AddButton.isEnabled = true;
        ResetButton.isEnabled = false;
        Table.reloadData();
        StartButton.setTitle("Start", for: .normal)
        StartButton.layer.backgroundColor = #colorLiteral(red: 0.06334105879, green: 0.2814452052, blue: 0.100872986, alpha: 1);
        StartButton.layer.borderColor = #colorLiteral(red: 0.1960784314, green: 0.8431372549, blue: 0.2941176471, alpha: 1);
        StartButton.setTitleColor(#colorLiteral(red: 0.1960784314, green: 0.8431372549, blue: 0.2941176471, alpha: 1), for: .normal)
        TitleTime.text = convert_to_time(sec: 0);
    }
    
    
    

    
    func startNextloop() {
        AddButton.isEnabled = false;
        loops -= 1;
        print(loops)
        if (loops >= 0) {
            LoopPicker.selectRow(loops, inComponent: 0, animated: true)
            startNexttimer()
        } else {
            ResetButton.isEnabled = false;
            disableReset()
            maintimer.invalidate();
            loops = 1;
            StartButton.setTitle("Start", for: .normal)
            StartButton.layer.backgroundColor = #colorLiteral(red: 0.06334105879, green: 0.2814452052, blue: 0.100872986, alpha: 1);
            StartButton.layer.borderColor = #colorLiteral(red: 0.1960784314, green: 0.8431372549, blue: 0.2941176471, alpha: 1);
            StartButton.setTitleColor(#colorLiteral(red: 0.1960784314, green: 0.8431372549, blue: 0.2941176471, alpha: 1), for: .normal)
            Table.reloadData();
            AddButton.isEnabled = true;
        }
    }
    
    @IBOutlet weak var LoopPicker: UIPickerView!
    
    func startNexttimer() {
        index += 1;
        if (index >= (timerlist?.getarray().count)!) {
            index = -1;
            startNextloop()
        } else {
            self.sec = Int((timerlist?.getarray()[index].gettime())!);
            TitleTime.text = convert_to_time(sec: self.sec);
            maintimer.invalidate();
            Table.reloadData();
            startNextcountdown();
        }
    }
    
    
    func startNextcountdown() {
        maintimer =   Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(TimerTable.updatelabel)), userInfo: nil, repeats: true)
    }
    
    
    @objc func updatelabel()  {
        self.sec -= 1;
        if (sec < 0) {
            let soundtoplay = playsound(alarm: (timerlist?.getarray()[index])!);
            if (soundtoplay == 0) {
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            } else {
                player = try! AVAudioPlayer(contentsOf: urlsounds[soundtoplay-2] as URL);
                player.prepareToPlay()
                player.delegate = self
                player.play()
            }
            startNexttimer()
        } else {
            TitleTime.text = convert_to_time(sec: self.sec);
        }
    }


    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return options.count;
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let attributedString = NSAttributedString(string: String(self.options[row]) , attributes: [NSAttributedString.Key.foregroundColor :  #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.9568627451, alpha: 1)]);
        return attributedString
    }

    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent  component: Int) {
        loops = options[row];
    }
    
    
    
    // MARK: - Notifications;
    
    
    
    func calculate_alert() {
        var times:[Int] = [sec];
        var titles:[String] = [(timerlist?.getarray()[index].getname())!];
        var sounds:[String] = [(timerlist?.getarray()[index].getsound())!];
        var i = index+1;
        while (i < (timerlist?.getarray().count)!) {
            times.append(Int((timerlist?.getarray()[i].gettime())!));
            titles.append((timerlist?.getarray()[i].getname())!);
            sounds.append((timerlist?.getarray()[i].getsound())!);

            i = i + 1;
        }
        
        i = 1;
        while (i < loops) {
            var i2 = 0;
            while (i2 < (timerlist?.getarray().count)!) {
                times.append(Int((timerlist?.getarray()[i2].gettime())!));
                titles.append((timerlist?.getarray()[i2].getname())!);
                sounds.append((timerlist?.getarray()[i2].getsound())!);
                i2 = i2+1;
            }
            i = i + 1;
        }
    }
    
    
    
    
    func get_sounds(big_int: Int) -> String {
        var i = 0;
        var indexer = 0;
        while (i < sounds.count) {
            if (sounds[i] ==  (timerlist?.getarray()[big_int].getsound())!) {
                indexer = i;
            }
            i = i + 1;
        }
        return urlsoundss[indexer];
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
