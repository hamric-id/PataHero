//
//  Common.swift
//  PataHero
//
//  Created by Muhammad Hamzah Robbani on 30/03/25.
//


import SwiftUI

//#if !os(watchOS)
struct callEkaHospital_Button: View {
    private let maxWidth: Bool
    @State private var showCallNotSupportAlert:Bool = false
    
    init(_ maxWidth: Bool=false) {
        #if os(watchOS)
            self.maxWidth = false
        #else
            self.maxWidth = maxWidth
        #endif
    }
    
    var body: some View{
        Button{
            #if os(watchOS)
                print("belum bisa")
            #else
                if !callPhoneNumber(EkaHospital_PhoneNumber()){showCallNotSupportAlert=true}
            #endif
        }label:{
            #if !os(watchOS)
                Text("Eka Hospital")
            #endif
        }
            .buttonStyle(
                ButtonStyleSimple(
                    Color.green,
                    Color.green.opacity(0.7),
                    27,
                    Color.white,
                    maxWidth,
                    "phone.fill"
                )
            )
            .padding(.horizontal)
            .alert("Device Doesn't Support Call Phone Number", isPresented: $showCallNotSupportAlert) {
                Button("Okay", role: .cancel) { }
            } message: {
                Text("Cannot Call Eka Hospital (\(EkaHospital_PhoneNumber())) because your device does not support phone calls")
            }
            .frame(width: .infinity)
            .dynamicTypeSize(.xSmall ... .accessibility2)
    }
}
//#endif

struct ClosestHospital_Button: View {
    private let onClick: (Bool) -> Void
    
    init(_ onClick: @escaping (Bool) -> Void) {//@escaping berfungsi agar bisa lambda callback entah kenapa. jika tidak pakai katanya setara sync alias spt return
        self.onClick = onClick
    }
    
    private func maxWidth() -> Bool {
        #if os(watchOS)
        return false
        #else
        return true
        #endif
    }
    
    var body: some View {
        Button{onClick(true)}label:{}
            .buttonStyle(
                ButtonStyleSimple(
                    Color("blue"),
                    Color("white"),
                    27,
                    Color.reversePrimary,
                    maxWidth(),
                    iconName:"cross.case.fill"
                )
            )
            #if os(iOS)
            .padding(.horizontal,30)
            .padding(.bottom, 13)
            #endif
            .dynamicTypeSize(.xSmall ... .xxxLarge)
    }
}

struct ButtonStyleSimple: ButtonStyle {
    private let color: Color
    private let colorWhenPressed: Color
    private let iconName1: ContiguousArray<UInt8>?
    private let colorDescription: Color
    private let cornerRadius: UInt8
    private let maxWidth: Bool
        
    init(
        _ color: Color ,
        _ colorWhenPressed: Color = .primary,
        _ cornerRadius: UInt8 = 27,
        _ colorDescription: Color = .reversePrimary,
        _ maxWidth:Bool=false,
        iconName: String?) {
        self.maxWidth = maxWidth
        self.color = color
        self.colorWhenPressed = colorWhenPressed
        self.iconName1 = if iconName?.isEmpty ?? false { nil } else {iconName?.ContingousArray()}
        self.colorDescription = colorDescription
        self.cornerRadius = cornerRadius
    }

    init(
        _ color: Color ,
        _ colorWhenPressed: Color,
        _ cornerRadius: UInt8 = 27,
        _ colorDescription: Color,
        _ maxWidth:Bool=false,
        _ iconName: String?) {
        self.maxWidth = maxWidth
        self.color = color
        self.colorWhenPressed = colorWhenPressed
        self.iconName1 = if iconName?.isEmpty ?? false { nil} else {iconName?.ContingousArray()}
        self.colorDescription = colorDescription
        self.cornerRadius = cornerRadius
    }
    
    
    
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            if iconName1 != nil { Image(systemName: iconName1!.String1())   }
            configuration.label //label ditambahkan saat buat Button("label"){}
        }
        .padding()
        .frame(maxWidth: maxWidth ? .infinity : nil)
        .background(configuration.isPressed ? colorWhenPressed: color)
        .foregroundColor(colorDescription)
        .cornerRadius(CGFloat(cornerRadius))
    }
}

#Preview {
    ClosestHospital_Button{a in }
//    callEkaHospital_Button(true)
}

