//  ContentView.swift
//  Patahero

import SwiftUI
#if os(watchOS)
import WatchConnectivity
#endif

extension Double {
    var radians: Double { return self * .pi / 180 }
    var degrees: Double { return self * 180 / .pi }
}

//entah kenapa error preview
//PataHeroWatch Watch App crashed due to missing environment of type: HandGesture_Manager. To resolve this add `.environmentObject(HandGesture_Manager(...))` to the appropriate preview.
struct ContentView: View {
    #if os(watchOS)
    @EnvironmentObject private var handGesture_Manager: HandGesture_Manager
    @EnvironmentObject private var IOSCommunication_Manager: iOSCommunication_Manager
    @State private var digitalCrown_Index: Float16 = 0
    
    private func controliOSApp(handGesture:HandGesture?=nil, digitalCrownRotate: DigitalCrownRotate?=nil, voice:String?=nil, screenType:ScreenType=ScreenType.Main){
        if !ProcedureScreen_Opened(){
            IOSCommunication_Manager.send(
                screenType,
                screenType==ScreenType.Main ?
                    ["selected_LocationFractures":selected_LocationFractures?.rawValue ?? "","showSheetHospitalInformation":showSheetHospitalInformation]:
                    ["LocationFractures":selected_LocationFractures!.rawValue],
                handGesture:handGesture,
                digitalCrownRotate:digitalCrownRotate
            )
        }
    }
 
    private func handGestureDetected(_ HandGesture: HandGesture?){
        if !ProcedureScreen_Opened(){
            func showDetectedHandGesture(_ screenType:ScreenType = ScreenType.Main){
                handGestureDetected = HandGesture
                #if os(watchOS)
                if let HandGesture = HandGesture {controliOSApp(handGesture: HandGesture,screenType: screenType)}
                #endif
            }
            
            func select_Procedure_Button(_ action: Action_ChangePage) {
                func selected_Location_Fractures()->LocationFractures{
                    guard
                        let currentIndex = listDataPreviewFracture.firstIndex(where: { $0.locationFractures == selected_LocationFractures })
                    else {return listDataPreviewFracture.first!.locationFractures}

                    switch action {
                        case .next:
                            let nextIndex = currentIndex + 1
                            return nextIndex < listDataPreviewFracture.count
                                ? listDataPreviewFracture[nextIndex].locationFractures
                                : listDataPreviewFracture.first!.locationFractures
                        case .previous:
                            let prevIndex = currentIndex - 1
                            return prevIndex >= 0
                                ? listDataPreviewFracture[prevIndex].locationFractures
                                : listDataPreviewFracture.last!.locationFractures
                    }
                }
                selected_LocationFractures=selected_Location_Fractures()
                if let selected_LocationFractures=selected_LocationFractures{textToSpeech_Manager.speak(selected_LocationFractures.name())}
            }
            
            if HandGesture == .wrist_twist_in || HandGesture == .close_to_chest {
                select_Procedure_Button(Action_ChangePage.next)
                showDetectedHandGesture()
            }else if HandGesture == .wrist_twist_out || HandGesture == .away_from_chest {
                select_Procedure_Button(Action_ChangePage.previous)
                showDetectedHandGesture()
            }else{
                switch HandGesture {
                    case .lower:
                        if let selected_LocationFractures = selected_LocationFractures {
                            showDetectedHandGesture( .Procedure )
                            procedureScreen_NavigationPath.append(ProcedureFractureStep_Screen_Data(selected_LocationFractures,true))
                        }
                    case nil:showDetectedHandGesture()
                    default: break
                }
            }
        }
    }
    #elseif os(iOS)
    @EnvironmentObject private var watchOSCommunication_Manager: WatchOSCommunication_Manager
    #endif
//    @EnvironmentObject private var speechToText_Manager: SpeechToText_Manager
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject private var textToSpeech_Manager: TextToSpeech_Manager
    @State private var procedureScreen_NavigationPath = NavigationPath() //mencatat jalur halaman
    private let listDataPreviewFracture = LocationFractures.allCases.map{DataPreviewFractures($0)}
    @State private var showSheetHospitalInformation=false
    @State private var selected_LocationFractures:LocationFractures? = nil
    @State private var handGestureDetected: HandGesture?
    @State private var voice: String?
//    @State private var controlFromOutside=false
    
    private func selected_LocationFractures_Index()->Int?{
        listDataPreviewFracture.firstIndex(where: { $0.locationFractures == selected_LocationFractures })
    }
    
    struct ProcedureFractureStep_Screen_Data: Hashable, Codable {
        let locationFractures:LocationFractures
        let openedByGesture:Bool
        
        init(_ locationFractures:LocationFractures, _ openedByGesture:Bool=false){
            self.locationFractures = locationFractures
            self.openedByGesture = openedByGesture
        }
    }

    private func ProcedureScreen_Opened() -> Bool {if procedureScreen_NavigationPath.count>0{ true} else {false}}
  
    //dicontrol dari iOS atau applewatch
    private func TakeOverControl(_ ScreenInformation:ScreenInformation){
        if !ProcedureScreen_Opened(){
            switch ScreenInformation.ScreenType {
                case .Main:
                    if let selected_LocationFractures = ScreenInformation.otherInformation?["selected_LocationFractures"] as? LocationFractures{
                        //harusnya deteksi apakah handgesture dan speak sekarang bukan selected, jika iya maka speak
                        print("hola11 \(selected_LocationFractures)")
                        self.selected_LocationFractures = selected_LocationFractures
                    }else {self.selected_LocationFractures = nil}
                    if let showSheetHospitalInformation = ScreenInformation.otherInformation?["showSheetHospitalInformation"] as? Bool{
                        //harusnya deteksi apakah handgesture dan speak sekarang bukan selected, jika iya maka speak
                        self.showSheetHospitalInformation = showSheetHospitalInformation
                    }
                case .Procedure:
                    if let LocationFractures = ScreenInformation.otherInformation?["LocationFractures"] as? LocationFractures{
                        //harusnya deteksi apakah handgesture dan speak sekarang bukan selected, jika iya maka speak
                        self.selected_LocationFractures = LocationFractures
                        procedureScreen_NavigationPath = NavigationPath()
                        procedureScreen_NavigationPath.append(ProcedureFractureStep_Screen_Data(LocationFractures))
                    }
                    
                default: break
            }
        }
    }
    
    
    var body: some View { //choose your action/halaman awal
        NavigationStack(path: $procedureScreen_NavigationPath) {
            NavigationView{//dihapus karena jelek jika item cuma 3
                ZStack{
                    #if os(watchOS)
                    VStack {
                        HStack{
                            Text("Prosedur\nPertolongan\nPatah Tulang")
                                .font(.caption2)
                                .bold()
                                .multilineTextAlignment(.center)
                                .foregroundColor(.reversePrimary)
                                .padding(.leading,20)
                            Spacer()
//                            ClosestHospital_Button{onClick in //    callEkaHospital_Button()
//                                showSheetHospitalInformation=true
//                            }
//                            .padding(.top,10)
//                            Spacer()
                        }

                        ForEach(listDataPreviewFracture) {dataPreviewFractures in
                            ProcedureFractures_Button(dataPreviewFractures, $selected_LocationFractures){locationFractures in//print("\(locationFractures) tertekan")
                                textToSpeech_Manager.stop()
                                controliOSApp(screenType: .Procedure)
                                procedureScreen_NavigationPath.append(ProcedureFractureStep_Screen_Data(locationFractures))
                            }
                        }

                    }.ignoresSafeArea()//.all, edges: .all)
                    #else
                    VStack{
                        Text("PataHero")
                            .font(.largeTitle)
                            .bold(true)
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color.yellow)
                            .shadow(color: .black, radius: 0.8, x: 0.8, y: 0.8)
//                            .padding(.top,40)
                        Text("Your Mistake Make Me Useful")
                            .font(.subheadline)
                            .multilineTextAlignment(.center)
                            .bold(true)
                            .foregroundColor(Color("red"))//.shadow(color: .black, radius: 0.5, x: 0.5, y: 0.5)
                        
                        Spacer(minLength: 70)

                        Text("Silakan Pilih\nProsedur Pertolongan Pertama\nPatah Tulang")
                            .font(.callout)
                            .bold()
                            .multilineTextAlignment(.center)
                            .foregroundColor(.reversePrimary)
                            .shadow(color: .black, radius: 0.8, x: 0.8, y: 0.8)
                            .padding(.bottom, 20)
                        
                        Spacer(minLength: 70)

                        ForEach(listDataPreviewFracture){

                            ProcedureFractures_Button($0, $selected_LocationFractures){locationFractures in print("\(locationFractures) tertekan")
                                
                                procedureScreen_NavigationPath.append(ProcedureFractureStep_Screen_Data(locationFractures))
                            }
                            Spacer()
                        }
                        .frame(maxWidth:.infinity, maxHeight:.infinity)
//                        .navigationDestination(for: LocationFractures.self) {locationFractures in
//                            ProcedureFractureStep_Screen(locationFractures) //harusnya matikan gesture back (swipe dari kiri) tapi kayanya tidak perlu karena didalam ProcedureFractureStep_Screen sudah ada gesture halaman (ketindih)
//                        }
                    }
                    
                    VStack{
                        Spacer()
                        
                        ClosestHospital_Button{ a in
                            showSheetHospitalInformation = true
                        }
                    }.ignoresSafeArea()
                    #endif
                    
      
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
                    
                    
//                    VStack{
//                        Spacer()
//                        if let voice = voice{
//                            Text("🗣️ \(voice)")
//                                .font(.title.bold())
//                                .foregroundColor(.green)
//                                .shadow(color: .black, radius: 1)
//                                .background(Color.gray.opacity(0.8))
//                                .frame(maxWidth:.infinity)
//                                .multilineTextAlignment(.center)
//                                .ignoresSafeArea()
//                        }
//                        
//                        #if os(iOS)
//                        if watchOSCommunication_Manager.digitalCrownRotate == .down{
//                            Text("⇊")
//                                .font(.title.bold())
//                                .frame(maxWidth:.infinity)
//                                .multilineTextAlignment(.center)
//                                .background(Color.green.opacity(0.4))
//                                .ignoresSafeArea()
//                        }
//                        #endif
//                    }
//                    
                }.background(Color("pink"))
            }
            #if os(watchOS)
            .ignoresSafeArea()//.all, edges: .bottom)
            .onChange(of: handGesture_Manager.handGesture) { handGestureDetected($0) }
            .onChange(of: digitalCrown_Index) {
                
                func changeSelected_LocationFractures(_ selected_LocationFractures : LocationFractures, _ digitalCrownRotate: DigitalCrownRotate){
                    self.selected_LocationFractures = selected_LocationFractures
                    controliOSApp(digitalCrownRotate: digitalCrownRotate)
                    textToSpeech_Manager.stop()
                }
                
                if let selected_LocationFractures_Index = selected_LocationFractures_Index(){
                    var digitalCrown_IndexInt=Int($0.rounded())
                    var digitalCrown_RawIndex = digitalCrown_IndexInt//(listDataPreviewFracture.count - 1) - digitalCrown_IndexInt //dibali karena arah direction crown kebalik
        
                    if digitalCrown_RawIndex != selected_LocationFractures_Index {
    //                    if digitalCrown_RawIndex == -1 {digitalCrown_Index=2 //bikin berat
    //                    }else if digitalCrown_RawIndex == 3 { digitalCrown_Index = 0
    //                    }else{
//                            print("crown berubah \(digitalCrown_Index)")
//                            selected_LocationFractures = listDataPreviewFracture[digitalCrown_IndexInt].locationFractures
//                            controliOSApp(digitalCrownRotate: digitalCrown_RawIndex > selected_LocationFractures_Index ? .up : .down )
//                            textToSpeech_Manager.stop()
                        changeSelected_LocationFractures(listDataPreviewFracture[digitalCrown_IndexInt].locationFractures,digitalCrown_RawIndex > selected_LocationFractures_Index ? .down : .up )
    //                    }
                    }
                }else{ changeSelected_LocationFractures( listDataPreviewFracture.first!.locationFractures, DigitalCrownRotate.down )}
            }
            .focusable(true)
            .digitalCrownRotation($digitalCrown_Index,
                from:  0,//-1,
                through: Float16(listDataPreviewFracture.count-1), //),
                by: 1,
                sensitivity: .low,
                isHapticFeedbackEnabled: true
            )
            #else //os(iOS)
                .onChange(of: watchOSCommunication_Manager.handGesture) { handGestureDetected = $0 }
                .onChange(of: watchOSCommunication_Manager.voice){voice = $0}
                .onReceive(watchOSCommunication_Manager.$screenInformation){ TakeOverControl($0) }
            #endif
    
            #if !os(watchOS)
            .ignoresSafeArea(.all)//.container, edges: .bottom)
            #endif
            .sheet(isPresented: $showSheetHospitalInformation) {
                #if os(watchOS)
                OpenAppleMapsView()
                #else
                Closest_Hospital_Screen{close_request in showSheetHospitalInformation=false}
                    .presentationDetents([ .fraction(0.9997)]) // Optional, makes sheet small like a dialog
                #endif
            }
            .navigationDestination(for: ProcedureFractureStep_Screen_Data.self) {//procedureFractureStep_Screen_Data in
                ProcedureFractureStep_Screen($0.locationFractures,$0.openedByGesture)
                    .environmentObject(textToSpeech_Manager)
                    #if os(watchOS)
                    .environmentObject(handGesture_Manager)//harusnya matikan gesture back (swipe dari kiri) tapi kayanya tidak perlu karena didalam ProcedureFractureStep_Screen sudah ada gesture halaman (ketindih)
                    .environmentObject(IOSCommunication_Manager)
                    #endif
                
            }
            .onChange(of:selected_LocationFractures){ print("slectedberubah \($0)") }
            .onAppear {
                #if os(watchOS) //harusnya deteksi jika watch terkoneksi atau tidak
                WKExtension.shared().isFrontmostTimeoutExtended = true
                var openerSpeak="putar pergelangan untuk memilih prosedur"
                if let selected_LocationFractures = selected_LocationFractures{
                    openerSpeak += ", pilihan sekarang adalah prosedur \(selected_LocationFractures)"
                }
                textToSpeech_Manager.speak(openerSpeak)
                #elseif os(iOS)
                if let selected_LocationFractures = watchOSCommunication_Manager.screenInformation.otherInformation?["selected_LocationFractures"] as? LocationFractures{
                    self.selected_LocationFractures = selected_LocationFractures
                }
                #endif
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(TextToSpeech_Manager())
        #if os(watchOS)
        .environmentObject(HandGesture_Manager())
        .environmentObject(iOSCommunication_Manager())
        #elseif os(iOS)
        .environmentObject(WatchOSCommunication_Manager())
        #endif
}


//struct ContentView: View {
//    @AppStorage(LocalDataKey.Shortcut_ScreenRequest.name()) private var Shortcut_ScreenRequest: String?//var screen_request: String? = nil
//    @EnvironmentObject private var watchOSCommunication_Manager: WatchOSCommunication_Manager
//    @State private var procedureScreen_NavigationPath = NavigationPath() //mencatat jalur halaman
//    @StateObject private var location_Manager = Location_Manager()
//    @StateObject private var compass_ViewModel = Compass_ViewModel(CLLocation(latitude: -6.3021974708496575, longitude: 106.65243794569247))
//    private let listDataPreviewFracture = LocationFractures.allCases.map{DataPreviewFractures($0)}
//    @State private var searchKeyword = ""
//    private var filteredListDataPreviewFracture: [DataPreviewFractures] { //item terfilter dari search dan filter
//        listDataPreviewFracture.filter { dataPreviewFracture in
//            (searchKeyword.isEmpty || dataPreviewFracture.locationFractures.name().lowercased().contains(searchKeyword.lowercased()))
//        }
//    }
//    @State private var showSheetTools = false//true
//    @State private var selected_LocationFractures:LocationFractures? = nil
//    private let firstAIDkitTools_Location = CLLocation(coordinate: CLLocationCoordinate2D(latitude: -6.3021974708496575, longitude: 106.65243794569247), altitude: 48.29708020952224, horizontalAccuracy: 5.0, verticalAccuracy: 5.0, timestamp: Date())
//    
//    init(){
//        let appearance = UINavigationBarAppearance()
//
//        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.red, .font: UIFont.systemFont(ofSize: 34, weight: .bold)]
//        appearance.titleTextAttributes = [
//            .foregroundColor: UIColor.label ,
//            .font: UIFont.systemFont(ofSize: 20, weight: .semibold)
//        ]
//        
//        UINavigationBar.appearance().standardAppearance = appearance
//        UINavigationBar.appearance().scrollEdgeAppearance = appearance
//        print("coba11 \(Shortcut_ScreenRequest)")
//    }
//
//    var body: some View { //choose your action/halaman awal
//        NavigationStack(path: $procedureScreen_NavigationPath) {
//            if listDataPreviewFracture.count<6 {
//                ZStack{
//                    VStack{
//                        Text("PataHero")
//                            .font(.largeTitle)
//                            .bold(true)
//                            .multilineTextAlignment(.center)
//                            .foregroundColor(Color.yellow)
//                            .shadow(color: .black, radius: 0.8, x: 0.8, y: 0.8)
//                            .padding(.top,40)
//                        Text("Your Mistake Make Me Useful")
//                            .font(.subheadline)
//                            .multilineTextAlignment(.center)
//                            .bold(true)
//                            .foregroundColor(Color("red"))//.shadow(color: .black, radius: 0.5, x: 0.5, y: 0.5)
//                        Spacer()
//                        
//                        Text("Silakan Pilih\nProsedur Pertolongan Pertama\nPatah Tulang")
//                            .font(.title2)
//                            .bold()
//                            .multilineTextAlignment(.center)
//                            .foregroundColor(.reversePrimary)
//                            .padding(.bottom, 20)
//                        
//                        ForEach(filteredListDataPreviewFracture){
//                            
//                            ProcedureFractures_Button($0, $selected_LocationFractures){locationFractures in print("\(locationFractures) tertekan")
//                                procedureScreen_NavigationPath.append(locationFractures)
//                            }
//                            Spacer()
//                        }
//                        
////                        callEkaHospital_Button(true)
////                            .padding(.horizontal)
////                            .padding(.bottom, 13)
//                        
//                    }
//                    .frame(maxWidth:.infinity, maxHeight:.infinity)
//                    .background(Color("pink"))
//                    .navigationDestination(for: LocationFractures.self) {locationFractures in
//                        ProcedureFractureStep_Screen(locationFractures) //harusnya matikan gesture back (swipe dari kiri) tapi kayanya tidak perlu karena didalam ProcedureFractureStep_Screen sudah ada gesture halaman (ketindih)
//                    }
//                    
//                    VStack{
//                        Spacer()
//                        HStack{
//                            callEkaHospital_Button()
//                                .padding(.trailing, 5)
//                            Button{showSheetTools=false}label:{}
//                                .buttonStyle(ButtonStyleSimple(Color("blue"),Color.white,27,Color.reversePrimary,iconName:"map"))
//                                .dynamicTypeSize(.xSmall ... .xxxLarge)
//                        }.padding(.bottom, 5)
//                    }
//                }
//                .ignoresSafeArea(.container, edges: .bottom)
//                .sheet(isPresented: $showSheetTools) {
//                    Closest_Hospital_Screen{close_request in showSheetTools=false}
//                        .presentationDetents([ .fraction(0.9997)]) // Optional, makes sheet small like a dialog
//                }
//                .onAppear{
//                    print("muncul00")
//                    print("muncul11 \(Shortcut_ScreenRequest)")
//                    if let Shortcut_ScreenRequest = Shortcut_ScreenRequest{
//                        print("muncul22 \(Shortcut_ScreenRequest)")
//                        let screen_request_data = Shortcut_ScreenRequest.components(separatedBy: ";")
//                        
//                        switch screen_request_data.first! {
//                            case "procedure":
//                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {//hidupkan setelah 3 detik
//                                    print("muncul33 \(screen_request_data[1].toLocationFractures())")
//                                    procedureScreen_NavigationPath.append(LocationFractures.lengan)//screen_request_data[1].toLocationFractures())
//                                    self.Shortcut_ScreenRequest = nil
//                                }
//                            default : AppCrash("there is no screen '\(screen_request_data.first)'")
//                        }
//                    }
//                    
//                    
//                }
//            }else{
//                NavigationView{//dihapus karena jelek jika item cuma 3
//                    ZStack{
//                        VStack {
//                            List(filteredListDataPreviewFracture) {dataPreviewFractures in
//                                ProcedureFractures_Button(dataPreviewFractures, $selected_LocationFractures){locationFractures in//print("\(locationFractures) tertekan")
//                                    procedureScreen_NavigationPath.append(locationFractures)
//                                }
//                                .listRowBackground(Color.clear) //mengatur background list transparan, karena defaultnya viewholdernya kotak, tidak bisa radius
//                                .listRowSeparator(.hidden)//mengatur garis pemisah antar item wrana transparan
//                            }
//                            .background(Color("pink"))
//                            .scrollContentBackground(.hidden) //
//                            .onAppear {
//                                UITableView.appearance().separatorStyle = .none
//                                UITableView.appearance().showsVerticalScrollIndicator = false
//                            }
//                        }
//                        .searchable(text: $searchKeyword, prompt: "Cari Prosedur Patah Tulang")
//                        .navigationTitle("Prosedur Patah Tulang")
//                        .navigationBarTitleDisplayMode(.inline)
//                        HStack{
//                            Spacer()
//                            VStack{
//                                Spacer()
//                                callEkaHospital_Button()
//                                    .padding(.trailing, 5)
//                                Button{}label:{}
//                                    .buttonStyle(ButtonStyleSimple(Color("blue"),Color("white"),27,Color.reversePrimary,iconName:"map"))
//                                    .dynamicTypeSize(.xSmall ... .xxxLarge)
//                            }.padding(.bottom, 5)
//                        }
//                    }
//                }
//                .background(Color("pink"))
//                .ignoresSafeArea(.container, edges: .bottom)
//                .navigationDestination(for: LocationFractures.self) {locationFractures in
//                    ProcedureFractureStep_Screen(locationFractures) //harusnya matikan gesture back (swipe dari kiri) tapi kayanya tidak perlu karena didalam ProcedureFractureStep_Screen sudah ada gesture halaman (ketindih)
//                }
//            }
//        }
//    }
//}
//
//
//#Preview {ContentView()}
//
////let adalah val, var adalah var
////array.map { $0 * $0 } $0 adalah it
////        array.forEach { (index, fruit) in} //foreachindexed
//
////        let fruitPrices = ["Apple": 2, "Banana": 1, "Cherry": 3] deklarasi map. jika ingin mutablemap ubah let jadi var saja
////        removeValue(forKey: "Banana")
////        removeAll()
////Uint8,Int8,ushort,Int16,Int,UInt,ULONG,Int64
//
//
////        var set = Set<T>() mutable set /jika ingin imuttable pakai let
////        insert(value)
////        remove(value)
////        contains(value)
////        count //seperti size di kotlin
////        union(set2)//menggabungkan 2 set
////        intersection(set2)//mencari elemen yang sama diantara 2 set
////        subtracting(set2) //mencari elemen yang berbeda di set2
//
//
//        
////        array.enumerated().forEach { (index, fruit) in} //foreachindexed
//
////        print("\(index): \(fruit)") seperti $variabel, kalau di swift jadi\(variabel)
//
////        var numbers: [Int] = []  //deklarasi array kosong. jika ingin statis pakai let, dinamis pakai var
////        var list = [T]() array dinamis kosong
////        var fruits = ["Apple", "Banana", "Cherry"] //deklarasi array berisi
//
