//
//  ContentView.swift
//  Shared
//
//  Created by Takaya Ito on 2023/04/08.
//

import SwiftUI
import Combine

struct ContentView: View {
    @ObservedObject var vm = CaluculateDice()
    


    var body: some View {
        let width = CGFloat(UIScreen.main.bounds.width)
        // 画像サイズの縦幅と横幅が同じ
        let height = width
        
        VStack {
            ZStack {
                // 画面いっぱいの背景色を設定
                Color.headerGray
                    .edgesIgnoringSafeArea(.all)

                // ここに他のコンテンツを配置
                HStack{
                    Spacer()
                    Text("\(String(format: "%.0f", vm.timeElapsed))s")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .padding()
                    
                    Spacer()
                    if vm.timer != nil {
                        Button("停止") {
                            vm.timer?.invalidate()
                            vm.timer = nil
                        }
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.areaGray)
                        .overlay(
                            RoundedRectangle(cornerRadius: 0)
                                .stroke(Color.white, lineWidth: 0.2)
                        )
                    } else {
                        Button("再開") {
                            guard vm.timer == nil else { return }
                            vm.lastDate = Date()
                            vm.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                                if let lastDate = vm.lastDate {
                                    let currentDate = Date()
                                    vm.timeElapsed += currentDate.timeIntervalSince(lastDate)
                                    vm.lastDate = currentDate
                                }
                            }
                        }
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.areaGray)
                        .overlay(
                            RoundedRectangle(cornerRadius: 0)
                                .stroke(Color.white, lineWidth: 0.2)
                        )
                    }
                }
                .padding(.top, 10)
                .padding(.horizontal)
            }
            .frame(height: 65)
            

            ZStack{
                // 画面いっぱいの背景色を設定
                Color.black
                    .edgesIgnoringSafeArea(.all)
                
                GeometryReader { geometry in
                    VStack {
                        let paddingScreenWidth = CGFloat(8)
                        let screenWidth = geometry.size.width - paddingScreenWidth * 2
                        let scaleFactor = screenWidth / 537
                        Spacer()
                        
                        
                        ZStack {
                            Image("JamicaImage")
                                .resizable()
                                .scaledToFit()
                                .frame(width: screenWidth)
                            
                            // 真ん中のサイコロ
                            Image("b\(vm.dice2Result)")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 73  * scaleFactor)
                            
                            // 上のサイコロ
                            Image("w\(vm.dicesToFindResult[0])")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 73  * scaleFactor)
                                .offset(x: 0, y: -350 * scaleFactor / 2)
                            
                            // 下のサイコロ
                            Image("b\(vm.dice1Result)")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 73 * scaleFactor)
                                .offset(x: 0, y: 330 * scaleFactor / 2)
                            
                            // 右上のサイコロ
                            Image("w\(vm.dicesToFindResult[1])")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 73 * scaleFactor)
                                .offset(x:  295 * scaleFactor / 2, y: -180 * scaleFactor / 2)
                            // 右下のサイコロ
                            Image("w\(vm.dicesToFindResult[2])")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 73 * scaleFactor)
                                .offset(x: 295 * scaleFactor / 2, y: 170 * scaleFactor / 2)
                            
                            // 左上のサイコロ
                            Image("w\(vm.dicesToFindResult[3])")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 73 * scaleFactor)
                                .offset(x: -297 * scaleFactor / 2, y: -180 * scaleFactor / 2)
                            // 左下のサイコロ
                            Image("w\(vm.dicesToFindResult[4])")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 73 * scaleFactor)
                                .offset(x: -297 * scaleFactor / 2, y: 170 * scaleFactor / 2)
                            
                            
                            Button("遊び方") {
                                vm.showRule = true
                            }
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.areaGray)
                            .overlay(
                                RoundedRectangle(cornerRadius: 0)
                                    .stroke(Color.white, lineWidth: 0.2)
                            )
                            .offset(x: 400 * scaleFactor / 2, y: 410 * scaleFactor / 2)
                        }
                        
                        Button(action: {
                            vm.reset()
                            vm.countTappedButton()
                            
                            vm.timer?.invalidate()
                            vm.timer = nil
                            vm.timeElapsed = 0
                            guard vm.timer == nil else { return }
                            vm.lastDate = Date()
                            vm.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                                if let lastDate = vm.lastDate {
                                    let currentDate = Date()
                                    vm.timeElapsed += currentDate.timeIntervalSince(lastDate)
                                    vm.lastDate = currentDate
                                }
                            }
                        }) {
                            Text("サイコロを振る")
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.areaGray)
                                .foregroundColor(.white)
//                                .cornerRadius(8)
                            
                        }
                        .padding(.horizontal, paddingScreenWidth)
                        
                        Button(action: {
                            vm.displaySolution()
                        }) {
                            Text("回答を表示する")
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.areaGray)
                                .foregroundColor(.white)
//                                .cornerRadius(8)
                        }
                        .padding(.horizontal, paddingScreenWidth)
                        
                        
                        if vm.display != "" {
                            VStack{
                                Text("\(vm.display)")
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.areaGray)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 0) // 角の丸みを設定
                                            .stroke(Color.red, lineWidth: 1) // 枠線の色と太さを設定
                                    )
                                    .foregroundColor(.white)
                            }
                            .padding(.horizontal, paddingScreenWidth)
                        } else {
                            VStack{
                                Text(" ")
                                    .padding()
                            }
                        }
                        Spacer()
                    }
                    .alert(isPresented: $vm.showAlert) {
                        Alert(
                            title: Text("通知"),
                            message: Text("起動してからゲームを\(vm.buttonTappedCount)回プレイしました。"),
                            dismissButton: .default(Text("OK")) {
                                vm.showAlert = false
                            }
                        )
                    }
                    .background(
                        VStack {
                            Spacer()
                        }
                        .alert(isPresented: $vm.showRule) {
                            Alert(
                                title: Text("遊び方"),
                                message: Text("5つの白いサイコロの出目を四則演算して、2つの黒いサイコロの出目の和を求めるゲームです。"),
                                dismissButton: .default(Text("OK")) {
                                    vm.showRule = false
                                }
                            )
                        }
                    )
                    .onAppear{
                        vm.reset()
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension Color {
    static let headerGray = Color(red: 39 / 255, green: 39 / 255, blue: 38 / 255)
    static let areaGray = Color(red: 36 / 255, green: 36 / 255, blue: 34 / 255)

}
