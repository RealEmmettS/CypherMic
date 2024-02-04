//
//  ContentView.swift
//  CypherMic
//
//  Created by Emmett Shaughnessy on 2/3/24.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    @State private var hasMicPermission = false

    var body: some View {
        VStack {
            if hasMicPermission {
                Text("Microphone access granted.")
            } else {
                Button("Grant Microphone Access") {
                    requestMicrophoneAccess()
                }
            }
            
            Button("Go to Keyboard Settings") {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        }
        .padding()
        .onAppear {
            checkMicrophonePermission()
        }
    }
    
    private func checkMicrophonePermission() {
        switch AVAudioSession.sharedInstance().recordPermission {
        case .granted:
            hasMicPermission = true
        default:
            hasMicPermission = false
        }
    }
    
    private func requestMicrophoneAccess() {
        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            DispatchQueue.main.async {
                self.hasMicPermission = granted
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
