//
//  ViewController.swift
//  VLC
//
//  Created by developer on 7/16/19.
//  Copyright © 2019 iOSDevLog. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var networkCaching = 300
    var urlPath = "http://streams.videolan.org/streams/mp4/Mr_MrsSmith-h264_aac.mp4"
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var movieView: UIView!
    @IBOutlet weak var urlTextField: UITextField!
    
    // Enable debugging
    // var mediaPlayer: VLCMediaPlayer = VLCMediaPlayer(options: ["-vvvv"])
    var mediaPlayer: VLCMediaPlayer = VLCMediaPlayer()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Add rotation observer
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(ViewController.rotated),
            name: UIDevice.orientationDidChangeNotification,
            object: nil)
        
        stackView.isHidden = true
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.selectRow(2, inComponent: 0, animated: true)
        
        urlTextField.text = urlPath
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        refresh()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if mediaPlayer.isPlaying {
            mediaPlayer.pause()
        }
    }

    @IBAction func setting(_ sender: UIBarButtonItem) {
        stackView.isHidden = false
    }

    @objc func rotated() {
        let orientation = UIDevice.current.orientation

        if (orientation.isLandscape) {
            print("Switched to landscape")
        }
        else if(orientation.isPortrait) {
            print("Switched to portrait")
        }
    }
    
    @IBAction func done(_ sender: UIBarButtonItem) {
        let index = pickerView.selectedRow(inComponent: 0)
        self.networkCaching = index * 100
        self.urlPath = urlTextField.text!.isEmpty ?  "http://streams.videolan.org/streams/mp4/Mr_MrsSmith-h264_aac.mp4" : urlTextField.text!
        self.refresh()
    }

    
    private func refresh() {
        let url = URL(string: urlPath)
        
        if url == nil {
            print("Invalid URL")
            stackView.isHidden = false
            return
        }
        
        let media = VLCMedia(url: url!)
        
        // Set media options
        // https://wiki.videolan.org/VLC_command-line_help
        media.addOptions([
            "network-caching": networkCaching
            ])
        mediaPlayer.media = media
        
        mediaPlayer.delegate = self
        mediaPlayer.drawable = self.movieView
        mediaPlayer.play()
        
        stackView.isHidden = true
    }
}

extension ViewController: VLCMediaPlayerDelegate {

}


extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 10;
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row * 100)"
    }
}
