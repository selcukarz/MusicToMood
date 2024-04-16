//
//  ViewController.swift
//  MusicToMood
//
//  Created by Selçuk Arıöz on 21.03.2024.
//

import UIKit
import AVFoundation

class ViewController: UIViewController{
    
    // MARK: - Variables
    private let videoDataOutput = AVCaptureVideoDataOutput()
    private let captureSession = AVCaptureSession()
    // Using lazy keyword beacuse the captureSession needs to be loaded before we can use the preview layer
    private lazy var previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
    // MARK: - LifeCylcle
    override func viewDidLoad() {
        super.viewDidLoad()
        addCameraInput()
        showCameraFeed()
        captureSession.startRunning()
    }
    // The account for when the container's view changes
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.frame = view.frame
    }
    // MARK: - Helper Functions
    // Adding camera input
    private func addCameraInput() {
        guard let device = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInTrueDepthCamera,.builtInDualCamera,.builtInWideAngleCamera], mediaType: .video, position: .front).devices.first else {
            fatalError("No camera detected. Please use a real camera, not a simulator.")
        }
        do {
            let cameraInput = try AVCaptureDeviceInput(device: device)
            captureSession.addInput(cameraInput)
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    private func showCameraFeed() {
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.frame
    }
}
