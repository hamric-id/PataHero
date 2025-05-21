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
    private let openByHandGesture: Bool
    @Environment(\.dismiss) private var dismiss//supaya bisa back navlink dengan tombol custom
    #if os(watchOS)
    @EnvironmentObject private var handGesture_Manager: HandGesture_Manager
    @EnvironmentObject private var IOSCommunication_Manager: iOSCommunication_Manager
    @State private var digitalCrown_Index: Float16 = 0
    
    private func controliOSApp(stepTo:UInt8?=nil,handGesture:HandGesture?=nil, digitalCrownRotate: DigitalCrownRotate?=nil, voice:String?=nil,screenType:ScreenType=ScreenType.Procedure){
        IOSCommunication_Manager.send(
            screenType,//==ScreenType.Procedure,
            screenType == ScreenType.Procedure ?
                ["LocationFractures": locationFractures.rawValue,"currentStep":Int(stepTo ?? currentStep),"showSheetHospitalInformation":showSheetHospitalInformation] :
                ["selected_LocationFractures": locationFractures.rawValue]
            ,
            handGesture:handGesture,
            digitalCrownRotate:digitalCrownRotate,
            voice:voice
        )
    }
    
    private func handGestureDetected(_ HandGesture: HandGesture?){
        func showDetectedHandGesture(stepTo:UInt8=currentStep, screenType: ScreenType = ScreenType.Procedure){
            handGestureDetected=HandGesture
            if let HandGesture = HandGesture {controliOSApp(stepTo:stepTo,handGesture:HandGesture,screenType: screenType)}
        }
        
        if HandGesture == .punch || HandGesture == .lower || HandGesture == .wrist_twist_in{
            if let stepTo = changeStepPage(Action_ChangePage.next){
                showDetectedHandGesture(stepTo:stepTo)
            }
        }else if HandGesture == .retract_punch || HandGesture == .wrist_twist_out{
            if let stepTo = changeStepPage(Action_ChangePage.previous){
                showDetectedHandGesture(stepTo:stepTo)
            }
        }else{
            switch HandGesture {
                case .raise:
                    showDetectedHandGesture(screenType: .Main)
                    closeProcedure(4)
                case nil: showDetectedHandGesture() //dimatikan karena biasanya stepto telat
                default: break
            }
        }
    }
    #elseif os(iOS)
    @EnvironmentObject private var watchOSCommunication_Manager: WatchOSCommunication_Manager
    
    private func controlWatchOSApp(voice:String?=nil){
//        IOSCommunication_Manager.send(
//            ScreenType.Procedure,
//            ["LocationFractures": locationFractures.rawValue,"stepTo":Int(currentStep),"showSheetHospitalInformation":showSheetHospitalInformation],
//            handGesture:handGesture,
//            digitalCrownRotate:digitalCrownRotate,
//            voice:voice
//        )
    }
    #endif
    
    private func closeProcedure(_ a:Int){
        print("menutup prosedur \(a)")
        textToSpeech_Manager.stop()
        dismiss()
    }
    
    //dicontrol dari iOS atau applewatch
    private func TakeOverControl(_ ScreenInformation:ScreenInformation){
        print("hola88 \(ScreenInformation.ScreenType)")
        switch ScreenInformation.ScreenType {
            case .Main: closeProcedure(1)
            case .Procedure:
                if let LocationFractures = ScreenInformation.otherInformation?["LocationFractures"] as? LocationFractures{
                    //harusnya deteksi apakah handgesture dan speak sekarang bukan selected, jika iya maka speak
                    if LocationFractures != self.locationFractures{
                        self.locationFractures = LocationFractures
                    }
                }
            
                if let currentStep = ScreenInformation.otherInformation?["currentStep"] as? Int{
                    //harusnya deteksi apakah handgesture dan speak sekarang bukan selected, jika iya maka speak
                    changeStepPage(UInt8(currentStep))
                }
            
            default: break
        }
    }
    

    @EnvironmentObject private var textToSpeech_Manager: TextToSpeech_Manager
    @State private var locationFractures: LocationFractures
    @State private var showSheetHospitalInformation = false
    @State private var voice: String?
    @State private var listProcedure: [StepProcedureFractures]
    @State private var handGestureDetected:HandGesture?
    @State var currentStep: UInt8=1{
        didSet {
            if currentStep<1 || currentStep>UInt8(listProcedure.count) {
                currentStep = min(max(currentStep, 1), UInt8(listProcedure.count))
            }
        }
    }//jika ingin ganti step langsung ubah
    @State private var currentStepProcessChangedNotBySwipe = false //supaya ga kekirim dobel indformasi screen ke ios, karena susah membedakan mana ganti steop karena handgesture, swipe, dan crown
    @State private var neverHighlightedGestureTutorial = true
    @State private var everReceiveScreenInformation=false //karena pakai onReceive, jadi tiapkali passing environmentobject selalu tertriger meskipun tidak berubah
    
    private func changeStepPage(_ action:Action_ChangePage)->UInt8?{
        var stepTo = currentStep
        
        if action == .next { stepTo+=1
        }else {if currentStep != 0 {stepTo-=1}}
        stepTo = min(max(stepTo, 1), UInt8(listProcedure.count))
        
        if stepTo != currentStep {
            DispatchQueue.main.async{//hidupkan setelah 3 detik
                withAnimation(.easeInOut){
                    self.currentStepProcessChangedNotBySwipe = true
                    currentStep = stepTo
                }
            }
            return stepTo
        }
        return nil
    }
    
    private func changeStepPage(_ stepTo:UInt8)->UInt8?{
        let stepTo = min(max(stepTo, 1), UInt8(listProcedure.count))
        
        if stepTo != currentStep {
            DispatchQueue.main.async{//hidupkan setelah 3 detik
                withAnimation(.easeInOut){
                    self.currentStepProcessChangedNotBySwipe = true
                    currentStep = stepTo
                }
            }
            return stepTo
        }
        return nil
    }
    

    init(_ locationFractures: LocationFractures, _ openByHandGesture:Bool = false,_ currentStep: UInt8 = 1) {//_ currentScreen: Binding<AppScreen> ,_ locationFractures: LocationFractures, _ currentStep: UInt8 = 1) {
        self.locationFractures = locationFractures
        self.currentStep = currentStep
        self.openByHandGesture = openByHandGesture
        listProcedure = locationFractures.listProcedure()
    }
    
    private func paddingTopProgressBar() -> CGFloat {
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
                    )
                    .tag(UInt8(stepTo))
                    .padding(.top,-26)
                    .environmentObject(textToSpeech_Manager)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))//settingan tabview agar bisa hilangkan dot white index penanda posisi
            #if os(watchOS)
            .focusable(true)
            .digitalCrownRotation($digitalCrown_Index,
                from:  1,//-1,
                through: Float16(listProcedure.count), //),
                by: 1,
                sensitivity: .low,
                isHapticFeedbackEnabled: true
            )
            #endif
            VStack() {
                #if !os(watchOS)
                    HStack{
                        HStack{
                            Spacer()
                            Button{ closeProcedure(2) }label:{}
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
                        Button{ controliOSApp(screenType:ScreenType.Main);closeProcedure(3) }label:{}
                            .buttonStyle(
                                ButtonStyleSimple(Color("red"),Color("pink"),27,Color.reversePrimary,iconName:"xmark")
                            )
                            .padding(.top,10)
                            .padding(.leading,20)
                        Spacer()
//                        callEkaHospital_Button()
//                            .padding(.trailing,10)
                    }
                #endif
                
                
                Spacer()

                #if !os(watchOS)
                ClosestHospital_Button{ a in
                    showSheetHospitalInformation = true
                }
                #endif
            }
            .ignoresSafeArea(.all)
            #if !os(watchOS)
                .statusBarHidden(true)
            #endif
            .navigationBarBackButtonHidden(true)
            
            VStack{
                if let HandGesture = handGestureDetected {
                    Text(HandGesture.name())
                        .font(.title2)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.green)
                        .shadow(color: .black, radius: 1)
                        .background(Color.gray.opacity(0.8))
                        .transition(.opacity)
                        #if os(watchOS)
                        .ignoresSafeArea(.all)
                        #endif
                }
                
                #if os(iOS)
                if watchOSCommunication_Manager.digitalCrownRotate == .up{
                    Text("⇈")
                        .font(.title.bold())
                        .frame(maxWidth:.infinity)
                        .multilineTextAlignment(.center)
                        .background(Color.green.opacity(0.4))
                }
                #endif
                
                Spacer()
                
                if let voice = voice{
                    Text("🗣️ \(voice)")
                        .font(.title.bold())
                        .foregroundColor(.green)
                        .shadow(color: .black, radius: 1)
                        .background(Color.gray.opacity(0.8))
                        .frame(maxWidth:.infinity)
                        .multilineTextAlignment(.center)
                        .ignoresSafeArea()
                }
                
                #if os(iOS)
                if watchOSCommunication_Manager.digitalCrownRotate == .down{
                    Text("⇊")
                        .font(.title.bold())
                        .frame(maxWidth:.infinity)
                        .multilineTextAlignment(.center)
                        .background(Color.green.opacity(0.4))
                        .ignoresSafeArea()
                }
                #endif
            }.frame(maxWidth: .infinity)
        }
        .background(Color("pink"))
        .sheet(isPresented: $showSheetHospitalInformation) {
            Closest_Hospital_Screen{close_request in showSheetHospitalInformation=false}
                .presentationDetents([ .fraction(0.9997)]) // Optional, makes sheet small like a dialog
        }
        .onAppear {
            #if os(watchOS)
            WKExtension.shared().isFrontmostTimeoutExtended = true
            #endif
            if openByHandGesture{textToSpeech_Manager.speak("Membuka Prosedur Patah Tulang \(locationFractures.name())") }
        }
        #if os(watchOS)
        .ignoresSafeArea()//.all, edges: .bottom)
        .onChange(of: handGesture_Manager.handGesture) { handGestureDetected($0) }
        .onChange(of: currentStep) {
            if currentStepProcessChangedNotBySwipe{ currentStepProcessChangedNotBySwipe=false
            }else {controliOSApp(stepTo: currentStep)}
        }
        .onChange(of: digitalCrown_Index) {
            var digitalCrown_Index = UInt8($0.rounded())//(listDataPreviewFracture.count - 1) - digitalCrown_IndexInt //dibali karena arah direction crown kebalik
            
            if let stepTo = changeStepPage(digitalCrown_Index){ //jika nil maka currentstep sudah sama tidak perlu dirubah
                controliOSApp(stepTo: stepTo,digitalCrownRotate: digitalCrown_Index > currentStep ? .down : .up )
            }

//            if digitalCrown_Index != currentStep {
//                changeStepPage(digitalCrown_Index)
//                controliOSApp(digitalCrownRotate: digitalCrown_Index > currentStep ? .down : .up )
//            }
        }
        #elseif os(iOS)
            .onChange(of: watchOSCommunication_Manager.handGesture) { handGestureDetected = $0 }
            .onChange(of: watchOSCommunication_Manager.voice){voice = $0}
            .onReceive(watchOSCommunication_Manager.$screenInformation){
                if !everReceiveScreenInformation{everReceiveScreenInformation=true  //karena pakai onReceive, jadi tiapkali passing environmentobject selalu tertriger meskipun tidak berubah
                }else{TakeOverControl($0)}
            }
        #endif
    }
}

struct ProcedureFractureStepViewHolder: View {
    @EnvironmentObject private var textToSpeech_Manager: TextToSpeech_Manager
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
                    #else
                        .foregroundColor(.primary)
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
                        textToSpeech_Manager.speak("step ke \(currentStep), \(stepProcedureFractures.description())")
//                            if $0==SpeakResult.finish{//masih ngebug
//                                highlightGestureTutorial(true)
//                                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {//matikan setelah 8 detik
//                                    highlightGestureTutorial(false)
//                                }
//                                if highlightGestureTutorial{
//                                    highlightGestureTutorial=false
//                                    highlightGestureTutorial(true)
//                                    DispatchQueue.main.asyncAfter(deadline: .now() + 12) {//matikan setelah 8 detik
//                                        highlightGestureTutorial(false)
//                                    }
//                                }else{ highlightGestureTutorial(false)} //karena rencananya nantyi di recycler
//                            }
                            
                        
                        if highlightGestureTutorial{
                            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {//hidupkan setelah 3 detik
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

#Preview {
    ProcedureFractureStep_Screen(LocationFractures.jari)
        .environmentObject(TextToSpeech_Manager())
    #if os(watchOS)
        .environmentObject(HandGesture_Manager())
        .environmentObject(iOSCommunication_Manager())
    #elseif os(iOS)
        .environmentObject(WatchOSCommunication_Manager())
    #endif
}
