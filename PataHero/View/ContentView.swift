//  ContentView.swift
//  Patahero

import SwiftUI
import AVKit
import AVFoundation

struct ContentView: View {
    @Binding private var currentScreen: AppScreen
    private let listDataPreviewFracture = LocationFractures.allCases.map{
        DataPreviewFractures($0)
    }
    
    init(_ currentScreen: Binding<AppScreen>){
        self._currentScreen = currentScreen
        
        let appearance = UINavigationBarAppearance()
//        appearance.configureWithOpaqueBackground() // Ensures solid color
//        appearance.backgroundColor = UIColor(Color("pink")) //agar backgtround searchbox dan titlebar pink
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.red, .font: UIFont.systemFont(ofSize: 34, weight: .bold)]
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.label ,
            .font: UIFont.systemFont(ofSize: 20, weight: .semibold)
        ]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
//    @State private var isTouching: Bool = false
    @State private var searchKeyword: String=""
    
    private var filteredListDataPreviewFracture: [DataPreviewFractures] { //item terfilter dari search dan filter
        listDataPreviewFracture.filter { dataPreviewFracture in
            (searchKeyword.isEmpty || dataPreviewFracture.fractureName().lowercased().contains(searchKeyword.lowercased()))
        }
    }

    var body: some View { //choose your action/halaman awal
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
                    .foregroundColor(Color("red"))
//                    .shadow(color: .black, radius: 0.5, x: 0.5, y: 0.5)
                Spacer()
                
                Text("Silakan Pilih\nProsedur Pertolongan Pertama\nPatah Tulang")
                    .font(.title2)
                    .bold()
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color("light_red"))
                    .shadow(color: .white, radius: 0.8, x: 0.8, y: 0.8)
                    .padding(.bottom, 20)
                
                ForEach(filteredListDataPreviewFracture){
                    
                    ProcedureFractures_Button($0){locationFractures in
                        locationFractures_ProcedureFracture_Screen = locationFractures
                    
                        currentScreen = .ProcedureFracture_Screen
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
        }else{
            NavigationView{//dihapus karena jelek jika item cuma 3
                ZStack{
                    VStack {
        //                Spacer().frame(height: 20)
                        List(filteredListDataPreviewFracture) {dataPreviewFractures in
                            ProcedureFractures_Button(dataPreviewFractures){locationFractures in
                                print("\(locationFractures) tertekan")
    
                                locationFractures_ProcedureFracture_Screen = locationFractures
                                print("hehe3 \(locationFractures_ProcedureFracture_Screen)")
                                currentScreen = .ProcedureFracture_Screen
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
        }
    }
}


#Preview {
    @State var a = AppScreen.contentView
    ContentView($a)
}

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

