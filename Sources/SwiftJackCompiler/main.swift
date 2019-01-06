import Lexer

let lexer = Lexer(source: "     ")
let results = try? lexer.getAllTokens()
print(results)
