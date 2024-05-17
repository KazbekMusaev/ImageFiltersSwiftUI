//
//  ShareView.swift
//  AezakmiRegistrApp
//
//  Created by KazbekMusaev on 16.05.2024.
//

import SwiftUI

struct ShareView: UIViewControllerRepresentable {
    
    var image: UIImage
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        ()
    }
    
}
