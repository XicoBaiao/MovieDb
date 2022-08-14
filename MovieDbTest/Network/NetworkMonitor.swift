//
//  NetworkMonitor.swift
//  MovieDbTest
//
//  Created by Baiao, Francisco Fonseca on 14/08/2022.
//

import Foundation
import Network


final class NetworkMonitor: ObservableObject {
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "Monitor")
    
    @Published var showSaveAlert = false
    
    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                #if targetEnvironment(simulator)
                if path.status == .unsatisfied {
                    self?.showSaveAlert = false
                } else {
                    self?.showSaveAlert = true
                }
                #else
                if path.status == .unsatisfied {
                    self?.showSaveAlert = true
                } else {
                    self?.showSaveAlert = false
                }
                #endif
                
            }
        }
        monitor.start(queue: queue)
    }
    
}
