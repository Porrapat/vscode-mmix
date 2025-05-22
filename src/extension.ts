import * as vscode from 'vscode';

const tokenTypes = ['function'];
const tokenModifiers: string[] = [];

export function activate(context: vscode.ExtensionContext) {
  const legend = new vscode.SemanticTokensLegend(tokenTypes, tokenModifiers);

  context.subscriptions.push(
    vscode.languages.registerDocumentSemanticTokensProvider(
      { language: 'mmix' },
      new class implements vscode.DocumentSemanticTokensProvider {
        provideDocumentSemanticTokens(document: vscode.TextDocument): vscode.ProviderResult<vscode.SemanticTokens> {
          const builder = new vscode.SemanticTokensBuilder(legend);
          const text = document.getText();
          const lines = text.split(/\r?\n/);

          const identifiers: string[] = [];

          // Step 1: Collect identifiers from lines
          const firstPassRegex = /^\b([A-Za-z]+[0-9]*|\d+H)\b\s/g;
          for (let lineNumber = 0; lineNumber < lines.length; lineNumber++) {
            const line = lines[lineNumber];
            let match;
            while ((match = firstPassRegex.exec(line))) {
              identifiers.push(match[1]); // use match[1] to get the captured group
            }
          }

          // Step 2: Build dynamic regex to find all identifiers
          if (identifiers.length > 0) {
            const extendedIdentifiers = new Set<string>();

            // ตรวจสอบว่า identifier จบด้วย H เช่น 2H แล้วเพิ่ม 2B, 2F เข้าไปด้วย
            identifiers.forEach(id => {
              extendedIdentifiers.add(id); // add original

              const match = /^(\d+)H$/.exec(id);
              if (match) {
                const prefix = match[1];
                extendedIdentifiers.add(`${prefix}B`);
                extendedIdentifiers.add(`${prefix}F`);
              }
            });

            // Escape for regex
            const escaped = Array.from(extendedIdentifiers).map(s => s.replace(/[.*+?^${}()|[\]\\]/g, '\\$&'));
            const secondPassRegex = new RegExp(`(?<!(\/\/|;|%|#\\s).*)\\b(${escaped.join('|')})\\b`, 'g');
            for (let lineNumber = 0; lineNumber < lines.length; lineNumber++) {
              const line = lines[lineNumber];
              let match;
              while ((match = secondPassRegex.exec(line))) {
                builder.push(
                  lineNumber,
                  match.index,
                  match[0].length,
                  0, // tokenType: 'function'
                  0
                );
              }
            }
          }

          return builder.build();
        }
      }(),
      legend
    )
  );
}

export function deactivate() {}
