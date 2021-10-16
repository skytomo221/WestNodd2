# Nodd v2 コマンド言語 仕様案

## 方針

コマンドは推論型付きマクロ言語となるように構成したい(理想/できれば)

## 主要構文

- "@"　型注釈
- ":"　コマンド合成/プロパティ接続
- "|"　並列実行
- "+>"　逐次実行
- "?"　 nullable 　 T? = maybe\[T] = or\[T,null]
- ">"　右代入
- "<"　左代入
- "(" ")"　コマンドブロック

### 型関係

コマンド言語でありチューリング完全は想定していないので、最低限に留める。

また Discord bot として要すると思われるいくつかの型を追加

- anything
- object << anything,
- null << anything
- number << object,
- frac << object: {x@number, y@number}:bind,
- bool << object,
- string << object,
- regexp << object,
- domain << string,
- path << string,
- uri << object,
- url << uri: {domain@domain, path@path}:bind,
- userid << object,
- twitterid << userid,
- discordid << userid: {name@string, id@number}:bind,
- guildid << number,
- channelid << number,
- massageid << number,
- massagelink << object: {massage@massageid, channel@channelid, guild@guildid, base@url=url("https://discord.com/channels/")}:bind,
- invitelink << object: {id@string, base@url=url("https://discord.gg/")}:bind,
- code << object: {ident@string}:bind,
- isocode << code: {lang@string}:bind,
- clacode << code,
- function << object,
- error << object,

### ジェネリクス型

最低限。

- or\[T,U],
- iterator\[T],
- iterator\[K,V],
- result\[R,E],
- maybe\[T]

### 梱束体 bind

構造体(struct)のようなもの

- {el1,el2,el3}:bind>some
- some:unbind>{el1,el2,el3}

### 特性体 spec

両ストラクタ及びメソッド

## 組込コマンド

inheriting:

- neko
- setnumber
- getnumber
- nick

Next New:

- haishin broadcast settle
- info server / project info
- proi project manage
- rule
- poll voting support

Feature:

- rank communication ranking
- code cla-code / csc-code plugin
- migdal migdal plugin
- wiki migdal-wiki plugin
- lang con-lang info & search
- trans translate
