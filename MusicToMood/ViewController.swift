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
        getCameraFrames()
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
    //Adding camera output
    private func getCameraFrames() {
            videoDataOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as NSString): NSNumber(value: kCVPixelFormatType_32BGRA)] as [String: Any]
            
            videoDataOutput.alwaysDiscardsLateVideoFrames = true
            // You do not want to process the frames on the Main Thread so we off load to another thread
            videoDataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "camera_frame_processing_queue"))
            captureSession.addOutput(videoDataOutput)
            // isVideoRotationAngleSupported(T##videoRotationAngle: CGFloat##CGFloat)
        guard let connection = videoDataOutput.connection(with: .video), connection.isVideoOrientationSupported else {
            return
        }
        connection.videoOrientation = .portrait
    }
}
// MARK: - AVCaptureVideoDataOutputSampleBufferDelegate

extension ViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        print("Received a frame")
    }
}
