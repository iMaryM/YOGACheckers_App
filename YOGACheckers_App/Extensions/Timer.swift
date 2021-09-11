//
//  Timer.swift
//  HomeWork_Lesson_13
//
//  Created by Мария Манжос on 3.09.21.
//

import UIKit

extension CheckersViewController {
    
    func drawTimer(screenSize: CGRect, timerLabel: inout UILabel) {
        let timerViewHeight = ((screenSize.height / 2) - ((screenSize.width - 12) / 2) - 48 - (screenSize.height * 0.05))
        let timerOriginY = (48 + (0.05 * screenSize.height))
        
        let timerView = UIView(frame: CGRect(x: 6, y: timerOriginY, width: screenSize.width - 12, height: timerViewHeight))
        timerView.backgroundColor = .none
        view.addSubview(timerView)

        let timerString = "00 : 00 : 00"
        
        timerLabel = UILabel(frame: CGRect(x: ((screenSize.width - 16) / 2), y: 0, width: ((screenSize.width - 16) / 2), height: timerViewHeight))
        timerLabel.attributedText = addAtributedTextForTimer(for: timerString)
        timerLabel.textAlignment = .center
        timerView.addSubview(timerLabel)
        
        dateLabel = UILabel(frame: CGRect(x: 16, y: 0, width: ((screenSize.width - 16) / 2), height: timerViewHeight))
        dateLabel.attributedText = addAtributedTextForDate(for: dateString, color: SteyleManager.setColor(color: .darkBlue))
        dateLabel.textAlignment = .center
        timerView.addSubview(dateLabel)
        
//        let timerImage = UIImageView(frame: CGRect(x: ((timerView.frame.width / 2) - timerView.frame.height), y: timerView.frame.height / 4, width: timerView.frame.height, height: timerView.frame.height / 2))
//        timerImage.image = UIImage(named: "timer")
//        timerImage.contentMode = .scaleAspectFit
//        timerView.addSubview(timerImage)
        
    }
    
    func calculateTime(seconds: Int) -> (Int, Int, Int) {
        return ((seconds / 3600), ((seconds % 3600) / 60), ((seconds % 3600) % 60))
    }
    
    func convertToTimeString(hours: Int, minutes: Int, seconds: Int) -> String {
        var timeString = ""
        
        timeString += hours < 10 ? "0\(hours)" : "\(hours)"
        timeString += " : "
        
        timeString += minutes < 10 ? "0\(minutes)" : "\(minutes)"
        timeString += " : "
        
        timeString += seconds < 10 ? "0\(seconds)" : "\(seconds)"
        
        return timeString
    }
    
    @objc
    func timerCounter () {
        second += 1
        let time = calculateTime(seconds: second)
        let timeString = convertToTimeString(hours: time.0, minutes: time.1, seconds: time.2)
        
        timerLabel.attributedText = addAtributedTextForTimer(for: timeString)
    }
    
}
