# LINEスタンプbot

## プロジェクトの初期化

```bash
# ディレクトリの作成と移動
mkdir line-sticker-bot
cd line-sticker-bot

# npmプロジェクトの初期化
npm init -y
```

## パッケージインストール

```bash
# ExpressフレームワークとLINE SDKのインストール
npm install express @line/bot-sdk dotenv
# nodemonのインストール
npm install --save-dev nodemon
```

## ngrokのインストール

ローカルで動作確認を行う場合にngrokを使用します。

```bash
# ngrokのインストール
curl -s https://ngrok-agent.s3.amazonaws.com/ngrok.asc | sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null && echo "deb https://ngrok-agent.s3.amazonaws.com buster main" | sudo tee /etc/apt/sources.list.d/ngrok.list && sudo apt update && sudo apt install ngrok

# ngrokの認証
ngrok config add-authtoken [ngrokの認証トークン]
```

※ ngrokの認証トークンは[こちら](https://dashboard.ngrok.com/get-started/setup/linux)から取得できます。

## ngrokの起動

```bash
# ポート3000でサーバーを起動
npm run dev
# ngrokでローカルサーバーを公開
ngrok http 3000
```

## LINE Developersの設定

1. [LINE Developers Console](https://developers.line.biz/console/)にログイン

2. 新規プロバイダーの作成
   - 「新規プロバイダー作成」をクリック
   - プロバイダー名を入力（例：StampBot）
   - 「作成」をクリック

3. 新規チャネルの作成
   - 「Messaging API」を選択
   - 以下の項目を入力：
     - チャネル名
     - チャネル説明
     - 大業種・小業種
     - メールアドレス
   - 利用規約に同意して「作成」をクリック

※ 仕様変更により、新規チャネルを作成できなくなりました。
   [LINE official account manager](https://manager.line.biz)でMessaging APIを有効にする必要があります。

4. チャネルの設定
   - チャネルシークレットをメモ（.envファイルで使用）
   - Messaging API設定タブでチャネルアクセストークンを発行しメモ
   - Webhook URLに ngrok の URL + `/webhook` を設定
     （例：https://xxxx-xxxx-xxxx-xxxx.ngrok.io/webhook）
   - Webhookの利用をオンに設定
   - 応答メッセージをオフに設定

5. ボットの友だち追加
   - Messaging API設定タブにあるQRコードを読み取り、ボットを友だち追加

## URL

- [LINE Developers](https://developers.line.biz)
- [LINE official account manager](https://manager.line.biz)
- [ngrok](https://dashboard.ngrok.com)