//
//  BarcodeReaderViewController.swift
//  CanWeEat
//
//  Created by Mario Muhammad on 29.05.18.
//  Copyright © 2018 Mario Muhammad. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire
import SwiftyJSON
import ChameleonFramework

class BarcodeReaderViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    let baseUrl = "https://api.mjuan.info/product/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: Barcode reader method
        
        // Create a session object
        captureSession = AVCaptureSession()
        
        // Set the captureDevice
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        // Create inpt object
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            scanningNotPossible()
            return
        }
        
        // Create output object
        let metadataOutput = AVCaptureMetadataOutput()
        
        // Add output to the session
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            // Send captured data to the delegate object via a serial queue
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            // Set barcode type for EAN-13 to scan
            metadataOutput.metadataObjectTypes = [.ean8, .ean13, .pdf417]
        } else {
            scanningNotPossible()
            return
        }
        
        // Add previewLayer and have it show the video data.
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        // Begin the capture session
        captureSession.startRunning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateNavbar()
        super.viewWillAppear(animated)
        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }
    
    func scanningNotPossible() {
        let alert = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
        captureSession = nil
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection!) {
        
        // Avoid buzzy device
        captureSession.stopRunning()
        
        // Get the first object from the metadataObjects array
        if let barcodeData = metadataObjects.first {
            // Turn it into machine readable code
            guard let barcodeReadable = barcodeData as? AVMetadataMachineReadableCodeObject else {return}
            guard let stringValue = barcodeReadable.stringValue else {return}
            
            // Vibrate the device to give the user some feedback
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            
            // Send the barcode as a string to barcodeDetected()
            barcodeDetected(code: stringValue)
        }
    }
    
    func barcodeDetected(code: String) {
        
        // Notif have found something
        let alert = UIAlertController(title: "Success read a barcode", message: code, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Get the product information", style: .default, handler: { action in
            
            // Remove the spaces
            let trimmedCode = code.trimmingCharacters(in: CharacterSet.whitespaces)
            print(trimmedCode)
            self.getProductInformation(url: self.baseUrl + trimmedCode)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: Networking
    func getProductInformation(url: String) {
        print(url)
        Alamofire.request(url, method: .get).responseJSON { (response) in
            if response.result.isSuccess {
                print("Success! Got the product information")
                print(response)
            } else {
                print("Error: \(String(describing: response.result.error))")
            }
        }
    }
    
    // MARK: Update navbar UI
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
