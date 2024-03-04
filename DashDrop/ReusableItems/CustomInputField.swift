//
//  CustomInputField.swift
//  DashDrop
//
//  Created by Harpreet Basota on 3/1/24.
//

import SwiftUI

struct CustomInputField: View {
    @Binding var text: String
    let title : String
    let placeholder: String
    var isSecuredField = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12){
            //title
            Text(title)
                .foregroundColor(.black)
                .fontWeight(.semibold)
                .font(.footnote)
            
            // text field
            
            if isSecuredField{
                SecureField(placeholder, text: $text)
            } else{
                TextField(placeholder, text: $text)
                    .foregroundColor(.black)
            }
            
            //divider
            Rectangle()
                .foregroundColor(Color.black)
                .frame(width: UIScreen.main.bounds.width - 32, height: 0.7)
        }
    }
}

#Preview {
    CustomInputField(text: .constant(""), title: "Email", placeholder: "name@example.com")
}
