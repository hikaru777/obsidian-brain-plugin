# Hero GIF 作成ガイド

README.md 冒頭の `./docs/hero.gif` を差し替えるための手順メモ。
「見ただけで 30 秒以内に価値が伝わる」こと — それが唯一の合格基準だ。

## 要件

| 項目 | 値 |
|---|---|
| 長さ | 15 秒（ループ再生で違和感が出ないこと） |
| サイズ | 800 × 500 px（README で横幅余白なく表示される上限） |
| fps | 12–15 fps（GIF サイズを 2MB 未満に収める） |
| フォーマット | `.gif`（`./docs/hero.gif` に上書き配置） |
| 最大容量 | 2 MB — GitHub の README で遅延なく読み込める実用ライン |

## 映すべきカット

順に畳み掛けるように。テロップなし。キー入力の手元ではなくターミナルだけ映す。

1. **インストール** — `claude plugin install hikaru777/obsidian-brain-plugin` を打つ
2. **SessionStart 自動検出** — `[OBSIDIAN-BRAIN] Vault detected at ...` の行が流れる
3. **最初の記録** — 「Go に決めた、と tech エージェントに記録して」と Claude に話しかける
4. **`record_decision` 発火** — ツール呼び出しが可視化される
5. **Vault にファイル出現** — Finder または `ls` で `AI Brain/tech/decisions/*.md` が増えているのを見せる

最後の 1 秒は空白にせず、1 カット目にスムーズに戻してループ感を出す。

## 推奨ツール

| ツール | 用途 | 備考 |
|---|---|---|
| [VHS (charm.sh)](https://github.com/charmbracelet/vhs) | ターミナル操作から直接 GIF を生成 | `.tape` スクリプトで再現可能。一番おすすめ |
| [Gifski](https://gif.ski/) | mov → 高品質 GIF 変換 | QuickTime で画面録画 → Gifski がきれい |
| [LICEcap](https://www.cockos.com/licecap/) | 画面矩形を直接 GIF で録画 | お手軽だが色数に制約 |

### VHS サンプル（最有力）

```tape
# docs/hero.tape
Output docs/hero.gif
Set FontSize 18
Set Width 800
Set Height 500
Set Theme "Dracula"

Type "claude plugin install hikaru777/obsidian-brain-plugin"
Enter
Sleep 2s
Type "claude"
Enter
Sleep 1s
Type "Go で書くことに決めた、と tech エージェントに記録して"
Enter
Sleep 4s
```

`vhs docs/hero.tape` で `docs/hero.gif` が書き出される。

## 配置と反映

1. 生成した GIF を `docs/hero.gif` に上書き配置
2. `git add docs/hero.gif && git commit -m "docs: add hero gif"`
3. README をローカルでプレビューして読み込み速度と視認性を確認
4. OK なら push

## ありがちなミス

- **長すぎる** — 20 秒を超えると誰も最後まで見ない。15 秒で切れ
- **文字が小さい** — ターミナルのフォントは 18pt 以上。README で縮小表示される前提
- **説明的すぎる** — GIF は「動いている証拠」を見せる場所。言葉で説明したい気持ちは README 本文に逃がす
- **ファイルサイズ過大** — 2 MB を超えたら fps か色数を落とす。`gifsicle --optimize=3 --colors 128` が効く
