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
    
    private var _isMutedByUser : Bool = false
    
    var isMutedByUser : Bool {
        get {
            return _isMutedByUser
        }
        set( val ) {
            // Not only set the value, but set the volume for the audio player at the same time
            _isMutedByUser = val
            if audioPlayer != nil {
                if _isMutedByUser  {
                    audioPlayer!.volume = Float(0.0)
                } else {
                    // We should probably save and restore the actual volume, 
                    // but this is good enough for a sample app.
                    audioPlayer!.volume = Float(1.0)
                }
            }
            
        }
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