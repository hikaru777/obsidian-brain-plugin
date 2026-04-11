# obsidian-brain — AIエージェントの思考を育てるOS

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Claude Code Plugin](https://img.shields.io/badge/Claude%20Code-Plugin-7c3aed)](https://docs.claude.com/en/docs/claude-code/plugins)
[![MCP](https://img.shields.io/badge/MCP-compatible-blue)](https://modelcontextprotocol.io/)
[![Status](https://img.shields.io/badge/status-alpha-orange)]()

> AIエージェントの「長期記憶」ではなく**「長期人格」**をあなたのObsidian Vaultに育てる。
> ドメインごとに分かれた専属エージェントが、意思決定・信念・パターンを能動的に記録し、
> 互いに対話して知識を統合する。

obsidian-brain は Claude Code プラグインとして動作し、あなたの Obsidian Vault を
「複数の人格を持つ AI 用ブレイン」に変える。記憶を貯めるのではなく、**思考を育てる**ための OS である。

---

## 30秒デモ

![demo placeholder](./docs/hero.gif)

> Coming soon — プラグインを入れて最初の `record_decision` が Vault に書き込まれるまでを30秒で見せる。

---

## 90秒でインストール→初回の記録まで

### 1行インストール

```bash
claude plugin install hikaru777/obsidian-brain-plugin
```

これだけで MCP サーバー・14個のツール・3つの slash コマンド・SessionStart フックが一括でセットアップされる。

### 初回起動タイムライン

| 経過 | 何が起きるか |
|---|---|
| 0-30s  | `claude plugin install` が完了。`.mcp.json` と skills が登録される |
| 30-40s | `OBSIDIAN_BRAIN_VAULT_PATH` を環境変数にセット。Vault を自動検出 |
| 40-50s | `master` エージェント（人格層）と `default` エージェント（汎用ドメイン）が自動生成 |
| 50-70s | Claude との最初の会話で意思決定が発生 → `record_decision` が自動で走り Markdown に書き込まれる |
| 70-90s | `/brain-status` を叩くと、生まれたばかりのブレインの状態がテーブル表示される |

### Vault パスを教えるだけ

```bash
export OBSIDIAN_BRAIN_VAULT_PATH="/path/to/your/ObsidianVault/AI Brain"
```

設定はこれ1行。API キーも、クラウドサインアップも、ベクトル DB も要らない。

---

## 実際に試す — コピペサンプル

インストール直後に Claude に投げるだけで、Vault にファイルが生まれる。

### ① 最初の信念を記録する (`evolve_belief`)

```
僕の価値観と今の関心について、master エージェントに最初の信念を記録して。
「シンプルさを美徳として優先する」という信念を、理由付きで。
```

**期待される動き:** Claude が `evolve_belief` を `{agent: "master", title: "シンプルさを美徳として優先する", content: "...", reasoning: "..."}` で呼び、`AI Brain/master/beliefs/simplicity-as-virtue.md` が生成される。

✅ 成功判定: `/brain-status` を叩いて `master` 行に `beliefCount: 1` が見えれば OK。

### ② 意思決定を残す (`record_decision`)

```
次のプロジェクトは Rust ではなく Go で書くことに決めた、と tech エージェントに記録して。
理由は「チームの習熟度と運用実績」。
```

→ `AI Brain/tech/decisions/` に判断ログが Markdown で追加される。tech エージェントが未作成なら `suggest_agents` が走って自動で提案・作成される。

### ③ 繰り返しパターンを昇格する (`promote_pattern`)

```
「PR をマージする前に必ず self review する」っていう習慣が3回観測されたから、
tech エージェントでパターンとして昇格させて。
```

→ `AI Brain/tech/patterns/` に固定化されたパターンが生まれ、以後の `get_agent_context` で優先的に参照される。

---

## 何が違うのか — 「記憶を貯める」ではなく「思考を育てる」

世の中には「AI に記憶を持たせるツール」が山ほどある。obsidian-brain はそれらとは設計思想が違う。

**We are NOT:**
- もう一つの AI memory ツール (mem0 / Letta / Zep)
- basic-memory の競合 (markdown memory 軸では戦わない)
- RAG / 検索エンジン (retrievalではなく cognition)
- SaaS (local-first / Vault はあなたのもの)

**We ARE:**
- ドメインごとに人格を持つマルチエージェント — 「仕事用」「創作用」「健康用」など領域ごとに別の AI が育つ
- 能動的な認知プリミティブ — `record_decision` / `evolve_belief` / `promote_pattern` が思考の粒度で動く
- エージェント間の対話による知識統合 — `agent_dialogue` で人格同士が話し合って矛盾を解く
- 人間可読な Markdown — 全ての記録はあなたの Vault の普通のノートとして残る

ベクトル化もブラックボックスもない。すべてがあなたの目で読めて、あなたの手で編集できる。

---

## 比較表

| 項目 | **obsidian-brain** | mem0 | basic-memory | Smart Connections |
|---|---|---|---|---|
| ストレージ | Obsidian Markdown | Vector + Graph DB | Markdown + SQLite | Vault 内 embeddings |
| マルチエージェント | ドメイン分割 | フラット | フラット | なし |
| 能動的な思考記録 | 意思決定 / 信念 / パターン | retrieval 中心 | retrieval 中心 | retrieval 中心 |
| エージェント間対話 | `agent_dialogue` で実装 | なし | なし | なし |
| ローカル完結 | 完全ローカル | SaaS プランあり | hosted tier あり | ローカル |
| API キー必須 | 不要 | 一部必須 | 不要 | 不要 (Ollama 可) |
| 人間の可読性 | 100% plain Markdown | 低 (DB) | 中 | 中 |

---

## 提供するツール（14個）

MCP 経由で Claude Code から自動的に呼ばれる。ユーザーが覚える必要はない。

### Agent 管理
| ツール | 役割 |
|---|---|
| `list_agents` | 全エージェントと統計一覧 |
| `create_agent` | 新しいドメインエージェントを作成 |
| `suggest_agents` | 会話の文脈から必要なエージェントを提案 |
| `get_agent_context` | 特定エージェントの文脈取得 |

### 思考の記録
| ツール | 役割 |
|---|---|
| `record_decision` | 意思決定を記録 |
| `evolve_belief` | 信念の進化を記録 |
| `promote_pattern` | 繰り返し観測したパターンを昇格 |

### 検索と統合
| ツール | 役割 |
|---|---|
| `query_agent` | 特定エージェントへの問い合わせ |
| `search_across_agents` | 全エージェント横断検索 |
| `agent_dialogue` | エージェント同士を対話させて知を統合 |
| `consolidate_memory` | 古い記憶の整理とアーカイブ |
| `link_knowledge` | 知識間のリンク生成 |
| `detect_conflicts` | エージェント間・内部の矛盾検出 |
| `import_notes` | 既存の Obsidian ノートを取り込み |

---

## Slash コマンド（3個）

Claude Code のターミナルから直接叩ける。

| コマンド | 何をするか |
|---|---|
| `/brain-status` | 全エージェント・知識数・健全性のオーバービュー |
| `/brain-search <query>` | 全エージェント横断で知識を検索 |
| `/brain-consolidate` | 古い記憶を整理してアーカイブ（SessionStart フックで推奨される） |

---

## ユースケース

### エンジニア — 技術的意思決定ログ
`tech` エージェントが「なぜ Postgres を選んだのか」「なぜ Redis を捨てたのか」を記録し続ける。
半年後の自分が「あの時なんで Redis 捨てたんだっけ」と聞けば、当時の文脈ごと答えが返る。

### クリエイター — 美意識の進化
`craft` エージェントが、作品ごとに下した美的判断を `evolve_belief` で追跡する。
3年前のあなたの「美しさの定義」と今の定義の差分が、あなた自身に見える。

### 研究者 — 仮説と検証のログ
`research` エージェントが仮説→実験→結果の連鎖を `record_decision` と `promote_pattern` で記録する。
`detect_conflicts` が矛盾する結論を自動で拾い上げる。

---

## 手動インストール (Claude Code 以外の MCP クライアント向け)

```bash
npm install -g obsidian-brain-mcp
claude mcp add obsidian-brain npx obsidian-brain-mcp
```

環境変数 `OBSIDIAN_BRAIN_VAULT_PATH` を Vault へのパスに設定する。

---

## 動作要件

- Claude Code CLI (最新版推奨)
- Obsidian Vault (ローカルのフォルダで OK。Obsidian アプリは起動していなくてよい)
- Node.js 18+
- macOS / Linux / Windows

---

## Powered by

- [obsidian-brain-mcp](https://github.com/hikaru777/obsidian-brain-mcp) — コアとなる MCP サーバー実装
- [Model Context Protocol](https://modelcontextprotocol.io/) — ツール連携の標準
- [Claude Code](https://docs.claude.com/en/docs/claude-code) — ホスト環境

---

## Contributing

Issues / PRs welcome at [hikaru777/obsidian-brain-plugin](https://github.com/hikaru777/obsidian-brain-plugin).

「思考 OS」という方向性に共感する設計・ドキュメント・検証のいずれの貢献も歓迎する。

---

## License

MIT © 2026 hondahikaru
