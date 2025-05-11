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
    @EnvironmentObject var handGesture_Manager: HandGesture_Manager
    @State private var procedureScreen_NavigationPath = NavigationPath() //mencatat jalur halaman
    private let listDataPreviewFracture = LocationFractures.allCases.map{DataPreviewFractures($0)}
    @State private var selectedLocationFractures_Index: UInt8? = nil //index di listDataPreviewFracture
    
    
    func gesture(_ handGesture: HandGesture){
        switch handGesture {
            case .wrist_twist_in:
                if selectedLocationFractures_Index==nil { selectedLocationFractures_Index = 0
                }else if selectedLocationFractures_Index!+UInt8(1) > UInt8(listDataPreviewFracture.count-1) {
                    selectedLocationFractures_Index=0
                }else {selectedLocationFractures_Index!+=UInt8(1) }
            case .wrist_twist_out:
                if selectedLocationFractures_Index==nil || selectedLocationFractures_Index==0 {
                    selectedLocationFractures_Index = UInt8(listDataPreviewFracture.count-1)
                }else {selectedLocationFractures_Index!-=UInt8(1) }
            case .lower:
                    if let selectedLocationFractures_Index = selectedLocationFractures_Index {
                        procedureScreen_NavigationPath.append(listDataPreviewFracture[Int(selectedLocationFractures_Index)].locationFractures)
                    }
            default: break
        }
        
        if let selectedLocationFractures_Index = selectedLocationFractures_Index {
            WatchSpeechManager.shared.speak(String(describing:listDataPreviewFracture[Int(selectedLocationFractures_Index)].fractureName()))
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
                        
                        List(listDataPreviewFracture) {dataPreviewFractures in
                            ProcedureFractures_Button(dataPreviewFractures){locationFractures in//print("\(locationFractures) tertekan")
                                procedureScreen_NavigationPath.append(locationFractures)
                            }
                            .padding(.vertical, -1)
                            .padding(.horizontal, -12)
                            .listRowBackground(Color.clear) //mengatur background list transparan, karena defaultnya viewholdernya kotak, tidak bisa radius
                            #if !os(watchOS)
                                .listRowSeparator(.hidden)//mengatur garis pemisah antar item wrana transparan
                            #endif
                        }
                        .background(Color("pink"))
                        .scrollContentBackground(.hidden) //
                        .gesture(DragGesture())
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
                ProcedureFractureStep_Screen(locationFractures) //harusnya matikan gesture back (swipe dari kiri) tapi kayanya tidak perlu karena didalam ProcedureFractureStep_Screen sudah ada gesture halaman (ketindih)
            }
            .onAppear {WatchSpeechManager.shared.speak("Putar Pergelangan untuk memilih Prosedur")}
//            .onChange(of: handGesture_Manager.handGesture) { newGesture in
//                if let gesture1 = newGesture {
//                    gesture(gesture1)
//                }
//            }
        }
    }
}

#Preview {ContentView().environmentObject(HandGesture_Manager())}
