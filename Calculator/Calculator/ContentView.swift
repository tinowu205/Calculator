//
//  ContentView.swift
//  Calculator
//
//  Created by mac os on 2020/9/19.
//  Copyright © 2020 mac os. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    let num9t7 = ["9","8","7","*"]
    let num6t4 = ["6","5","4","-"]
    let num3t1 = ["3","2","1","+"]
    let char1 = ["C","+/-","%","/"]
    
    @State var text:String = ""
    
    @State var textStyle = UIFont.TextStyle.headline
    
//    let myX : Int = UIScreen.main.bounds.height>800 ? 200 : 180
//
//    let myY : Int = UIScreen.main.bounds.height>800 ? 400 : 250
    
    var body: some View {
        //Text("Hello, World!")
        ZStack{
            Color.init(red: 255/255.0, green: 231/255.0, blue: 168/255.0).edgesIgnoringSafeArea(.all)
            VStack {
//                TextField("",text: $text)
////                    .frame(width:400,height: 100)
////                    .background(Color.white)
//                    .frame(width: 360, height: 80, alignment: .leading)
//                    .padding(.leading)
//                    .font(.system(size: 50))
//                    .cornerRadius(10)
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 10)
//                            .stroke(lineWidth: 4)
//                            .foregroundColor(.black)
//                  )
                TextView(text: $text)
                    .frame(width: 375, height: 160, alignment: .leading)
                    .cornerRadius(25)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                        .stroke(lineWidth: 3)
                        .foregroundColor(Color.init(red: 255/255.0, green: 231/255.0, blue: 168/255.0))
                        .shadow(radius: 5)
                )
                ZStack{
                    VStack{
                        HStack {
                            ForEach(0..<char1.count){ index in
                                NumberView(text:self.$text, number:self.char1[index])
                            }
                        }
                        HStack {
                            ForEach(0..<num9t7.count){ index in
                                NumberView(text:self.$text, number:self.num9t7[index])
                            }
                        }
                        HStack {
                            ForEach(0..<num6t4.count){ index in
                                NumberView(text: self.$text,number:self.num6t4[index])
                            }
                        }
                        HStack {
                            ForEach(0..<num3t1.count){ index in
                                NumberView(text:self.$text ,number:self.num3t1[index])
                            }
                        }
                        HStack{
                            Image("Pikachu-256")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                                .position(x: 60, y: 50)
                            NumberView(text:$text ,number: "0").position(x: 48, y: 50)
                            NumberView(text:$text ,number: ".").position(x: 42, y:50)
                            NumberView(text:$text ,number: "=").position(x: 35, y: 50)
                        }
                    }
                    .position(x: 180, y: 250)
                }
            }
        }
    }
}



struct NumberView : View {
    @Binding var text : String
    
    @State var color:Color = Color.black
    
    @State var number:String
    
    var body: some View{
        ZStack{
            
            Circle()
                .frame(width:80, height:80)
                .foregroundColor(color)
            
            Text(number)
                .foregroundColor(Color.orange)
                .font(.system(size: 50))
            .onTapGesture(perform: {
                withAnimation(.easeInOut(duration: 0.3)){
                    self.color = Color.gray
                }
                withAnimation(.default){
                    self.color = Color.black
                }
                
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                
                if(self.number == "C"){
                    self.text = ""
                }else if(self.number == "+/-"){
                    
                }else if(self.number == "="){
//                    self.text = String(Plus(numberToPlus: OrganizeNum(numberToOrganize: self.text)))
                    var result : Float = 0.0
                    result = Plus(numberToPlus: Multiply(numberToMultiply: OrganizeNum(numberToOrganize: self.text) ) )
                    if(result == 000808){
                        self.text = "WrongExpression"
                    }else{
                        self.text = String(result)
                    }
                }else{
                    self.text.append(self.number)
                }
            })
        }.shadow(color:Color.black,radius: 3)
    }
}

enum errorChar : Error{
    case wrongExpression
}

func OrganizeNum(numberToOrganize : String) -> Array<String>{
    var numberString : String = ""
    var finalString : [String] = []
    var numberCnt = 0
    var charCnt = 0
    
    for scalar in numberToOrganize.unicodeScalars{
        if( Int(scalar.value)-48 <= 9 && Int(scalar.value)-48 >= 0 ){
            let ret = String.init(scalar)
            numberString.append(ret)
            
        }else if(Int(scalar.value) == 46){
            
            let ret = String.init(scalar)
            numberString.append(ret)
            
        }else{
            if(numberString.count > 0){
                finalString.append(numberString)
                numberCnt = numberCnt + 1
            }
            
            let symbol = String.init(scalar)
            finalString.append(symbol)
            numberString.removeAll()
            
            charCnt = charCnt + 1
        }
    }
    if(numberString.count>0){
        finalString.append(numberString)
        numberString.removeAll()
    }
    
    print(finalString)
    //bug1:当数字与运算符相等时有可能会报错： 999*
    if((charCnt > numberCnt || charCnt < numberCnt - 2) || finalString[0] == "" || finalString[0] == "*" || finalString[0] == "/"){
        print(errorChar.wrongExpression)
        return {["Wrong"]}()
    }else{
        return finalString
    }
}

func Plus(numberToPlus:Array<String>)->Float{
    var sum:Float = 0.0
    
    var model:Int = 1
    
    print("---plus")
    print(numberToPlus)
    
    if(numberToPlus[0] == "Wrong"){
        return 000808
    }
    if(numberToPlus[0] == "."){
        return 000808
    }
    if(numberToPlus[0] == "*" || numberToPlus[0] == "/"){
        return 000808
    }
    
    for num in numberToPlus{
        if(num != "+" && num != "-"){
            if(model == 1){
                sum += Float(num) ?? 0
            }else{
                sum -= Float(num) ?? 0
            }
        }else{
            if(num == "+"){
                model = 1
            }else{
                model = 0
            }
        }
    }
    
    return sum
}

func Multiply(numberToMultiply : Array<String>) -> Array<String>{
    var doneMultiply : Array<String> = []
    
    let express = numberToMultiply
    
    var unused : String = ""
    
    var temp :Float = 0.0
    
    for num in express{
        if(num == "*"){
            if(( (express
                .lastIndex(of: num) ?? 0) + 1) >= express.count ){
                return ["000808"]
            }
            let cnt1 = express[(express
                .lastIndex(of: num) ?? 0) + 1]
            print("---cnt1")
            print(cnt1)
            temp = (Float(doneMultiply.last ?? "0") ?? 1) * Float(cnt1)!
            
            doneMultiply.removeLast()
            
//            express.remove(at: (express
//            .lastIndex(of: num) ?? 0)+1)
            unused.append(express[(express
                        .lastIndex(of: num) ?? 0)+1])
            
            doneMultiply.append(String.init(temp))
        }else if(num == "/"){
            let cnt2 = express[(express
            .lastIndex(of: num) ?? 0) + 1]
            
            if(cnt2 == "0"){
                return ["000808"]
            }
            
            temp = (Float(doneMultiply.last ?? "0" ) ?? 1) / Float(cnt2)!
            
            doneMultiply.removeLast()
            
//            express.remove(at: express
//            .lastIndex(of: num) ?? 0 + 1)
            unused.append(express[(express
            .lastIndex(of: num) ?? 0)+1])
            
            doneMultiply.append(String.init(temp))
        }else{
            if(unused.contains(num)){
                
            }else{
                doneMultiply.append(num)
            }
            
        }
        
    }
    
    
    
    return doneMultiply
}

struct TextView : UIViewRepresentable {
    
    @Binding var text: String
    //@Binding var textStyle: UIFont.TextStyle
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator
        textView.isSelectable = false
        textView.font = .systemFont(ofSize: 70)
        textView.textContainerInset = UIEdgeInsets.init(top: 0, left: 5, bottom: 0, right: 5)
        textView.backgroundColor = UIColor.init(red: 238/255.0, green: 216/255.0, blue: 174/255.0, alpha: 1)
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
        //uiView.font = UIFont.preferredFont(forTextStyle: textStyle)
        uiView.scrollRangeToVisible(NSMakeRange(text.count, 1))
        switch text.count {
        case 6:
            uiView.font = .systemFont(ofSize: 65)
            
        case 7:
            uiView.font = .systemFont(ofSize: 60)
            
        case 8:
            uiView.font = .systemFont(ofSize: 55)
            
        case 9..<10000:
            uiView.font = .systemFont(ofSize: 50)
        default:
            uiView.font = .systemFont(ofSize: 70)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator($text)
    }
    
    class Coordinator: NSObject,UITextViewDelegate {
        var text : Binding<String>
        
        init(_ text: Binding<String>){
            self.text = text
        }
        
        func textViewDidChange(_ textView: UITextView) {
            self.text.wrappedValue = textView.text
            if let string = textView.text{
                print(string)
            }
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
