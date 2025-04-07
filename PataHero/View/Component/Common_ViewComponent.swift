//
//  Common.swift
//  PataHero
//
//  Created by Muhammad Hamzah Robbani on 30/03/25.
//


import SwiftUI

struct callEkaHospital_Button: View {
    private let maxWidth: Bool
    @State private var showCallNotSupportAlert:Bool = false
    
    init(_ maxWidth: Bool=false) {
        self.maxWidth = maxWidth
    }
    
    var body: some View{
        Button("Eka Hospital"){
            if !callPhoneNumber(EkaHospital_PhoneNumber()){showCallNotSupportAlert=true}
        }
        .buttonStyle(
            ButtonStyleSimple(
                Color.green,
                Color.green.opacity(0.7),
                27,
                Color.red,
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
    callEkaHospital_Button(true)
}

//ini digunakan untuk membuat button custom supaya reuseable untuk apapun, bisa untuk tombol call, close, done, dll
//struct Button: View {
//    private let description: [Character]?
//    private let color: Color
//    private let colorWhenPressed: Color
//    private let iconName1: [Character]?
//    private let colorDescription: Color
//    private let cornerRadius: UInt8
//    @State private var isTouch: Bool = false
//    let onTouch: (Bool) -> Void //jika true perubahan dari tidak disentuh menjadi disentuh, false sebaliknya
//
//    private func touch(_ mode:Bool){
//        isTouch = mode
//        onTouch(mode)
//    }
//
//    private func iconName()-> String { iconName1.map {String($0)} ?? "" }
//
//    init(
//        _ color: Color ,
//        _ colorWhenPressed: Color = .primary,
//        _ cornerRadius: UInt8 = 27,
//        _ colorDescription: Color = .reversePrimary,
//        iconName: String?,
//        description: String?
//        _ onTouch: @escaping (Bool) -> Void) {
//
//        if iconName==nil&&description==nil{fatalError("Button must have iconName or description")}
//
//        self.description = if description?.isEmpty ?? false { nil} else {description?.map{$0}}
//        self.color = color
//        self.colorWhenPressed = colorWhenPressed
//        self.iconName1 = if iconName?.isEmpty ?? false { nil} else {iconName?.map{$0}}
//        self.onTouch = onTouch
//        self.colorDescription = colorDescription
//        self.cornerRadius = cornerRadius
//    }
//
//    init(
//        _ color: Color ,
//        _ colorWhenPressed: Color,
//        _ cornerRadius: UInt8 = 27,
//        _ colorDescription: Color,
//        _ iconName: String? = nil,
//        _ description: String? = nil,
//        _ onTouch: @escaping (Bool) -> Void) {
//
//        if iconName==nil&&description==nil{fatalError("Button must have iconName or description")}
//
//        self.description = if description?.isEmpty ?? false { nil} else {description?.map{$0}}
//        self.color = color
//        self.colorWhenPressed = colorWhenPressed
//        self.iconName1 = if iconName?.isEmpty ?? false { nil} else {iconName?.map{$0}}
//        self.onTouch = onTouch
//        self.colorDescription = colorDescription
//        self.cornerRadius = cornerRadius
//    }
//
//    var body: some View { //choose your action/halaman awal
//
//        if description==nil {
//            Image(systemName: iconName())
//                .padding()
//                .background(isTouch ? colorWhenPressed:color)
//                .foregroundColor(.white)
//                .cornerRadius(27)
//                .simultaneousGesture(//harus terakhir setelah atur frame dan corner
//                    DragGesture(minimumDistance: 0)
//                        .onChanged { _ in touch(true) }
//                        .onEnded { _ in touch(false)}
//                )
//        }else{
//            Label(description.map { String($0) } ?? "", systemImage: iconName())
//                .padding()
//                .background(isTouch ? colorWhenPressed:color)
//
//                .foregroundColor(.white)
//                .cornerRadius(27)
//                .simultaneousGesture(//harus terakhir setelah atur frame dan corner
//                    DragGesture(minimumDistance: 0)
//                        .onChanged { _ in touch(true) }
//                        .onEnded { _ in touch(false)}
//                )
//        }
//
////        Label(description.map { String($0) } ?? "", systemImage: "phone.fill") // Uses native phone icon
////            .padding()
////            .background(isTouch ? Color.green.opacity(0.7):Color.green)
////            .foregroundColor(.white)
////            .cornerRadius(27)
////            .simultaneousGesture(//harus terakhir setelah atur frame dan corner
////                DragGesture(minimumDistance: 0)
////                    .onChanged { _ in touch(true) }
////                    .onEnded { _ in touch(false)}
////            )
////        Link(destination: URL(string: "tel://1234567890")!) {
////            Label("Call Now", systemImage: "phone.fill") // Uses native phone icon
////                .padding()
////                .background(Color.green)
////                .foregroundColor(.white)
////                .cornerRadius(8)
////        }
//
////        HStack {
////            Image(dataPreviewFractures.imageName())
////                .resizable()//supaya ukuran bisa dinamis
////                .frame(width: 80, height: 80)
////                .aspectRatio(contentMode: .fit)//aspect
////            Text(dataPreviewFractures.fractureName())
////                .foregroundColor(Color("reverse_primary"))
////                .bold()
////                .multilineTextAlignment(.center)
////                .font(.system(size: 25))
////                .frame(maxWidth: .infinity, alignment: .center)
////            Spacer()
////        }
////        .frame(width: UIScreen.main.bounds.width - 80)
////        .background(isTouching ? Color("red") : Color("light_red"))
////        .cornerRadius(38)//supaya bundar
////        .simultaneousGesture(//harus terakhir setelah atur frame dan corner
////            DragGesture(minimumDistance: 0)
////                .onChanged { _ in isTouching = true }
////                .onEnded { _ in
////                    isTouching = false
////                    onClick(dataPreviewFractures.locationFractures)
////                }
////        )
//    }
//}

