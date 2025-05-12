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
    @Environment(\.dismiss) private var dismiss//supaya bisa back navlink dengan tombol custom
    @EnvironmentObject private var handGesture_Manager: HandGesture_Manager
    private let locationFractures: LocationFractures
    @State private var showSheetTools = false//true
    private let listProcedure: [StepProcedureFractures]
    @State var currentStep: UInt8=1{
        didSet {
            if currentStep<1 || currentStep>UInt8(listProcedure.count) {
                currentStep = min(max(currentStep, 1), UInt8(listProcedure.count))
            }
        }
    }//jika ingin ganti step langsung ubah
    @State private var neverHighlightedGestureTutorial:Bool = true
    
    
    private func speak(_ text:String){TextToSpeech_Manager.Manager.speak(text)}
    
    
    private func changeStepPage(_ action:Action_ChangePage){
        DispatchQueue.main.async{//hidupkan setelah 3 detik
            withAnimation(.easeInOut){
                if action == .next { currentStep+=1
                }else {if currentStep != 0 {currentStep-=1}}
            }
        }
    }
    
    private func handGestureDetected(_ handGesture: HandGesture){
        switch handGesture {
            case .punch: changeStepPage(Action_ChangePage.next)
            case .retract_punch: changeStepPage(Action_ChangePage.previous)
            case .raise: dismiss()
            default: break
        }
    }
    
    init(_ locationFractures: LocationFractures, _ currentStep: UInt8 = 1) {//_ currentScreen: Binding<AppScreen> ,_ locationFractures: LocationFractures, _ currentStep: UInt8 = 1) {
        self.locationFractures = locationFractures
        self.currentStep = currentStep
        listProcedure = locationFractures.listProcedure()
    }
    
    func paddingTopProgressBar() -> CGFloat {
        #if !os(watchOS)
            return -8
        #else
            return 5
        #endif
    }
    
    var body: some View {
        ZStack{//
            TabView(selection: $currentStep){
                ForEach(1...listProcedure.count, id: \.self) { stepTo in
                    ProcedureFractureStepViewHolder(
                        locationFractures,
                        UInt8(stepTo),
                        $neverHighlightedGestureTutorial
                    ).tag(UInt8(stepTo))
                    .padding(.top,-26)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))//settingan tabview agar bisa hilangkan dot white index penanda posisi
            .onChange(of: currentStep) { newIndex in
                //mendeteksi jika halaman baru(sebelum/setelah) sudah tampil >50% meskipun masih proses swipe)
                print("Page changed to: \(newIndex)")
            }
            
            VStack() {
                #if !os(watchOS)
                    HStack{
                        HStack{
                            Spacer()
                            Button{ dismiss() }label:{}
                                .buttonStyle(
                                    ButtonStyleSimple(Color("red"),Color("pink"),27,Color.reversePrimary,iconName:"xmark")
                                )
                            Spacer()
                        }
                        Spacer().frame(maxWidth: isDynamicIslandDevice() ? 90 : 0)
                        HStack{
                            Spacer()
                            let locationFractureName = locationFractures.name()
                            Text(locationFractureName)
                                .font(locationFractureName.contains("\n") ? .subheadline : .title2)
                                .multilineTextAlignment(.center)
                                .bold(true)
                                .foregroundColor(Color("red"))
                            Spacer()
                        }
                    }
                    .padding(.top,8)//supaya ditengah dynami  island secara horixontal
                    .dynamicTypeSize(.xSmall ... .large)
                #endif
                
                MultiPoint_ProgressBar(MultiPointProgressBar_Type.line,UInt8(listProcedure.count), $currentStep)
                    .overlay(GeometryReader { geometry in
                        Color.clear
                            .preference(key: HeightPreferenceKey.self, value: geometry.size.height)
                    })
                    #if os(watchOS)
                        .padding(.horizontal,30)
                    #endif
                    .padding(.top,paddingTopProgressBar())
                
                #if os(watchOS)
                    HStack{
                        Button{ dismiss() }label:{}
                            .buttonStyle(
                                ButtonStyleSimple(Color("red"),Color("pink"),27,Color.reversePrimary,iconName:"xmark")
                            )
                            .padding(.top,-2)
                            .padding(.leading,20)
                        Spacer()
                        callEkaHospital_Button()
                            .padding(.trailing,10)
                    }
                #endif
                
                
                Spacer()
                
//                TabView(selection: $currentStep){
//                    ForEach(1...listProcedure.count, id: \.self) { stepTo in
//                        ProcedureFractureStepViewHolder(
//                            locationFractures,
//                            UInt8(stepTo),
//                            $neverHighlightedGestureTutorial
//                        ).tag(UInt8(stepTo))
//                    }
//                }
//                .tabViewStyle(.page(indexDisplayMode: .never))//settingan tabview agar bisa hilangkan dot white index penanda posisi
//                .onChange(of: currentStep) { newIndex in
//                    //mendeteksi jika halaman baru(sebelum/setelah) sudah tampil >50% meskipun masih proses swipe)
//                    print("Page changed to: \(newIndex)")
//                }
//                Spacer()
                #if !os(watchOS)
                    HStack{
                        callEkaHospital_Button()
                            .overlay(GeometryReader { geometry in
                                Color.clear
                                    .preference(key: HeightPreferenceKey.self, value: geometry.size.height)
                            })
                        Button{showSheetTools=true}label:{}
                            .buttonStyle(ButtonStyleSimple(Color("blue"),Color("white"),27,Color.reversePrimary,iconName:"cross.case"))
                            .dynamicTypeSize(.xSmall ... .xxxLarge)
                    }.padding(.bottom, 13)
                #endif
            }
            .ignoresSafeArea(.all)
            #if !os(watchOS)
                .statusBarHidden(true)
            #endif
            .navigationBarBackButtonHidden(true)
            
        }
        .background(Color("pink"))
        .sheet(isPresented: $showSheetTools) {
            ToolsInformation_Screen{close_request in showSheetTools=false}
                .presentationDetents([ .fraction(0.9997)]) // Optional, makes sheet small like a dialog
        }
        .onAppear {
            speak("Membuka Prosedur Patah Tulang \(locationFractures.name())")
        }
        #if os(watchOS) //harusnya ada if ios maka terima handgesture dari watchos
            .onChange(of: handGesture_Manager.handGesture) { handGesture in if let handGesture = handGesture {handGestureDetected(handGesture)}}
        #endif
    }
}

struct ProcedureFractureStepViewHolder: View {
    private let totalStep: UInt8
    private let locationFractures: LocationFractures
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
            }
            VStack{
                Spacer()
                Text(stepProcedureFractures.description())
                    #if os(watchOS)
                        .foregroundColor(.black)
                    #endif
                    .frame(maxWidth: .infinity, alignment: .center)
                    .fixedSize(horizontal: false, vertical: true) // wrap content vertically
                    .clipped()
                    .multilineTextAlignment(.center)
                    .dynamicTypeSize(.xSmall ... .accessibility2)
                    .background(Color.gray.opacity(0.3))
                    #if !os(watchOS)
                        .padding(.bottom,75)
                    #endif
            }
            HStack{
                Text("⟪⟪")
                    .font(.title)
                    .padding(.leading, 5)
                    .opacity(onVisibleHintGestureLeft ? 1 : 0)
                Spacer()
                Text("⟫⟫")
                    .font(.title)
                    .frame(width:(screenSize().width/2),height: screenSize().height,alignment: .trailing)
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
                    
            }
        }
        .background(Color.clear)
    }
}

#Preview {ProcedureFractureStep_Screen(LocationFractures.jari).environmentObject(HandGesture_Manager())}
