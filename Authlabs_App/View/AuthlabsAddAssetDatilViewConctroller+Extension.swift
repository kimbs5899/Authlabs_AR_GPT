//
//  AuthlabsAddMarkerDateilViewControler+Extension.swift
//  Authlabs_App
//
//  Created by Matthew on 4/30/24.
//

import PhotosUI
import UIKit

extension AuthlabsAddAssetDatilViewConctroller: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var overlayView: UIView {
        guard let bounds = view.window?.windowScene?.screen.bounds else {
            return UIView()
        }
        let overlayView = UIView(frame: bounds)
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        
        let targetSize = CGSize(width: 250, height: 250)
        let targetOrigin = CGPoint(x: (bounds.width - targetSize.width) / 2,
                                   y: (bounds.height - targetSize.height) / 2)
        let targetArea = UIView(frame: CGRect(origin: targetOrigin, size: targetSize))
        targetArea.layer.borderColor = UIColor.red.cgColor
        targetArea.layer.borderWidth = 3.0
        targetArea.backgroundColor = .clear

        let maskLayer = CAShapeLayer()
        let path = CGMutablePath()
        path.addRect(bounds)
        path.addRect(CGRect(origin: targetOrigin, size: targetSize))
        maskLayer.path = path
        maskLayer.fillRule = .evenOdd
        overlayView.layer.mask = maskLayer

        overlayView.addSubview(targetArea)
        
        return overlayView
    }
    
    func presentCameraView() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            markerImageView.image = selectedImage
        }
        picker.dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

// MARK: - PHPickerViewControllerDelegate
extension AuthlabsAddAssetDatilViewConctroller: PHPickerViewControllerDelegate {
    func presentPickerViewController() {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.filter = .images
        let pickerViewController = PHPickerViewController(configuration: configuration)
        pickerViewController.delegate = self
        present(pickerViewController, animated: true)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        if let itemProvider = results.first?.itemProvider,
           itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                DispatchQueue.main.async {
                    guard let selectedImage = image as? UIImage else { return }
                    self?.markerImageView.image = selectedImage
                }
            }
        }
        picker.dismiss(animated: true)
    }
}
