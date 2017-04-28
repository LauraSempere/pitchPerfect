//
//  RecordSoundViewController.swift
//  PitchPerfect
//
//  Created by Laura Scully on 3/6/2016.
//  Copyright © 2016 laura.com. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundViewController: UIViewController, AVAudioRecorderDelegate {
    var audioRecorder:AVAudioRecorder!

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopRecording: UIButton!
    
    enum RecordingState { case recording, notRecording }

    func configureUI(_ state: RecordingState){
        switch state {
        case .recording:
            recordingLabel.text = "Recording in progress"
            stopRecording.isHidden=false
            stopRecording.isEnabled = true
            recordButton.isEnabled = false
        case .notRecording:
            recordingLabel.text="Tap to record"
            stopRecording.isHidden=true
            recordButton.isEnabled=true
        }
    }
    
    @IBAction func recordAudio(_ sender: AnyObject) {
        print("record button pressed")
        configureUI(.recording)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(fileURLWithPath: dirPath + recordingName)
        
        print(filePath)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        try! audioRecorder = AVAudioRecorder(url: filePath, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }

    @IBAction func stopRecording(_ sender: AnyObject) {
        print("stop button pressed")
        configureUI(.notRecording)
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("View will appear on screen")
        stopRecording.isHidden=true
        
    }
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        print("AVAudioRecorder finished saving recording")
        if(flag){
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            print("Saving recording failed")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "stopRecording"){
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL =  sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
}

