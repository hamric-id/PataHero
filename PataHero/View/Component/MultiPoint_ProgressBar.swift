//
//  MultiPoint_ProgressBar.swift
//  PataHero
//
//  Created by Muhammad Hamzah Robbani on 30/03/25.
//

import SwiftUI

struct MultiPoint_ProgressBar: View {
    let numberOfSteps: UInt8
    @Binding var currentStep: UInt8
    
    init(_ numberOfSteps: UInt8 , _ currentStep1: Binding<UInt8>){
        self.numberOfSteps = numberOfSteps
        self._currentStep = currentStep1
    }
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(1...Int(numberOfSteps), id: \.self) { stepTo in
                StepCircle(UInt8(stepTo), stepTo <= currentStep){stepTo in
                    let stepTo = UInt8(stepTo)!
                    if stepTo != currentStep{ currentStep = stepTo}
                }
                
                if stepTo < numberOfSteps {
                    ConnectingLine( stepTo < currentStep)
                }
            }
        }
    }
}

struct StepCircle: View {
    private let description1: ContiguousArray<UInt8>//bisa angka atau huruf
    private let isCompleted: Bool
    @State private var isTouch:Bool=false
    @State var onClick: (String) -> Void
    
    private func description()->String{description1.String1()}
    
    private func touch(_ mode:Bool){
        isTouch=mode
        if !mode{onClick(description())}
    }
    
    init(_ description: String,_ isCompleted: Bool,_ onClick: @escaping (String) -> Void) {
        description1 = description.ContingousArray()
        self.isCompleted = isCompleted
        self.onClick=onClick
    }
    
    init(_ description: UInt8,_ isCompleted: Bool, _ onClick: @escaping (String) -> Void) {
        description1 = description.ContiguousArray1()
        self.isCompleted = isCompleted
        self.onClick=onClick
    }
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    isTouch ? Color("red") :
                        isCompleted ? Color("blue") : Color.gray, lineWidth: 2)
                .frame(width: 30, height: 30)
            
            if isCompleted {
                Circle()
                    .fill(isTouch ? Color("red") :  Color("blue"))
                    .frame(width: 30, height: 30)
            }
            
            Text(description())
                .font(.headline)
                .foregroundColor(isCompleted ? .white : .gray)
        }
        .simultaneousGesture(//harus terakhir setelah atur frame dan corner
            DragGesture(minimumDistance: 0)
                .onChanged { _ in touch(true)}
                .onEnded { _ in
                    touch(false)
                }
        )
    }
}

struct ConnectingLine: View {
    let isActive: Bool
    
    init(_ isActive: Bool){ self.isActive = isActive}
    
    var body: some View {
        Rectangle()
            .fill(isActive ? Color("blue") : Color.gray)
            .frame(height: 2)
            .frame(maxWidth: .infinity)
    }
}

struct ProgressBar: View {
    @State private var currentStep: UInt8 = 1
    
    var body: some View {
        VStack(spacing: 30) {
            MultiPoint_ProgressBar(UInt8(4), $currentStep)
            Text("Current Step: \(currentStep) of 4")
                .font(.headline)
            
            HStack(spacing: 20) {
                Button("Previous") {
                    if currentStep > 1 {
                        currentStep -= 1
                    }
                }
                .disabled(currentStep <= 1)
                .buttonStyle(.borderedProminent)
                
                Button("Next") {
                    if currentStep < 4 {
                        currentStep += 1
                    }
                }
                .disabled(currentStep >= 4)
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
    }
}

#Preview {
    ProgressBar()
}
