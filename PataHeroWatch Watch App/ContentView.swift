//
//  ContentView.swift
//  PataHeroWatch Watch App
//
//  Created by Muhammad Hamzah Robbani on 05/05/25.
//

import SwiftUI
import AVKit
import AVFoundation
import WatchConnectivity

//entah kenapa error preview
//PataHeroWatch Watch App crashed due to missing environment of type: HandGesture_Manager. To resolve this add `.environmentObject(HandGesture_Manager(...))` to the appropriate preview.
struct ContentView: View {
    @EnvironmentObject private var handGesture_Manager: HandGesture_Manager
    @State private var procedureScreen_NavigationPath = NavigationPath() //mencatat jalur halaman
    private let listDataPreviewFracture = LocationFractures.allCases.map{DataPreviewFractures($0)}
    @State private var selected_LocationFractures:LocationFractures? = nil{
        didSet {
            if let selected_LocationFractures=selected_LocationFractures{speak(selected_LocationFractures.name())}
        }
    }
    
    @State private var digitalCrown_Index: Float16 = 0
    
    private func selected_LocationFractures_Index()->Int?{
        listDataPreviewFracture.firstIndex(where: { $0.locationFractures == selected_LocationFractures })
    }
    
    private func select_Procedure_Button(_ action: Action_ChangePage) {
        func selected_Location_Fractures()->LocationFractures{
            // If current is nil or not found, just return first
            guard
    //            let current = current,
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
    }

    
    private func ProcedureScreen_Opened() -> Bool {if procedureScreen_NavigationPath.count>0{ true} else {false}}
    private func speak(_ text:String){TextToSpeech_Manager.Manager.speak(text)}
    
    private func handGestureDetected(_ handGesture: HandGesture){
        if !ProcedureScreen_Opened(){
            switch handGesture {
                case .wrist_twist_in: select_Procedure_Button(Action_ChangePage.next)
                case .wrist_twist_out: select_Procedure_Button(Action_ChangePage.previous)
                case .lower: if let selected_LocationFractures = selected_LocationFractures {procedureScreen_NavigationPath.append(selected_LocationFractures)}
                default: break
            }
        }
    }
    
    var body: some View { //choose your action/halaman awal
        NavigationStack(path: $procedureScreen_NavigationPath) {
            NavigationView{//dihapus karena jelek jika item cuma 3
                ZStack{
                    VStack {
                        HStack{
                            Text("Prosedur\nPertolongan\nPatah Tulang")
                                .font(.caption2)
                                .bold()
                                .multilineTextAlignment(.center)
                                .foregroundColor(.reversePrimary)
                            
                            callEkaHospital_Button()
                                .padding(.trailing,-30)
                                .padding(.top,10)
                        }
                        
//                        ScrollView { // Acts like a List, but doesn't grab the crown
                        ForEach(listDataPreviewFracture) {dataPreviewFractures in
                            ProcedureFractures_Button(dataPreviewFractures, $selected_LocationFractures){locationFractures in//print("\(locationFractures) tertekan")
                                procedureScreen_NavigationPath.append(locationFractures)
                            }
                        }
//                        }
//                        Text("Crown Value: \(digitalCrown_Index)")
                        
//                        List(listDataPreviewFracture) {dataPreviewFractures in
//                            ProcedureFractures_Button(dataPreviewFractures, $selected_LocationFractures){locationFractures in//print("\(locationFractures) tertekan")
//                                procedureScreen_NavigationPath.append(locationFractures)
//                            }
//                            .padding(.vertical, -1)
//                            .padding(.horizontal, -12)
//                            .listRowBackground(Color.clear) //mengatur background list transparan, karena defaultnya viewholdernya kotak, tidak bisa radius
//                            #if !os(watchOS)
//                                .listRowSeparator(.hidden)//mengatur garis pemisah antar item wrana transparan
//                            #endif
//                        }
//                        .background(Color("pink"))
//                        .scrollContentBackground(.hidden) //
//                        .gesture(DragGesture())
                        
                    }.ignoresSafeArea()//.all, edges: .all)
//                    .navigationTitle("Prosedur Patah Tulang")
//                    .navigationBarTitleDisplayMode(.inline)
                    if let handGesture = handGesture_Manager.handGesture {//untuk debug handgesture
                        Text(String(describing: handGesture))
                            .font(.title2)
                            .foregroundColor(.green)
                            .transition(.opacity)
                    } else {
                        Text("Waiting...")
                            .font(.body)
                            .foregroundColor(.gray)
                    }
                }
            }
            .background(Color("pink"))
            .ignoresSafeArea()//.all, edges: .bottom)
            .navigationDestination(for: LocationFractures.self) {locationFractures in
                ProcedureFractureStep_Screen(locationFractures)
                    .environmentObject(handGesture_Manager)//harusnya matikan gesture back (swipe dari kiri) tapi kayanya tidak perlu karena didalam ProcedureFractureStep_Screen sudah ada gesture halaman (ketindih)
            }
            .onAppear {
                var openerSpeak="putar pergelangan untuk memilih prosedur"
                if let selected_LocationFractures = selected_LocationFractures{
                    openerSpeak += ", pilihan sekarang adalah prosedur \(selected_LocationFractures)"
                }
                speak(openerSpeak)
            }
            .onChange(of: handGesture_Manager.handGesture) { handGesture in if let handGesture = handGesture {handGestureDetected(handGesture)}}
            .onChange(of: digitalCrown_Index) {//digitalCrown_Index in
//                print("hehe \($0)")
                var digitalCrown_IndexInt=Int($0.rounded())
                var digitalCrown_RawIndex = digitalCrown_IndexInt//(listDataPreviewFracture.count - 1) - digitalCrown_IndexInt //dibali karena arah direction crown kebalik
                if digitalCrown_RawIndex != selected_LocationFractures_Index() {
//                    if digitalCrown_RawIndex == -1 {digitalCrown_Index=2 //bikin berat
//                    }else if digitalCrown_RawIndex == 3 { digitalCrown_Index = 0
//                    }else{
                        print("crown berubah \(digitalCrown_Index)"); selected_LocationFractures = listDataPreviewFracture[digitalCrown_IndexInt].locationFractures
//                    }
                }
            }
            .focusable(true)
            .digitalCrownRotation($digitalCrown_Index,
                from:  0,//-1,
                through: Float16(listDataPreviewFracture.count-1), //),
                by: 1,
                sensitivity: .medium,
                isHapticFeedbackEnabled: true
                                
            )
//            .animation(.easeInOut, value: digitalCrown_Index)
        }
    }
}

#Preview {ContentView().environmentObject(HandGesture_Manager())}
