//
//  CustomError.swift
//  UDEMX-Intern
//
//  Created by István Juhász on 2023. 02. 13..
//

import Foundation

enum CustomError: String, Error {
    case invalidURL = "The provided URL appears to be invalid or incorrect. Please check and try again."
    case urlSessionError = "Your request could not be finished. Please check your internet connectivity."
    case invalidResponse = "The server provided an invalid response. Please try again."
    case invalidData = "The data received from the server seems to be incorrect or invalid. Please try your request again."
}
