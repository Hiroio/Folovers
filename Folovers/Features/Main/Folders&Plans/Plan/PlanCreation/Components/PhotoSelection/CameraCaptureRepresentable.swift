//
//  CameraCaptureRepresentable.swift
//  Folovers
//
//  Created by user on 18.08.2026.
//

import SwiftUI
import AVFoundation

struct CameraCaptureRepresentable: UIViewControllerRepresentable {
  var onCapture: (UIImage) -> Void

  func makeUIViewController(context: Context) -> UIImagePickerController {
	 let picker = UIImagePickerController()
	 picker.sourceType = .camera
	 picker.delegate = context.coordinator
	 return picker
  }

  func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

  func makeCoordinator() -> Coordinator {
	 Coordinator(onCapture: onCapture)
  }

  final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	 let onCapture: (UIImage) -> Void

	 init(onCapture: @escaping (UIImage) -> Void) {
		self.onCapture = onCapture
	 }

	 func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
		picker.dismiss(animated: true)
		if let image = info[.originalImage] as? UIImage {
		  onCapture(image)
		}
	 }

	 func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		picker.dismiss(animated: true)
	 }
  }
}

extension CameraCaptureRepresentable{
  static func requestAccess(completion: @escaping (Bool) -> Void) {
	 switch AVCaptureDevice.authorizationStatus(for: .video) {
	 case .authorized:
		completion(true)
	 case .notDetermined:
		AVCaptureDevice.requestAccess(for: .video) { granted in
		  DispatchQueue.main.async {
			 completion(granted)
		  }
		}
	 case .denied, .restricted:
		completion(false)
	 @unknown default:
		completion(false)
	 }
  }
}
