# Nodd_v2

Nodd 2.0 is a new version of Official SCJ Discord Bot. Nodd bot is originally for Numbering Server members, but now has integrated functions.

## Nodd とは？

<!-- Skytomoさん加筆よろ -->

## 機能

- ニックネーム管理
- ナンバー制管理
- age/sage 管理
- 配信スケジュール管理

## 開発履歴

### 1.x 系

<!-- Skytomoさん加筆よろ -->

### 2.x 系

- 2.0.0: SCJ の体制変革とナンバー制の変更があったことにより大幅改造が行われる。
  従来 Python で開発されていたが、`Discord.py`の Archive により、他の言語に改め書き直すことになった。
  開発環境・実行環境等の向上を鑑みて Dart が選ばれた。これより、Discord bot ライブラリは`Nyxx`を用いることとなる。

## 開発者向け

本番環境での稼働は LTS リリース(lts ブランチ)のソースを使用してください

### 環境変数の設定

#### Discord に関する環境変数の設定

|        環境変数名        |                 設定値                  |
| :----------------------: | :-------------------------------------: |
| `DISCORD_NODD_BOT_TOKEN` |            アクセストークン             |
| `DISCORD_NODD_GUILD_ID`  | スラッシュコマンドを使用するサーバー ID |

#### Google Sheets API に関する環境変数の設定

|             環境変数名              |                          設定値                          |
| :---------------------------------: | :------------------------------------------------------: |
|      `DISCORD_NODD_PROJECT_ID`      |                        project_id                        |
|    `DISCORD_NODD_PRIVATE_KEY_ID`    |                      private_key_id                      |
|     `DISCORD_NODD_PRIVATE_KEY`      |                       private_key                        |
|     `DISCORD_NODD_CLIENT_EMAIL`     |                       client_email                       |
|      `DISCORD_NODD_CLIENT_ID`       |                        client_id                         |
| `DISCORD_NODD_CLIENT_X509_CERT_URL` |                   client_x509_cert_url                   |
|    `DISCORD_NODD_SPREADSHEET_ID`    | SCJ Number を書き込み・読み込みするスプレッドシートの ID |

Google Cloud Platform からサービスアカウントキーを取得して以下の JSON ファイルの値に当てはまるように環境変数を設定してください。

```json
{
  "type": "service_account",
  "project_id": "",
  "private_key_id": "",
  "private_key": "",
  "client_email": "",
  "client_id": "",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": ""
}
```

`DISCORD_NODD_SPREADSHEET_ID`
は
`https://docs.google.com/spreadsheets/d/DISCORD_NODD_SPREADSHEET_ID/edit#gid=0`
の部分に該当します。

### 環境構築

#### Visual Stuio Code による環境構築

1. Visual Studio Code を起動する。
2. 拡張機能で[Remote - Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)をインストールする。
3. ステータスバーの左端にある![image](https://user-images.githubusercontent.com/18415838/137567497-f16c9ef4-ed2c-4f8e-bde4-d3d5f452787e.png)
   をクリックする。
4. 「Reopen in Container」をクリックする。
5. 環境変数の設定をする。

#### ターミナルによる環境構築

環境変数の設定をしてから、以下を実行する。

```shell
docker-compose up
docker-compose exec app /bin/bash
cd /workspace/
```

### ナンバー制関係

ナンバー制関係のプログラムのテストをするには以下のコマンドを用いる。

```sh
> dart test/number_test.dart
```
