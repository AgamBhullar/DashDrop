//
//  ImagePicker.swift
//  DashDrop
//
//  Created by Agam Bhullar on 2/13/24.
//

import Foundation
import SwiftUI
import UIKit

struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedImage: UIImage?
    var onImageUploaded: (String) -> Void // Callback for when the image is uploaded
    
    // Coordinator class to handle image picking.
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        // This function is called when an image is picked.
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            print("Image Picker: didFinishPickingMediaWithInfo called") // Debug statement
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
                print("Image Picker: Image selected") // Debug statement
                parent.uploadImageToImgur(image: image) // Call upload here
            } else {
                print("Image Picker: No image found") // Debug statement
            }
            
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        // This method intentionally left blank
    }
    
    // This function handles the uploading of the image to Imgur.
    func uploadImageToImgur(image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            print("Image Picker: Failed to convert image to JPEG data")
            return
        }
        let base64Image = imageData.base64EncodedString(options: .lineLength64Characters)

        var request = URLRequest(url: URL(string: "https://api.imgur.com/3/image")!)
        request.httpMethod = "POST"
        request.addValue("Client-ID f88110642850d66", forHTTPHeaderField: "Authorization") // Make sure to replace YOUR_CLIENT_ID with your actual Client-ID
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //request.httpBody = "{\"image\": \"\(base64Image)\"}".data(using: .utf8)
        request.httpBody = imageData // Directly use binary data

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Image Picker: Upload error - \(error.localizedDescription)")
                return
            }

            // Check the HTTP Status Code
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Status Code: \(httpResponse.statusCode)")
                // Check if the status code is not 200 OK
                if httpResponse.statusCode != 200 {
                    print("Image Picker: HTTP Request not successful. Status Code: \(httpResponse.statusCode)")
                    return
                }
            }

                    // Process the successful response
            guard let data = data else {
                print("Image Picker: No data received")
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let data = json["data"] as? [String: Any],
                   let link = data["link"] as? String {
                    DispatchQueue.main.async {
                        print("Image Picker: Image uploaded successfully - \(link)")
                        self.onImageUploaded(link) // Call the callback with the image URL
                    }
                } else {
                    print("Image Picker: Failed to parse JSON or missing 'link'")
                }
            } catch {
                print("Image Picker: Serialization error - \(error.localizedDescription)")
            }
        }
        task.resume()
    }
}
