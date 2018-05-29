//
//  BarcodeReaderViewController.swift
//  CanWeEat
//
//  Created by Mario Muhammad on 29.05.18.
//  Copyright © 2018 Mario Muhammad. All rights reserved.
//

import UIKit
import AVFoundation
import ChameleonFramework

class BarcodeReaderViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    var session: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create a session object
        session = AVCaptureSession()
        
        // Set the captureDevice
        let videoCaptureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        
        // Create inpt object
        let videoInput: AVCaptureDeviceInput?
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice!)
        } catch {
            return
        }
        
        if (session.canAddInput(videoInput!)) {
            session.addInput(videoInput!)
        } else {
            scanningNotPossible()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateNavbar()
    }
    
    func scanningNotPossible() {
        let alert = UIAlertController(title: "Can not scan", message: "Try a device with a camera", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
        session = nil
    }
    
    func updateNavbar() {
        let img = UIImage()
        
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation Controller does not exist")}
        
        navBar.isTranslucent = false
        navBar.shadowImage = img
        navBar.setBackgroundImage(img, for: .default)
        navBar.barTintColor = FlatOrange()
        navBar.tintColor = ContrastColorOf(FlatOrange(), returnFlat: true)
        navBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: ContrastColorOf(FlatOrange(), returnFlat: true)]
    }
    
}
