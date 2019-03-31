//
//  SoundController.swift
//  TimerList
//
//  Created by Ricky Liu on 16/2/19.
//  Copyright © 2019 Ricky Liu. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox
import UserNotifications

class SoundController: UITableViewController, AVAudioPlayerDelegate {

    var selected: Int = 0;
    var selectedsound: String?;
    var sounds:[String] =  ["None", "Twig","Sanskirt", "Harajuku", "JFK Lo"];
    var edit: Bool = false;
    var urlsounds:[NSURL] = [NSURL(fileURLWithPath: Bundle.main.path(forResource: "Origin_ag_TWIGS_short_3-[AudioTrimmer.com]", ofType: "m4r")!), NSURL(fileURLWithPath: Bundle.main.path(forResource: "Origin_mg_SANSKRIT_short_3-[AudioTrimmer.com]", ofType: "m4r")!), NSURL(fileURLWithPath: Bundle.main.path(forResource: "Zen_mg_HARAJUKU_short", ofType: "m4r")!), NSURL(fileURLWithPath: Bundle.main.path(forResource: "Zen_mg_JFK_LO_short", ofType: "m4r")!)];
    var player = AVAudioPlayer();

    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        var index = -1;
        var i = 0;
        while (index == -1) {
            if (sounds[i] == selectedsound) {
                index = i;
                selected = i;
            }
            i+=1;
        }
        
        let cell = cells[selected]
        cell.accessoryType = .checkmark;
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source


    @IBAction func BackPressed(_ sender: Any) {
        print(edit)
        selectedsound = sounds[selected];
        if (edit == false) {
            performSegue(withIdentifier: "ReverseAddSound", sender: self)
        } else {
            performSegue(withIdentifier: "reversesound", sender: self)
        }
    }
    

    
    @IBOutlet var cells: [UITableViewCell]!

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell1 = cells[selected];
        cell1.accessoryType = .none;
        let cell = tableView.cellForRow(at: indexPath);
        cell!.accessoryType = .checkmark
        selected = indexPath.row
        if (selected == 0) {
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        } else {
            player = try! AVAudioPlayer(contentsOf: urlsounds[selected-1] as URL);
            player.prepareToPlay()
            player.delegate = self
            player.play()
        }
    }
    
    
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath);
        cell!.accessoryType = .none;
    }
}
