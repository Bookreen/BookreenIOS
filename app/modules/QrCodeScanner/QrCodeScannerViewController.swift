import Foundation
import AVFoundation
import UIKit

final class QrCodeScannerViewController: AppViewController {
    
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var buttonDismiss: ImageButtonView!
    @IBOutlet weak var labelDescription: UILabel!
    
    fileprivate lazy var  captureSession: AVCaptureSession = {
        let captureSession = AVCaptureSession()
        return captureSession
    }()
    
    fileprivate lazy var previewLayer: AVCaptureVideoPreviewLayer = {
        let previewLayer = AVCaptureVideoPreviewLayer()
        
        return previewLayer
    }()
    
    var callback: ((QrCodeScannerResult) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.labelDescription.text = S.pleaseScanQrCode.localized()
        self.labelDescription.textColor = ColorPalette.shared.colorWhite
        self.labelDescription.font = .systemFont(ofSize: 14)
        self.buttonDismiss.iconTintColor = ColorPalette.shared.colorWhite
        self.view.backgroundColor = ColorPalette.shared.colorBlack
        self.cameraView.backgroundColor = ColorPalette.shared.colorBlack
        self.configureAVCaptureDeviceInput()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.buttonDismiss.delegate = self
        if (self.captureSession.isRunning == false) {
            self.captureSession.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.buttonDismiss.delegate = nil
        if (self.captureSession.isRunning == true) {
            captureSession.stopRunning()
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    private func configureAVCaptureDeviceInput() {
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (self.captureSession.canAddInput(videoInput)) {
            self.captureSession.addInput(videoInput)
        } else {
            self.navigationController?.popViewController(animated: true)
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()

        if (self.captureSession.canAddOutput(metadataOutput)) {
            self.captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            self.navigationController?.popViewController(animated: true)
            return
        }

        self.previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
        self.previewLayer.frame = self.cameraView.layer.bounds
        self.previewLayer.videoGravity = .resizeAspectFill
        self.cameraView.layer.addSublayer(self.previewLayer)

        self.captureSession.startRunning()
    }
    
    func found(code: String) {
        self.callback?(QrCodeScannerResult(code: code))
        dismiss(animated: true)
    }
}

extension QrCodeScannerViewController: ImageButtonViewDelegate {
    func imageButtonView(pressed: ImageButtonView) {
        dismiss(animated: true)
    }
}

extension QrCodeScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        self.captureSession.stopRunning()

        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            self.found(code: stringValue)
        }
    }
}
