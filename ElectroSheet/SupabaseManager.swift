//
//  SupabaseManager.swift
//  ElectroSheet
//
//  Created by DJShabsifhe on 2024/9/10.
//

import Foundation
import Supabase

class SupabaseManager {
    static let shared = SupabaseManager()
    let client: SupabaseClient

    private init() {
        client = SupabaseClient(supabaseURL: URL(string: "https://ltwakmanapvyxuvmpfpa.supabase.co")!,
                                supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imx0d2FrbWFuYXB2eXh1dm1wZnBhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjU4NDc0NjgsImV4cCI6MjA0MTQyMzQ2OH0.P0LKqD_B4pR2URIPA18z8QEMm_2rnniufJ4nm0IkGwI")
    }
    
    func signInWithApple(idToken: String, nonce: String) async throws -> Session{
        let session = try await client.auth.signInWithIdToken(credentials: .init(provider: .apple, idToken: idToken, nonce: nonce))
        return session
    }
    
    // sign in with email, etc
}
