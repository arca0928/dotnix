# khaslana

Headless 運用では `arca` を管理用、`agent` を Agent 実行用に使う。
`agent` に sudo 権限は付与しない。共有プロジェクトは `/srv/projects` に置く。

## Wi-Fi

NetworkManager がログイン前から接続するには、プロファイルを永続保存し、
`connection.autoconnect=yes`、`connection.permissions` を空にする。
WPA-PSK の認証情報は NetworkManager に保存し、`psk-flags=0` にする。
デスクトップの Secret Agent への保存は使わない。

Wi-Fi パスワードを Nix の設定や Git に含めない。

## DSH

[DSH の設定と操作](../../modules/services/dsh/README.md)を参照。

## Codex CLI

```sh
sudo -iu agent
codex login --device-auth
codex login status
```

`HOME=/home/agent`、認証情報は `/home/agent/.codex/auth.json` に保存する。
設定ファイルの `cli_auth_credentials_store` は `file`。
認証ディレクトリは `0700`、ファイルは `0600` とし、トークンは Codex に更新させる。
他ユーザーの認証ファイルをコピー・同期しない。

## SSH

管理者の公開鍵は `modules/services/openssh.nix` で宣言する。
接続端末に秘密鍵を保持し、サーバや Agent には配布しない。
既存の `~/.ssh/authorized_keys` も認証対象になるため、不要な鍵はそちらからも削除する。

実機のローカルパスワードは維持する。検証 VM のみ `arca` / `arca` でログインできる。
