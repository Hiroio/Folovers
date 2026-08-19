//
//  PhotoSelectorRepresentable.swift
//  Folovers
//
//  Created by user on 18.08.2026.
//

import SwiftUI
import PhotosUI

struct PhotoSelectorRepresentable: UIViewControllerRepresentable {
  var selectionLimit: Int = 0
  var onSelect: ([UIImage]) -> Void

  func makeUIViewController(context: Context) -> PHPickerViewController {
	 var config = PHPickerConfiguration()
	 config.filter = .images
	 config.selectionLimit = selectionLimit

	 let picker = PHPickerViewController(configuration: config)
	 picker.delegate = context.coordinator
	 return picker
  }

  func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

  func makeCoordinator() -> Coordinator {
	 Coordinator(onSelect: onSelect)
  }

  final class Coordinator: NSObject, PHPickerViewControllerDelegate {
	 let onSelect: ([UIImage]) -> Void

	 init(onSelect: @escaping ([UIImage]) -> Void) {
		self.onSelect = onSelect
	 }

	 func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
		picker.dismiss(animated: true)

		guard !results.isEmpty else { return }

		let group = DispatchGroup()
		var images: [UIImage] = []

		for result in results {
		  guard result.itemProvider.canLoadObject(ofClass: UIImage.self) else { continue }
		  group.enter()
		  result.itemProvider.loadObject(ofClass: UIImage.self) { object, _ in
			 if let image = object as? UIImage {
				images.append(image)
			 }
			 group.leave()
		  }
		}

		group.notify(queue: .main) { [onSelect] in
		  onSelect(images)
		}
	 }
  }
}


#Preview {
  ZStack{
	 PhotoSelectorRepresentable(onSelect: { _ in })
  }
}
