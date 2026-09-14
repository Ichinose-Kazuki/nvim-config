# Neovim 設定 (nixvim)

[nixvim](https://github.com/nix-community/nixvim) で組み立てた Neovim 環境。単体パッケージとしても
home-manager モジュールとしても使える flake。

## 構成

| パス | 役割 |
| --- | --- |
| `flake.nix` | flake outputs。単体パッケージ (`packages.default`)、home-manager モジュール (`homeModules.default`)、formatter (`nixfmt`) を定義 |
| `core.nix` | `myNvim` モジュール本体。オプションを定義し、`makeNixvimWithModule` で設定一式をパッケージ化する |
| `hm.nix` | home-manager 用ラッパー。`myNvim.finalPackage` を `home.packages` に追加するだけの薄いモジュール |
| `nixvimConfig/` | nixvim モジュール本体 (`options.nix` / `clipboard.nix` / `keymaps.nix` / `colorscheme.nix` / `plugins/`) |

nixvim が管理していないプラグインは `flake = false` の flake input としてリビジョンを pin している
（gitgraph.nvim、namu.nvim、nvim-spectre、grug-far.nvim、incline.nvim、nvim-scrollbar、
telescope-live-grep-args.nvim）。

## myNvim オプション (`core.nix`)

| オプション | 値 | デフォルト | 説明 |
| --- | --- | --- | --- |
| `myNvim.enable` | bool | `false` | この設定を有効化する |
| `myNvim.fileExplorer` | `"oil"` / `"neo-tree"` | `"oil"` | ファイラの選択 |
| `myNvim.colorscheme` | `"vscode"` / `"tokyonight"` / `"catppuccin"` | `"vscode"` | カラースキーム |
| `myNvim.lsp.servers` | 下記サーバのリスト | 全サーバ | 有効にする LSP サーバ |
| `myNvim.plugins.git.enable` | bool | `true` | neogit / diffview / gitsigns / gitgraph |
| `myNvim.plugins.zen.enable` | bool | `true` | zen-mode / no-neck-pain |
| `myNvim.plugins.dashboard.enable` | bool | `true` | alpha ダッシュボード |

LSP サーバは enum 制限: `lua_ls` / `nil_ls` / `ts_ls` / `html` / `cssls` / `jsonls` / `pyright` /
`clangd` / `bashls` / `yamlls`

`myNvim.package`（ビルド結果、readOnly）と `myNvim.finalPackage`（インストール対象）は分かれており、
`finalPackage` を override すれば sandbox wrap などの後処理を挟める。

## プラグイン構成

- **LSP**: lspconfig（サーバは上記 enum）+ glance（定義・参照のフロートプレビュー）、
  tiny-inline-diagnostic（`virtual_text` を無効化してインライン表示）
- **補完**: blink.cmp（LSP capability 接続、ghost text、シグネチャヘルプ）+ luasnip / friendly-snippets
- **検索**: telescope（fzf-native、ui-select、smart-open、live-grep-args）+ grug-far / nvim-spectre（プロジェクト置換）
- **ファイラ**: oil（float、`no-neck-pain` 幅に合わせる）または neo-tree。コピー系キーマップ
  （`<leader>yf` / `<leader>yp` / `<leader>yr`）を両ファイラに同名で用意
- **Git**: neogit、diffview、gitsigns、gitgraph
- **フォーマット**: conform-nvim。`prettierd` / `stylua` / `ruff` / `nixpkgs-fmt` / `shfmt` / `clang-format` を同梱
- **Treesitter**: highlight / indent / context / textobjects
- **UI**: lualine、bufferline、which-key、noice、notify、alpha、incline、nvim-scrollbar、markview、
  nvim-ufo、indent-blankline、todo-comments、web-devicons
- **その他**: flash、comment、nvim-autopairs、toggleterm
- **クリップボード**: `+` レジスタのプロバイダを OSC 52 に固定。外部クリップボードツールなしで、
  tmux 配下かどうかを問わず y/p が端末のクリップボードに繋がる

## 主要キーマップ

leader は `<Space>`。すべてのキーマップは `keymaps.nix` と各プラグインファイル参照。

### 検索・ファイル

| キー | モード | 動作 |
| --- | --- | --- |
| `<C-p>` | n / i | ファイル名検索 (Telescope) |
| `<C-f>` | n | プロジェクト grep (live-grep-args、隠しファイルも対象) |
| `<C-f>` | i | バッファ内検索 |
| `<leader><leader>` | n | smart-open（開いた頻度順のファイル選択） |
| `<leader>e` / `<leader>E` | n | oil / neo-tree トグル |
| `<leader>ft` | n | TODO 検索 |

### 編集・保存

| キー | モード | 動作 |
| --- | --- | --- |
| `<C-s>` | n / i | フォーマットして保存 |
| `<leader>cf` | n / v | フォーマット |
| `<C-/>` | n / v / i | コメントトグル |
| `s` / `S` | n / x / o | Flash jump / treesitter 選択 |
| `<A-j>` / `<A-k>` | v | 選択行の移動 |
| `<C-c>` / `<C-v>` | v / i | クリップボードへコピー / クリップボードから貼付 (OSC 52) |

### ウィンドウ・バッファ・端末

| キー | モード | 動作 |
| --- | --- | --- |
| `<C-h/j/k/l>` | n | ウィンドウ移動 |
| `<S-h>` / `<S-l>` | n | 前 / 次バッファ |
| `<leader>wv` / `<leader>wh` | n | 縦 / 横分割 |
| `<C-b>` | i / t | 端末パネル切替 (toggleterm) |
| `<C-n>` | n | 新規端末 |
| `<Esc>` | t | 端末モード脱出 |

### LSP・Git

| キー | モード | 動作 |
| --- | --- | --- |
| `gd` / `gr` / `K` | n | 定義 / 参照 / ホバー |
| `gpd` / `gpr` | n | Glance で定義 / 参照プレビュー |
| `<leader>ca` / `<leader>rn` | n | コードアクション / リネーム |
| `<leader>ss` | n | シンボル検索 (namu) |
| `<C-g>` または `<leader>gg` | n | Neogit |
| `<leader>gl` | n | Git graph |
| `<leader>gd` / `<leader>gD` | n | Diffview 開く / 閉じる |
| `]h` / `[h` | n | Git hunk 間移動 |

### 表示

| キー | モード | 動作 |
| --- | --- | --- |
| `<leader>z` | n | zen mode |
| `<leader>n` | n | no-neck-pain |
| `zR` / `zM` / `zK` | n | 全 fold 開く / 閉じる / peek (ufo) |

## ビルド確認

### 単体ビルド

```console
$ nix build .
$ ./result/bin/nvim        # ビルド結果で起動
$ nix run .                # そのまま起動してもよい
```

`packages.default` は `myNvim.enable = true` のみを設定して評価したものなので、
オプションはすべてデフォルト値（oil / vscode / 全 LSP サーバ）でビルドされる。
変更を試すには home-manager モジュール経由か `nix build` 前に flake を編集する。

解決だけ確認（実ビルドなし）:

```console
$ nix build . --dry-run
```

flakes が未有効の環境では `--extra-experimental-features 'nix-command flakes'` を付けるか、
`~/.config/nix/nix.conf` に `experimental-features = nix-command flakes` を書く。

### home-manager から使う

```nix
{
  inputs.my-nvim.url = "github:<owner>/<this-repo>";

  # home-manager の設定側で:
  imports = [ inputs.my-nvim.homeModules.default ];

  myNvim = {
    enable = true;
    # colorscheme = "catppuccin";
    # fileExplorer = "neo-tree";
    # lsp.servers = [ "lua_ls" "nil_ls" ];
  };
}
```

### フォーマット

```console
$ nix fmt                 # nixfmt
```
