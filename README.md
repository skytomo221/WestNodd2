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

### 環境構築

#### Visual Stuio Codeによる環境構築

1. Visual Studio Codeを起動する。
2. 拡張機能で[Remote - Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)をインストールする。
3. ステータスバーの左端にある![image](https://user-images.githubusercontent.com/18415838/137567497-f16c9ef4-ed2c-4f8e-bde4-d3d5f452787e.png)
をクリックする。
4. 「Reopen in Container」をクリックする。
5. ターミナルを開いて以下を実行

```bash
export DISCORD_NODD_BOT_TOKEN=# discord bot token
export DISCORD_NODD_GUILD_ID=# discord server ID
```

#### ターミナルによる環境構築

```shell
docker-compose up
docker-compose exec app /bin/bash
export DISCORD_NODD_BOT_TOKEN=# discord bot token
export DISCORD_NODD_GUILD_ID=# discord server ID
cd /workspace/
```

### ナンバー制関係

ナンバー制関係のプログラムのテストをするには以下のコマンドを用いる。

```sh
> dart test/number_test.dart
```
