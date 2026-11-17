# DSH Web サービス

`myconfig.services.dsh.enable = true;` で有効化する NixOS module。
実行ユーザーの既定値は管理者ユーザー、保存先は `~/.dsh`、作業先はホーム。
`user`、`dataDir`、`workingDirectory`、`extraPackages` で変更できる。

khaslana では `agent` で実行し、作業先は `/srv/projects`、データは `/home/agent/.dsh`。
待ち受けは `127.0.0.1:3080`、保存先は `0700`、umask は `0077`。

## リモート接続

Cloudflare Tunnel の転送先を `http://127.0.0.1:3080` に設定し、
DSH の `publicUrl` と `trustedHosts` に公開先を指定する。
Host を保持し、WebSocket を転送する。
khaslana の公開先は `https://dsh.arca0928.dev/`。

```sh
ssh -t khaslana 'sudo dsh-access-url'
```

取得した URL をブラウザで開くと認証 Cookie が設定される。
トークンと有効な Cookie がなければ `401`。起動トークンは再起動で変わる。
URL は秘密情報として扱う。Cloudflare Access による追加の制限は未設定。

## ChatGPT 認証

`chatgptAuthHelper = true;` と `extraPatches` で `openai-codex` を設定する。

```sh
sudo -iu agent dsh-chatgpt login
sudo -iu agent dsh-chatgpt status
sudo -iu agent dsh-chatgpt logout
```

認証情報は DSH が `.credentials.yaml` に保存・更新する。
`logout` はローカルの認証情報を削除する。同じ実行ユーザーのプロセスは認証情報を読める。
