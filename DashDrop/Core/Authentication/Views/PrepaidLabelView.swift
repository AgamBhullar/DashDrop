//
//  PrepaidLabelView.swift
//  DashDrop
//
//  Created by Agam Bhullar on 3/7/24.
//

import SwiftUI

struct PrepaidLabelView: View {
    @State private var showImagePicker = false
    @Binding var selectedImage: UIImage?
    @State private var qrcodeImage: Image?
    @State private var selectedPrepaidOption: SelectedPrepaidOption = .qrcode
    @Environment(\.presentationMode) var presentationMode
    var didConfirmSelection: ((UIImage?) -> Void)?

    var body: some View {
        VStack {
            VStack() {
                VStack {
                    Text("Select a prepaid option")
                        .font(.title)
                        .fontWeight(.bold)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.theme.backgroundColor)
                .cornerRadius(5)
                .shadow(radius: 5)
                
                VStack {
                    ForEach(SelectedPrepaidOption.allCases) { type in
                        Button(action: {
                            // Action based on selected option
                            selectedPrepaidOption = type
                            performActionForSelectedOption(type)
                        }) {
                            VStack {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(type.heading)
                                        //.font(.headline)
                                            .font(.system(size: 22, weight: .bold))
                                            .frame(height: 44)
                                        
                                        Text(type.subHeading)
                                            .font(.subheadline)
                                            .lineLimit(2)
                                        //.foregroundColor(Color(.systemGray2))
                                    }
                                    Spacer()
                                    Image(type.nameImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 80, height: 80)
                                }
                                .padding()
                                .foregroundColor(type == selectedPrepaidOption ? .white : Color.theme.primaryTextColor)
                                .background(type == selectedPrepaidOption ? .blue: Color.theme.secondaryBackgroundColor)
                                .scaleEffect(type == selectedPrepaidOption ? 1.05 : 1)
                                .cornerRadius(10)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                        .animation(.spring(), value: selectedPrepaidOption)
                    }
                }
            }
            //.background(Color.theme.backgroundColor)
            .cornerRadius(16)
            .shadow(radius: 20)
            .padding()
            
            // Conditionally displaying message or image based on the selected option
            if selectedPrepaidOption == .qrcode, let qrcodeImage = qrcodeImage {
                VStack {
                    Text("Selected Image:")
                        .font(.system(size: 22, weight: .bold))
                        .padding(.top)
                    qrcodeImage
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 350, maxHeight: 350)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                .transition(.scale)
            } else if selectedPrepaidOption == .selectedLabel {
                Text("Please affix the label on your sealed package before driver arrival.")
                    .font(.system(size: 32, weight: .semibold))
                    .foregroundColor(Color(.systemRed))
                    .padding(.top, 75)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 300)
            }
            
            Spacer()
            
            // Only enable the button if an option has been selected
            if selectedPrepaidOption != nil {
                Button(action: {
                    // Handle the confirmation action
                    confirmSelectionAction()
                }) {
                    Text("Confirm Selection")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding()
            }
        }
        .sheet(isPresented: $showImagePicker, 
               onDismiss: loadImage) {
            ImagePicker(selectedImage: $selectedImage)
        }
    }
    
    func loadImage() {
        guard let selectedImage = selectedImage else { return }
        qrcodeImage = Image(uiImage: selectedImage)
    }

    private func performActionForSelectedOption(_ option: SelectedPrepaidOption) {
        switch option {
        case .qrcode:
            // Open image picker to upload a QR code
            showImagePicker.toggle()
        case .selectedLabel:
            // Perform action for the shipping label option
            qrcodeImage = nil
            print("DEBUG: Shipping Label option selected")
        }
    }
    
    private func confirmSelectionAction() {
        // Implement action for confirm selection button
        didConfirmSelection?(selectedImage)
        presentationMode.wrappedValue.dismiss()
    }
}

//struct ImagePicker: View {
//    @Binding var selectedImage: UIImage?
//
//    var body: some View {
//        Text("Image Picker Placeholder")
//    }
//}

struct PrepaidLabelView_Previews: PreviewProvider {
    static var previews: some View {
        PrepaidLabelView(selectedImage: .constant(nil))
    }
}
