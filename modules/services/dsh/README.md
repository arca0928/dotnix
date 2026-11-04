# DSH Web サービス

`myconfig.services.dsh` は NixOS 用の opt-in module。現在は khaslana だけで有効。
ホストのデスクトップ設定を維持し、DSH は system service としてログイン前から起動する。

khaslana では sudo 権限のない専用ユーザー `agent` として実行する。
共有作業先は `/srv/projects`、永続データは `/home/agent/.dsh`（`0700`）、
サービスの umask は `0077`。待ち受けは `127.0.0.1:3080` のみ。

Cloudflare の既存 khaslana Tunnel に、次の公開経路を作成済み。

```text
https://dsh.arca0928.dev/ -> http://127.0.0.1:3080
```

`publicUrl` と `trustedHosts` にこのホスト名を設定する。
Tunnel の経路は Cloudflare 側で管理し、Host を保持して WebSocket を転送する。
DSH のトークン認証を使う。Cloudflare Access による追加の制限は未設定。

## 適用後の操作

```sh
sudo systemctl status dsh
sudo -iu agent dsh-chatgpt login
sudo -iu agent dsh-chatgpt status
sudo dsh-access-url
```

ChatGPT サブスクリプションの device code 認証には、DSH 同梱の
`llm-pi-ai` / `openai-codex` を使う。既定モデルは `gpt-6-sol`、推論強度は `medium`。
認証情報は DSH が `.credentials.yaml` に保存・更新し、Nix では内容を管理しない。
`dsh-chatgpt logout` は DSH に保存したローカル認証情報を削除する。
同じ `agent` ユーザーで動くプロセスは、その認証情報を読み取れる。

外部からは、共通の SSH alias を使って現在のトークン付き URL を取得する。

```sh
ssh -t khaslana 'sudo dsh-access-url'
```

取得した URL を本人のブラウザで開くと認証 Cookie が設定される。
トークンと有効な Cookie がなければ `401` になる。起動トークンは再起動で変わる。
`dsh-access-url` は root 権限で現在の起動分のログだけを読み、古い URL を返さない。
URL を Git や共有チャットに貼らない。

## 検証範囲

専用 VM で自動起動・再起動、ChatGPT への実リクエスト、ファイル操作、
認証情報の権限と削除、トークン付き URL の取得と更新を確認済み。
実機への適用、実機での初回ログイン、Tunnel 経由の実接続確認は別途行う。

他のホストでは `myconfig.services.dsh.enable = true;` で有効化できる。
既定の実行ユーザーは管理者ユーザー、保存先はそのホーム内の `.dsh`、作業先はホーム。
`user`、`workingDirectory`、`publicUrl`、`trustedHosts`、`extraPatches` を必要に応じて指定する。
ChatGPT 認証ヘルパーの導入には `chatgptAuthHelper = true;` を指定する。
