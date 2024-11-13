//
//  ContentView.swift
//  Ondevv5
//
//  Created by BillU on 2024-11-13.
//

import SwiftUI

struct ContentView: View {

    @State var bedsSlider : Double = 0.0

    @State var beds = ""
    @State var baths = ""
    @State var sqft = ""
    
    @State var price : Int?
    
    @State var errorMessage : String?
    @State var errorField : String?

    var body: some View {
        
        VStack {
            if price != nil {
                Text("\(price!)")
                    .font(.largeTitle)
            }
            
            if let errorMessage {
                Text(errorMessage)
                    .foregroundColor(Color.red)
            }
            
            VStack(alignment: .leading) {
                Text("Beds: \(Int(bedsSlider))")
                Slider(
                    value: $bedsSlider,
                    in: 0...10,
                    onEditingChanged: { isEditing in
                        predictPrice()
                    }
                )

            }

            VStack(alignment: .leading) {
                Text("Baths")
                    .foregroundColor(errorField == "baths" ? Color.red : Color.black)
                TextField("", text: $baths)
                    .background(Color.gray)
                    .border(Color.black, width: 1)
                    .cornerRadius(5)
            }

            VStack(alignment: .leading) {
                Text("Sqft")
                    .foregroundColor(errorField == "sqft" ? Color.red : Color.black)
                TextField("", text: $sqft)
                    .background(Color.gray)
                    .border(Color.black, width: 1)
                    .cornerRadius(5)
            }

            
            Button(action: {
                predictPrice()
            }) {
                Text("Predict price")
            }
        }
        .padding()
        
    }
    
    func predictPrice() {
        
        errorMessage = nil
        price = nil
        errorField = nil
        
        guard let bathsNumber = Int64(baths) else {
            errorMessage = "Invalid number of baths"
            errorField = "baths"
            return
        }
        guard let sqftNumber = Int64(sqft) else {
            errorMessage = "Invalid number of sqft"
            errorField = "sqft"
            return
        }

        do {
            let pricemodel = try NYrealestateModel(configuration: .init())
            
            let priceinput = NYrealestateModelInput(beds: Int64(bedsSlider), baths: bathsNumber, sqft: sqftNumber)
            
            let priceoutput = try pricemodel.prediction(input: priceinput)
            
            price = Int(priceoutput.tx_price)
            
        } catch {
            errorMessage = "Unknown error with model"
        }
        
    }
    
}

#Preview {
    ContentView(errorMessage: "Fel fel fel")
}
#Preview {
    ContentView(price: 323654)
}
