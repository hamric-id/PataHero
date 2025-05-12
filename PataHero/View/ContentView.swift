//  ContentView.swift
//  Patahero

import SwiftUI
import AVKit
import AVFoundation
import WatchConnectivity

struct ContentView: View {
    @State private var procedureScreen_NavigationPath = NavigationPath() //mencatat jalur halaman
    private let listDataPreviewFracture = LocationFractures.allCases.map{DataPreviewFractures($0)}
    @State private var searchKeyword = ""
    private var filteredListDataPreviewFracture: [DataPreviewFractures] { //item terfilter dari search dan filter
        listDataPreviewFracture.filter { dataPreviewFracture in
            (searchKeyword.isEmpty || dataPreviewFracture.locationFractures.name().lowercased().contains(searchKeyword.lowercased()))
        }
    }
    @State private var selected_LocationFractures:LocationFractures? = nil{
        didSet {
            if let selected_LocationFractures=selected_LocationFractures{speak(selected_LocationFractures.name())}
      
        }
    }
    
    private func speak(_ text:String){TextToSpeech_Manager.Manager.speak(text)}
    
    
    
    init(){
        let appearance = UINavigationBarAppearance()

        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.red, .font: UIFont.systemFont(ofSize: 34, weight: .bold)]
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.label ,
            .font: UIFont.systemFont(ofSize: 20, weight: .semibold)
        ]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some View { //choose your action/halaman awal
        NavigationStack(path: $procedureScreen_NavigationPath) {
            if listDataPreviewFracture.count<6 {
                VStack{
                    Text("PataHero")
                        .font(.largeTitle)
                        .bold(true)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color.yellow)
                        .shadow(color: .black, radius: 0.8, x: 0.8, y: 0.8)
                        .padding(.top,40)
                    Text("Your Mistake Make Me Useful")
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .bold(true)
                        .foregroundColor(Color("red"))//.shadow(color: .black, radius: 0.5, x: 0.5, y: 0.5)
                    Spacer()
                    
                    Text("Silakan Pilih\nProsedur Pertolongan Pertama\nPatah Tulang")
                        .font(.title2)
                        .bold()
                        .multilineTextAlignment(.center)
                        .foregroundColor(.reversePrimary)
                        .padding(.bottom, 20)
                    
                    ForEach(filteredListDataPreviewFracture){
                        
                        ProcedureFractures_Button($0, $selected_LocationFractures){locationFractures in print("\(locationFractures) tertekan")
                            procedureScreen_NavigationPath.append(locationFractures)
                        }
                        Spacer()
                    }
                    
                    callEkaHospital_Button(true)
                        .padding(.horizontal)
                        .padding(.bottom, 13)
                }
                .background(Color("pink"))
                .frame(maxWidth:.infinity, maxHeight:.infinity)
                .ignoresSafeArea(.container, edges: .bottom)
                .navigationDestination(for: LocationFractures.self) {locationFractures in
                    ProcedureFractureStep_Screen(locationFractures) //harusnya matikan gesture back (swipe dari kiri) tapi kayanya tidak perlu karena didalam ProcedureFractureStep_Screen sudah ada gesture halaman (ketindih)
                }
            }else{
                NavigationView{//dihapus karena jelek jika item cuma 3
                    ZStack{
                        VStack {
                            List(filteredListDataPreviewFracture) {dataPreviewFractures in
                                ProcedureFractures_Button(dataPreviewFractures, $selected_LocationFractures){locationFractures in//print("\(locationFractures) tertekan")
                                    procedureScreen_NavigationPath.append(locationFractures)
                                }
                                .listRowBackground(Color.clear) //mengatur background list transparan, karena defaultnya viewholdernya kotak, tidak bisa radius
                                .listRowSeparator(.hidden)//mengatur garis pemisah antar item wrana transparan
                            }
                            .background(Color("pink"))
                            .scrollContentBackground(.hidden) //
                            .onAppear {
                                UITableView.appearance().separatorStyle = .none
                                UITableView.appearance().showsVerticalScrollIndicator = false
                            }
                        }
                        .searchable(text: $searchKeyword, prompt: "Cari Prosedur Patah Tulang")
                        .navigationTitle("Prosedur Patah Tulang")
                        .navigationBarTitleDisplayMode(.inline)
                        HStack{
                            Spacer()
                            VStack{
                                Spacer()
                                callEkaHospital_Button()
                                    .padding(.trailing, 5)
                            }.padding(.bottom, 5)
                        }
                    }
                }
                .background(Color("pink"))
                .ignoresSafeArea(.container, edges: .bottom)
                .navigationDestination(for: LocationFractures.self) {locationFractures in
                    ProcedureFractureStep_Screen(locationFractures) //harusnya matikan gesture back (swipe dari kiri) tapi kayanya tidak perlu karena didalam ProcedureFractureStep_Screen sudah ada gesture halaman (ketindih)
                }
            }
        }
    }
}


#Preview {ContentView()}

//let adalah val, var adalah var
//array.map { $0 * $0 } $0 adalah it
//        array.forEach { (index, fruit) in} //foreachindexed

//        let fruitPrices = ["Apple": 2, "Banana": 1, "Cherry": 3] deklarasi map. jika ingin mutablemap ubah let jadi var saja
//        removeValue(forKey: "Banana")
//        removeAll()
//Uint8,Int8,ushort,Int16,Int,UInt,ULONG,Int64


//        var set = Set<T>() mutable set /jika ingin imuttable pakai let
//        insert(value)
//        remove(value)
//        contains(value)
//        count //seperti size di kotlin
//        union(set2)//menggabungkan 2 set
//        intersection(set2)//mencari elemen yang sama diantara 2 set
//        subtracting(set2) //mencari elemen yang berbeda di set2


        
//        array.enumerated().forEach { (index, fruit) in} //foreachindexed

//        print("\(index): \(fruit)") seperti $variabel, kalau di swift jadi\(variabel)

//        var numbers: [Int] = []  //deklarasi array kosong. jika ingin statis pakai let, dinamis pakai var
//        var list = [T]() array dinamis kosong
//        var fruits = ["Apple", "Banana", "Cherry"] //deklarasi array berisi

