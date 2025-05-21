//
//  ProcedureFractures_Button.swift
//  PataHero
//
//  Created by Muhammad Hamzah Robbani on 29/03/25.
//

import SwiftUI
//import UIKit

struct ProcedureFractures_Button: View {
    private let dataPreviewFractures: DataPreviewFractures
    @State private var isTouch: Bool = false {
        didSet {
            selectedButton_LocationFractures = dataPreviewFractures.locationFractures
        }
    }
    @Binding private var selectedButton_LocationFractures: LocationFractures?
    let onClick: (LocationFractures) -> Void
    
    init(_ dataPreviewFractures: DataPreviewFractures,_ selectedButton_LocationFractures: Binding<LocationFractures?> ,_ onClick: @escaping (LocationFractures) -> Void) {//@escaping berfungsi agar bisa lambda callback entah kenapa. jika tidak pakai katanya setara sync alias spt return
        self.dataPreviewFractures = dataPreviewFractures
        self.onClick = onClick
        self._selectedButton_LocationFractures = selectedButton_LocationFractures
    }
    
    private func widthButton()->CGFloat{
        let paddingHorizontal:CGFloat
        
        #if os(watchOS)
            paddingHorizontal = 5
        #else
            paddingHorizontal = 80
        #endif
        
        return screenSize().width - paddingHorizontal
    }
    
    private func heightButton()->CGFloat{
        #if os(watchOS)
            return 55
        #else
            return 80
        #endif
    }
    
    private func fontSize()->CGFloat{
        #if os(watchOS)
                return 19
        #else
                return 25
        #endif
    }
    
    var body: some View { //choose your action/halaman awal
        HStack {
            Image(dataPreviewFractures.imageName())
                .resizable()//supaya ukuran bisa dinamis
                .frame(width: heightButton(), height: heightButton())
                .aspectRatio(contentMode: .fit)//aspect
            Text(dataPreviewFractures.locationFractures.name())
                .foregroundColor(Color.reversePrimary)
                .bold()
                .multilineTextAlignment(.center)
                .font(.system(size:fontSize()))
                .frame(maxWidth: .infinity, alignment: .center)
            Spacer()
        }
        .frame(width: widthButton())
        .background(isTouch ?
                        Color.clear :
                    (selectedButton_LocationFractures==nil || selectedButton_LocationFractures==dataPreviewFractures.locationFractures) ?
                        Color.red :
                        Color.lightRed.opacity(0.5)
        )
        .cornerRadius(38)//supaya bundar
        .simultaneousGesture(//harus terakhir setelah atur frame dan corner
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isTouch = true }
                .onEnded { _ in
                    isTouch = false//print("hehe2 \(dataPreviewFractures.locationFractures)")
                    selectedButton_LocationFractures = dataPreviewFractures.locationFractures
                    onClick(dataPreviewFractures.locationFractures)
                }
        )
    }
}


#Preview {
    @State var locationFractures1:LocationFractures? = LocationFractures.pergelangan_tangan
    ProcedureFractures_Button(DataPreviewFractures(locationFractures1!), $locationFractures1 ){ locationFractures in
        
    }
}
