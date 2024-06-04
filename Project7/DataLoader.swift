//
//  DataLoader.swift
//  Project7
//
//  Created by Olha Pylypiv on 26.01.2024.
//

import Foundation

struct DataLoader {
    func downloadData(url: URL) async -> Data? {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return data
        } catch let error {
            print(error)
        }
        return nil
    }
}
