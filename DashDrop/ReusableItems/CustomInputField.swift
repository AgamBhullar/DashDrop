//
//  CustomInputField.swift
//  DashDrop
//
//  Created by Agam Bhullar on 3/2/24.
//

import SwiftUI

struct CustomUITextField: UIViewRepresentable {
    class Coordinator: NSObject, UITextFieldDelegate {
        @Binding var text: String
        var didBeginEditing: () -> Void
        
        init(text: Binding<String>, didBeginEditing: @escaping () -> Void) {
            self._text = text
            self.didBeginEditing = didBeginEditing
        }
        
        func textFieldDidChangeSelection(_ textField: UITextField) {
            text = textField.text ?? ""
        }
        
        func textFieldDidBeginEditing(_ textField: UITextField) {
            self.didBeginEditing()
        }
    }
    
    var isSecureField: Bool = false
    var placeholder: String
    @Binding var text: String
    
    var placeholderColor: UIColor = .gray
    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField(frame: .zero)
        textField.isSecureTextEntry = isSecureField
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [.foregroundColor: placeholderColor]
        )
        textField.delegate = context.coordinator
        textField.textColor = .white
        return textField
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text, didBeginEditing: {
            
        })
    }
}

struct CustomInputField: View {
    @Binding var text: String
    let title: String
    let placeholder: String
    var isSecureField = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            //title
            Text(title)
                .foregroundColor(.white)
                .fontWeight(.semibold)
                .font(.footnote)
            
            // Custom UITextField
            CustomUITextField(isSecureField: isSecureField, placeholder: placeholder, text: $text, placeholderColor: UIColor.gray)
                .frame(height: 40) // Set the desired height
            
            //divider
            Rectangle()
                .foregroundColor(Color(.init(white: 1, alpha: 0.3)))
                .frame(width: UIScreen.main.bounds.width - 32, height: 0.7)
        }
    }
}

struct CustomInputField_Previews: PreviewProvider {
    static var previews: some View {
        CustomInputField(text: .constant(""), title: "Email", placeholder: "name@example.com")
    }
}
