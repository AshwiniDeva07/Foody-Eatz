/* 
Copyright (c) 2021 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct FoodItems : Codable {
	let location : String?
    let id: Int?
	let shopName : String?
	let price : String?
	let offer : String?
	let foodImage : String?
	let info : String?
	let foodName : String?

	enum CodingKeys: String, CodingKey {

		case location = "location"
		case shopName = "shopName"
		case price = "price"
		case offer = "offer"
		case foodImage = "foodImage"
		case info = "info"
		case foodName = "foodName"
        case id = "id"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		location = try values.decodeIfPresent(String.self, forKey: .location)
		shopName = try values.decodeIfPresent(String.self, forKey: .shopName)
		price = try values.decodeIfPresent(String.self, forKey: .price)
		offer = try values.decodeIfPresent(String.self, forKey: .offer)
		foodImage = try values.decodeIfPresent(String.self, forKey: .foodImage)
		info = try values.decodeIfPresent(String.self, forKey: .info)
		foodName = try values.decodeIfPresent(String.self, forKey: .foodName)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
	}

}
