//
//  TimerList.swift
//  TimerList
//
//  Created by Ricky Liu on 10/2/19.
//  Copyright © 2019 Ricky Liu. All rights reserved.
//

import Foundation


class timerlist: Codable {
    var timers: [timer] = [];
    var name: String
    
    
    init(name: String) {
        self.name = name;
    }
    
    func getname()->String {
        return self.name
    }
    func changename(name: String) {
        self.name = name;
    }
    func getarray()->[timer] {
        return self.timers
    }
    func appendarray(timer: timer) {
        self.timers.append(timer);
    }
    func removearray(index: Int) {
        self.timers.remove(at: index);
    }
    func replacearray(index: Int, timer:timer) {
        self.timers[index] = timer;
    }
}

class timer: Codable {
    var time:TimeInterval;
    var name: String;
    var alarm: String;
    
    init(name: String, time: TimeInterval, alarm:String) {
        self.name = name;
        self.time = time;
        self.alarm = alarm;
    }
    func getname()->String {
        return self.name
    }
    func gettime()->TimeInterval {
        return self.time;
    }
    func getsound()->String {
        return self.alarm;
    }

    
}
