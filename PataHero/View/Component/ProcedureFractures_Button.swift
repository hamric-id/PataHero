//
//  ProcedureFractures_Button.swift
//  PataHero
//
//  Created by Muhammad Hamzah Robbani on 29/03/25.
//

import SwiftUI
import UIKit

struct ProcedureFractures_Button: View {
    private let dataPreviewFractures: DataPreviewFractures
    @State private var isTouch: Bool = false
    let onClick: (LocationFractures) -> Void
    
    init(_ dataPreviewFractures: DataPreviewFractures, _ onClick: @escaping (LocationFractures) -> Void) {//@escaping berfungsi agar bisa lambda callback entah kenapa. jika tidak pakai katanya setara sync alias spt return
        self.dataPreviewFractures = dataPreviewFractures
        self.onClick = onClick
    }
    
    var body: some View { //choose your action/halaman awal
        HStack {
            Image(dataPreviewFractures.imageName())
                .resizable()//supaya ukuran bisa dinamis
                .frame(width: 80, height: 80)
                .aspectRatio(contentMode: .fit)//aspect
            Text(dataPreviewFractures.fractureName())
                .foregroundColor(Color("reverse_primary"))
                .bold()
                .multilineTextAlignment(.center)
                .font(.system(size: 25))
                .frame(maxWidth: .infinity, alignment: .center)
            Spacer()
        }
        .frame(width: UIScreen.main.bounds.width - 80)
        .background(isTouch ? Color("red") : Color("light_red"))
        .cornerRadius(38)//supaya bundar
        .simultaneousGesture(//harus terakhir setelah atur frame dan corner
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isTouch = true }
                .onEnded { _ in
                    isTouch = false
                    print("hehe2 \(dataPreviewFractures.locationFractures)")
                    onClick(dataPreviewFractures.locationFractures)
                }
        )
    }
}


#Preview {
    ProcedureFractures_Button(DataPreviewFractures(LocationFractures.pergelangan_tangan)){ locationFractures in
        
    }
}
