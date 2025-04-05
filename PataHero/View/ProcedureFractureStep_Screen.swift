//
//  ProcedureFractureStepPage.swift
//  PataHero
//
//  Created by Muhammad Hamzah Robbani on 30/03/25.
//

import SwiftUI

struct HeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}


struct ProcedureFractureStep_Screen: View {
    @Binding private var currentScreen: AppScreen
//    private let totalStep: UInt8
    let locationFractures: LocationFractures
    private let listProcedure: [StepProcedureFractures]
    @State var currentStep: UInt8//jika ingin ganti step langsung ubah
    @State private var neverHighlightedGestureTutorial:Bool = true
    //dimatikan karena taruh saja di viewholder
//    @State var onHightlightGestureTutorial: Bool = false
//    @State var onVisibleHintGestureRight: Bool
//    @State var onVisibleHintGestureLeft: Bool
    
    func tinggi(){
        if let window1 = UIApplication.shared.windows.first {
            //window1.bounds.height - window1.safeAreaInsets.top //- window.safeAreaInsets.bottom
            print("tinggi total \(window1.bounds.height - window1.safeAreaInsets.top)")
        }
    }
    

    
    init(_ currentScreen: Binding<AppScreen> ,_ locationFractures: LocationFractures, _ currentStep: UInt8 = 1) {
//        totalStep = locationFractures.totalStepProcedureFractures()
        self._currentScreen = currentScreen
        self.locationFractures = locationFractures
        self.currentStep = currentStep
        listProcedure = locationFractures.listProcedure()
//        onVisibleHintGestureLeft = if currentStep==1 {false} else {true}
//        onVisibleHintGestureRight = if currentStep>=listProcedure.count{false} else {true}
    }
    
    var body: some View {
        VStack() {
            HStack{
                Text(String(describing: locationFractures).replacingOccurrences(of: "_", with: " ").capitalized.replacingOccurrences(of: " ", with: "\n"))
                    .frame(width:90)
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .bold()
                    .padding(.leading, 35)
                    .padding(.top,4)
                    .foregroundColor(Color("red"))
//                    .shadow(color: .black, radius: 0.8, x: 0.8, y: 0.8)
                Spacer()
                Button{
                    currentScreen = .contentView
                    locationFractures_ProcedureFracture_Screen = nil
                }label:{}
                    .buttonStyle(
                        ButtonStyleSimple(Color("red"),Color("pink"),27,Color.reversePrimary,iconName:"xmark")
                    )
                    .padding(.trailing, 45)
                    .padding(.top, 7)
            }//.ignoresSafeArea()//.frame(height:20)
//                    .padding(.bottom, 20)
            MultiPoint_ProgressBar(UInt8(listProcedure.count), $currentStep)
                .padding(.horizontal, 20)
            .overlay(GeometryReader { geometry in
                Color.clear
                    .preference(key: HeightPreferenceKey.self, value: geometry.size.height)
            })
            .onPreferenceChange(HeightPreferenceKey.self) { newHeight in
                print("tinggi komponen atas \(newHeight);")
                tinggi()
            }

            Spacer()

            TabView(selection: $currentStep){
                ForEach(1...listProcedure.count, id: \.self) { stepTo in
                    ProcedureFractureStepViewHolder(
                        locationFractures,
                        UInt8(stepTo),
                        $neverHighlightedGestureTutorial
                    ).tag(UInt8(stepTo))
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))//settingan tabview agar bisa hilangkan dot white index penanda posisi
            .onChange(of: currentStep) { newIndex in
                //mendeteksi jika halaman baru(sebelum/setelah) sudah tampil >50% meskipun masih proses swipe)
                print("Page changed to: \(newIndex)")
            }
            Spacer()
            
            callEkaHospital_Button(true)
                .padding(.horizontal, 10)
                .padding(.bottom, 5)
                .overlay(GeometryReader { geometry in
                    Color.clear
                        .preference(key: HeightPreferenceKey.self, value: geometry.size.height)
                })
                .onPreferenceChange(HeightPreferenceKey.self) { newHeight in
                    print("tinggi komponen bawah \(newHeight)")
                    tinggi()
                }
            
        }
        .background(Color("pink"))
        .ignoresSafeArea(.all)
        .statusBarHidden(true)
    }
}

struct ProcedureFractureStepViewHolder: View {
    let totalStep: UInt8
    let locationFractures: LocationFractures
    @Binding private var highlightGestureTutorial: Bool
    @State var stepProcedureFractures: StepProcedureFractures
    @State var currentStep: UInt8//jika ingin ganti step langsung ubah saja ini karena sudah terhubung state
    @State var highlightGestureTutorialOpacity: Float16 = 0
    @State var highlightGestureTutorialTimer: Timer?
    @State var onHightlightGestureTutorial: Bool = false
    @State private var highlightGestureTutorialOpacityIncrease: Bool = true //kalau false berati sedang mode decrease/menghilangkan
    @State var onVisibleHintGestureRight: Bool
    @State var onVisibleHintGestureLeft: Bool
    
    
    init(_ locationFractures: LocationFractures,_ currentStep: UInt8, _ highlightGestureTutorial: Binding<Bool>) {
        print("hehe \(locationFractures)")
        self._highlightGestureTutorial = highlightGestureTutorial
        self.currentStep = currentStep
        self.totalStep = locationFractures.totalStepProcedureFractures()
        self.locationFractures = locationFractures
        self.stepProcedureFractures = locationFractures.stepProcedureFractures(currentStep)
        self.onVisibleHintGestureLeft = if currentStep==1 {false} else {true}
        self.onVisibleHintGestureRight = if currentStep>=totalStep{false} else {true}
    }
    
    func highlightGestureTutorial(_ mode:Bool) {
        if mode{
            if onVisibleHintGestureRight {
                print("hola1")
                onHightlightGestureTutorial = true
                highlightGestureTutorialTimer?.invalidate() // Stop any existing timer
                
                let changeOpacityInterval:Float16 = 0.2
                highlightGestureTutorialTimer = Timer.scheduledTimer(withTimeInterval: Double(changeOpacityInterval), repeats: true) { _ in
                    if !onHightlightGestureTutorial { return }
                    withAnimation(.linear(duration: Double(changeOpacityInterval))) {
                        if highlightGestureTutorialOpacityIncrease {
                            highlightGestureTutorialOpacity += 0.1
                            if highlightGestureTutorialOpacity >= 0.5 {
                                highlightGestureTutorialOpacityIncrease = false // Start decreasing
                            }
                        } else {
                            highlightGestureTutorialOpacity -= 0.1
                            if highlightGestureTutorialOpacity <= 0 {
                                highlightGestureTutorialOpacityIncrease = true // Start increasing
                            }
                        }
                        print("hola2 \(highlightGestureTutorialOpacity)")
                    }
                }
            }
        }else{
            onHightlightGestureTutorial = false
            highlightGestureTutorialTimer?.invalidate()
            highlightGestureTutorialOpacity = 0// Reset opacity when
        }
    }

    var body: some View {
        ZStack{
            VStack() {
                Spacer()

                Image(stepProcedureFractures.imageName(locationFractures, currentStep))
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                Spacer()
            }.frame(height:530)
            VStack{
                Spacer()
                
                Text(stepProcedureFractures.description())
                    .frame(maxWidth: .infinity, alignment: .center)
                    .multilineTextAlignment(.center)
                    .background(Color.gray.opacity(0.3))
//                    .padding(.bottom, 12)
            }.frame(height:530)
            HStack{
                Text("⟪⟪")
                    .font(.title)
                    .padding(.leading, 5)
                    .opacity(onVisibleHintGestureLeft ? 1 : 0)
                Spacer()
                Text("⟫⟫")
                    .font(.title)
                    .frame(width:(UIScreen.main.bounds.width/2),height: UIScreen.main.bounds.height,alignment: .trailing)
                    .padding(.trailing, 5)
                    .background(Color.green.opacity(Double(highlightGestureTutorialOpacity)))
                    .opacity(onVisibleHintGestureRight ? 1 : 0)
                    .onAppear{
                        if highlightGestureTutorial{
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {//hidupkan setelah 3 detik
                                highlightGestureTutorial=false
                                highlightGestureTutorial(true)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 12) {//matikan setelah 8 detik
                                    highlightGestureTutorial(false)
                                }
                            }
                        }else{ highlightGestureTutorial(false)} //karena rencananya nantyi di recycler
                    }
            }.frame(height:530)
        }
        .frame(height:530)
        .background(Color.clear)
    }
}

#Preview {
    @State var a = AppScreen.ProcedureFracture_Screen
    ProcedureFractureStep_Screen($a,LocationFractures.jari)
//    ProcedureFractureStepViewHolder(LocationFractures.jari,4)
    //ProcedureFractureStepPage(LocationFractures.jari,4)
//    ProcedureFractureStepPage(stepNumber:1, stepText:"coba",imageName: "fracture")
}
