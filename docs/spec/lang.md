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
- {x@number, y@number}:bind>frac << object,
- bool << object,
- string << object,
- regexp << object,
- domain << object,
- path << object,
- uri << object,
- url << uri,
- userid << object,
- twitterid << userid,
- discordid << userid,
- channelid << object,
- guilid << object,
- massageid << object,

### ジェネリクス型

最低限。

- or\[T,U],
- iterator\[T],
- iterator\[K,V],
- result\[R,E],
- maybe\[T]

### bind

- {el1,el2,el3}:bind>some
- some:unbind>{el1,el2,el3}

## 組込コマンド

- neko
- setnumber
- getnumber
- nick
- rank
