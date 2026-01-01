//
//  ContentView.swift
//  ImageSearchApp
//
//  Created by Noman belim on 01/01/26.
//
import Foundation

struct Product: Identifiable {
    let id = UUID()
    let title: String
    let imageUrl: String
    let link: String
}
