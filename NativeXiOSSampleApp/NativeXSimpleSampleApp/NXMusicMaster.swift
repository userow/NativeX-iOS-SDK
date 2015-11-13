//
//  NXMusicMaster.swift
//  NativeXSimpleSampleApp
//
//  Created by Matthew MacGregor on 11/3/15.
//  Copyright © 2015 NativeX. All rights reserved.
//

import Foundation
import AVFoundation

@objc
class NXMusicMaster : NSObject {
    
    static let sharedInstance = NXMusicMaster()
    
    private var audioPlayer: AVAudioPlayer?
    private let defaults = NSUserDefaults.standardUserDefaults()

    
    override init(){
        super.init()

        // Sreda Vniecaps	by Rolemusic
        // Licensed as CC Attribution http://creativecommons.org/licenses/by/4.0/
        //http://freemusicarchive.org/music/Rolemusic/~/Sreda_VniecapS
        
        do {
            let audioFilePath = NSURL(fileURLWithPath:
                    NSBundle.mainBundle().pathForResource("Rolemusic-Sreda_Vniecaps", ofType: "mp3")!)
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
            try AVAudioSession.sharedInstance().setActive(true)
            try audioPlayer = AVAudioPlayer(contentsOfURL: audioFilePath)
            audioPlayer!.prepareToPlay()
            audioPlayer!.numberOfLoops = -1; //infinite
        } catch {
            NSLog("Error playing music")
        }
    
    }
    
    func mute() {
        audioPlayer?.volume = Float(0.0)
    }
    
    func unmute() {
        audioPlayer?.volume = Float(1.0)
    }
    
    func autoMute() {
        let mm = NXMusicMaster.sharedInstance
        (NXSampleSettings.sharedInstance.isMutedByUser) ? mm.mute() : mm.unmute()
    }
    
    func pause() {
        if audioPlayer != nil && audioPlayer!.playing == true {
            audioPlayer!.stop()
        }
    }
    
    func play() {
        if audioPlayer != nil && audioPlayer!.playing == false {
            audioPlayer!.play()
        }
    }
    
    func toggle() {
        if audioPlayer != nil {
            (audioPlayer!.playing) ? pause() : play();
        }
    }
    
    
}