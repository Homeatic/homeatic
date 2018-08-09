import Vapor

/// Called after your application has initialized.
public func boot(_ app: Application) throws {
    // your code here
    let deleteTokens = app.requestPooledConnection(to: .sqlite)
        .flatMap { (connection) in
            return BearerToken.query(on: connection).delete()
        }
    try deleteTokens.wait()
}
