import Vapor

@main
struct Run {
    static func main() async throws {
        let app = Application(.production)
        defer { app.shutdown() }

        app.http.server.configuration.hostname = "0.0.0.0"
        app.http.server.configuration.port = Environment.get("PORT").flatMap(Int.init) ?? 8080

        // simple health check helps Render
        app.get { _ in "OK" }

        app.get("chat") { req async throws -> Response in
            guard let key = Environment.get("OPENAI_API_KEY"),
                  let m = req.query[String.self, at: "m"], !m.isEmpty
            else { throw Abort(.badRequest, reason: "Set OPENAI_API_KEY and call /chat?m=your+message") }

            let body = #"{"model":"gpt-4o-mini","messages":[{"role":"user","content":"\#(m)"}]}"#

            let res = try await req.client.post("https://api.openai.com/v1/chat/completions") { r in
                r.headers.bearerAuthorization = .init(token: key)
                r.headers.contentType = .json
                r.body = .init(string: body)
            }
            return res
        }

        try app.run()
    }
}

