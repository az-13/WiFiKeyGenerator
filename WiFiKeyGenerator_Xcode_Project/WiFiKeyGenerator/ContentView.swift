import SwiftUI

struct ContentView: View {
    // Colors
    let bgColor = Color(red: 15/255, green: 15/255, blue: 15/255)
    let primaryBlue = Color(red: 58/255, green: 123/255, blue: 213/255)
    let hoverBlue = Color(red: 42/255, green: 92/255, blue: 168/255)
    let frameBg = Color(red: 26/255, green: 26/255, blue: 26/255)
    let textColor = Color(red: 224/255, green: 224/255, blue: 224/255)
    let secondaryBg = Color(red: 42/255, green: 42/255, blue: 42/255)

    // State
    @State private var password = ""
    @State private var passwordLength: Double = 16
    @State private var useUpper = true
    @State private var useLower = true
    @State private var useNumbers = true
    @State private var useSymbols = true
    @State private var copied = false
    
    // Character sets
    let upperChars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    let lowerChars = "abcdefghijklmnopqrstuvwxyz"
    let numberChars = "0123456789"
    let symbolChars = "!@#$%^&*-=_+"
    
    var body: some View {
        ZStack {
            bgColor.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 25) {
                    Text("Wi-Fi Key Generator")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(primaryBlue)
                        .padding(.top, 20)
                    
                    // Password Display
                    VStack {
                        Text(password.isEmpty ? "Generating..." : password)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.vertical, 18)
                            .padding(.horizontal, 15)
                            .frame(maxWidth: .infinity)
                    }
                    .background(frameBg)
                    .cornerRadius(12)
                    
                    // Settings Panel
                    VStack(alignment: .leading, spacing: 20) {
                        // Slider
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Password Length: \(Int(passwordLength))")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(textColor)
                            
                            Slider(value: $passwordLength, in: 8...64, step: 1)
                                .accentColor(primaryBlue)
                        }
                        .padding(.bottom, 10)
                        
                        // Checkboxes
                        VStack(alignment: .leading, spacing: 15) {
                            CustomCheckbox(title: "Uppercase Letters (A-Z)", isChecked: $useUpper, primaryBlue: primaryBlue, secondaryBg: secondaryBg, textColor: textColor)
                            CustomCheckbox(title: "Lowercase Letters (a-z)", isChecked: $useLower, primaryBlue: primaryBlue, secondaryBg: secondaryBg, textColor: textColor)
                            CustomCheckbox(title: "Numbers (0-9)", isChecked: $useNumbers, primaryBlue: primaryBlue, secondaryBg: secondaryBg, textColor: textColor)
                            CustomCheckbox(title: "Special Symbols (!@#$)", isChecked: $useSymbols, primaryBlue: primaryBlue, secondaryBg: secondaryBg, textColor: textColor)
                        }
                    }
                    .padding(20)
                    .background(frameBg)
                    .cornerRadius(12)
                    
                    // Action Buttons
                    HStack(spacing: 15) {
                        Button(action: {
                            generatePassword()
                        }) {
                            Text("Generate")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 15)
                                .background(primaryBlue)
                                .cornerRadius(8)
                        }
                        
                        Button(action: {
                            copyPassword()
                        }) {
                            Text(copied ? "Copied!" : "Copy")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(copied ? .white : textColor)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 15)
                                .background(copied ? Color(red: 40/255, green: 167/255, blue: 69/255) : secondaryBg)
                                .cornerRadius(8)
                        }
                    }
                }
                .padding(.horizontal, 25)
                .padding(.bottom, 30)
            }
        }
        .onAppear {
            generatePassword()
        }
    }
    
    private func generatePassword() {
        var charSet = ""
        
        if useUpper { charSet += upperChars }
        if useLower { charSet += lowerChars }
        if useNumbers { charSet += numberChars }
        if useSymbols { charSet += symbolChars }
        
        if charSet.isEmpty {
            password = "Select an option!"
            return
        }
        
        var newPassword = ""
        let length = Int(passwordLength)
        
        for _ in 0..<length {
            if let randomChar = charSet.randomElement() {
                newPassword.append(randomChar)
            }
        }
        
        password = newPassword
        copied = false
    }
    
    private func copyPassword() {
        if password != "Select an option!" {
            UIPasteboard.general.string = password
            copied = true
            
            // Reset "Copied!" text after a delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                copied = false
            }
        }
    }
}

struct CustomCheckbox: View {
    let title: String
    @Binding var isChecked: Bool
    let primaryBlue: Color
    let secondaryBg: Color
    let textColor: Color
    
    var body: some View {
        Button(action: {
            isChecked.toggle()
        }) {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 4)
                        .strokeBorder(isChecked ? primaryBlue : secondaryBg, lineWidth: 2)
                        .background(RoundedRectangle(cornerRadius: 4).fill(isChecked ? primaryBlue : Color.clear))
                        .frame(width: 18, height: 18)
                    
                    if isChecked {
                        Image(systemName: "checkmark")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
                
                Text(title)
                    .font(.system(size: 14))
                    .foregroundColor(textColor)
                
                Spacer()
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}
