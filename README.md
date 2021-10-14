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

### ナンバー制関係

ナンバー制関係のプログラムのテストをするには以下のコマンドを用いる。

```sh
> dart test/number_test.dart
```
