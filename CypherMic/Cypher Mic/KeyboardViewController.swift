// KeyboardViewController.swift
// Cypher Mic
//
// Created by Emmett Shaughnessy on 2/3/24.
//

import UIKit
import SwiftUI
import AVFoundation

class KeyboardViewController: UIInputViewController {
    var hostingController: UIHostingController<ContentView>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Pass 'self' to ContentView to provide access to textDocumentProxy
        let contentView = ContentView(keyboardViewController: self)
        hostingController = UIHostingController(rootView: contentView)
        
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(hostingController.view)
        
        NSLayoutConstraint.activate([
            hostingController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            hostingController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            hostingController.view.topAnchor.constraint(equalTo: self.view.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    override func textWillChange(_ textInput: UITextInput?) {
        // The app is about to change the document's contents. Perform any preparation here.
    }
    
    override func textDidChange(_ textInput: UITextInput?) {
        // The app has just changed the document's contents, the document context has been updated.
    }
}

struct ContentView: View {
    @State private var isRecording = false
    @State private var audioRecorder: AVAudioRecorder!
    
    // Reference to KeyboardViewController to access textDocumentProxy
    var keyboardViewController: KeyboardViewController
    
    var body: some View {
        Button(action: {
            self.isRecording.toggle()
            if self.isRecording {
                let recordingSession = AVAudioSession.sharedInstance()
                try! recordingSession.setCategory(.record, mode: .default)
                try! recordingSession.setActive(true)
                
                let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                let audioURL = documentPath.appendingPathComponent("recording.m4a")
                let settings = [
                    AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                    AVSampleRateKey: 12000,
                    AVNumberOfChannelsKey: 1,
                    AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
                ]
                
                try! self.audioRecorder = AVAudioRecorder(url: audioURL, settings: settings)
                self.audioRecorder.record()
            } else {
                self.audioRecorder.stop()
                let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                let audioURL = documentPath.appendingPathComponent("recording.m4a")
                
                if FileManager.default.fileExists(atPath: audioURL.path) {
                    // Use textDocumentProxy to insert "SUCCESS"
                    self.keyboardViewController.textDocumentProxy.insertText("SUCCESS")
                    try? FileManager.default.removeItem(at: audioURL)
                } else {
                    // Use textDocumentProxy to insert "FAILED"
                    self.keyboardViewController.textDocumentProxy.insertText("FAILED")
                }
            }
        }) {
            Text(isRecording ? "Stop Recording" : "Start Recording")
        }
    }
}
