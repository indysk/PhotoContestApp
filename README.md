# README

## 1. アプリの概要
『Photo Contest』
写真コンテストを手軽に行うためのアプリケーションです。
ユーザ登録をし、コンテストの作成や、作品の投稿、投票を行うことができます。
![2021-10-28 19_49_16-Window](https://user-images.githubusercontent.com/87873292/139241445-fdac94ff-d45c-4c47-afd3-b27be65ef063.png)
![2021-10-28 18_26_53-Window](https://user-images.githubusercontent.com/87873292/139228374-68a37f3c-6c0d-4406-a28a-d8e2a311baae.png)


## 2. 使用技術
- Docker/Docker Compose
  - Ruby
  - Ruby on Rails
  - Nginx
  - Unicorn
- AWS
  - EC2(Linux,Docker)
  - RDS(MySQL)
  - S3(画像サーバ)

以下の画像はAWSの構成図です。
![PhotoContest Diagram drawio](https://user-images.githubusercontent.com/87873292/139026225-0165b068-d95a-4487-aa07-1c5bb73b045c.png)



## 3. 機能一覧
- ユーザ登録、ログイン機能(devise)
- 写真コンテスト作成 / 作品投稿 / 投票 / 結果表示
- ページネーション(kaminari) / 無限スクロール(kaminari,Ajax)
- 写真コンテストのURL限定公開機能
- 画像投稿・リサイズ機能(Carrierwave,MiniMagick)
等...

## 4. こだわったポイント
#### タブの無限スクロール
無限スクロールの実装は比較的容易に実現できましたが、タブ内のコンテンツにおける無限スクロールの実装は大変でした。
以下に実装前にアイデアを整理するために作成した図を示します。簡単に書けば以下の通りです。
1. タブ内の固有の値(ターゲット)をAjaxでサーバへ送信
2. ターゲットに合わせた内容を返却
3. ターゲットの値とタブコンテナ固有の値が一致する場所で展開する
![S__39116803](https://user-images.githubusercontent.com/87873292/139099508-f20bc36d-6248-4dea-8a01-3406dca0f52a.jpg)

#### URL限定公開機能
コンテストを非公開で開催したい場合のために、URL限定公開を実装しました。
実装方法は簡単に書けば以下のとおりです。パスワードの管理に使用するようなセキュリティを強化した実装は見送りました。また、もっとうまい実装がある気がしますが私の知識ではこの程度が限界でした。
1. モデルに限定公開URL用のカラムと、非公開設定の状態を記録するカラムを追加する
2. コンテスト一覧表示では非公開状態のコンテストを除外する
3. ページの検索では非公開URLと公開URLで検索する

#### 作品一覧ではオリジナル画像は遅延読み込み
作品に使用されるような一眼レフで撮影された写真データはとても重いので、通信容量削減、また画像表示の遅さ改善のため、作品のオリジナル画像を遅延読み込みすることにしました。
CarrierwaveとMiniMagickを用いてリサイズした画像を作品一覧に使用します。
作品の詳細表示はモーダルで実装しているので、モーダルが表示されるタイミング、丁寧に言えばモーダルの表示されるきっかけとなる要素のクリックをトリガーとして、モーダル内のimg要素にjsでURLを埋め込んで遅延読み込みを実装しています。

#### docker環境構築、コマンド一行の変更でdevelop環境とproduction環境の変更が可能
docker-composeファイルやNginxの設定ファイルはdevelop環境とproduction環境で異なるので、production環境ではdocker-composeコマンドに
```
-f docker-compose.production.yml
```
を追加するだけで使い分けられるようにしました。

#### 投票、投票結果表示機能
投票フォームの作成や投票レコードの保存、投票結果の表示の実装は思っていたより大変だったのでここで紹介させてください。
投票画面は以下の画像の通りです。各ユーザに持ち点があり、それぞれの作品に点を割り振っていきます。
![2021-10-28 18_26_53-Window](https://user-images.githubusercontent.com/87873292/139228374-68a37f3c-6c0d-4406-a28a-d8e2a311baae.png)

投票にはコンテストid、作品id、ユーザid、得点のカラムを持ったモデルを用意しました。蛇足ですが、コンテストidは作品idから辿れますが、効率化を考えてモデルに含めました。
```rb
create_table "votes", id: :string, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
  t.string "contest_id", null: false
  t.string "photo_id", null: false
  t.string "user_id", null: false
  t.datetime "created_at", null: false
  t.datetime "updated_at", null: false
  t.integer "point", null: false
  t.index ["contest_id"], name: "fk_rails_2e961e225e"
  t.index ["photo_id"], name: "fk_rails_e0710e95e4"
  t.index ["user_id"], name: "fk_rails_c9b3bef597"
end
```
複数の作品に得点を割り振った場合、レコードを複数保存する必要があるので普通の方法ではうまくいきませんでした。そこである工夫をして実装をしました。
今回投票フォームから取得したい情報は作品idとその得点です。また、ユーザには得点を入力してもらいたいのでnumber_fieldを用います。
例えば、number_fieldを以下のように記述し、ブラウザ上で例えば「3]と入力して送信するとラベルと値の両方が返ってきて、ラベルをparamsのキーにして値を取り出すのが一般的です。
```rb
f.number_field "vote"
# params[:model][:vote] ==> 3
```
今回欲しい値は得点と作品idの2つなので、このラベルに作品idを使用すればどちらの値も取得できそうな気がします。
```rb
f.number_field photo.id
```
実際、この実装で送信されるデータを使えば目的は達成できますが、もし他にも取得したい項目があった場合に困ります。
例えば、コンテストの総評(comment)や作品へのコメント(brief comment)を書き込む項目があったとします。そのときparamsの構造は以下のようになってしまいます。
```
params
  └ model
    ├ 0(作品id): 2pt
    ├ 1(作品id): 1pt
    ├ 2(作品id): 4pt
    ├ comment: 今回のコンテストの作品はレベルが高く素晴らしいコンテストでした。
    ├ 0(作品id): 青空がきれいでした
    ├ 1(作品id): 自然な表情がよく撮れていると思います
    └ 2(作品id): まるで絵のようですごく良い写真です
```
ポイントを保存する処理はfor文やeach文で回したいので、そのデータの中にcommentなどが入っていると邪魔になります。また、ポイントとコメントはそれぞれラベルを作品idにしなければならないので、同じ階層に同じ作品idが複数存在し、またどちらがポイント/コメントであるか判断できないため不都合が生じてしまいます。そこで階層を次のように修正すれば良いだろうと考えます。
```
params
  └ model
    ├ vote
    │ ├ 0(作品id): 2pt
    │ ├ 1(作品id): 1pt
    │ └ 2(作品id): 4pt
    │
    ├ brief_comment
    │ ├ 0(作品id): 青空がきれいでした
    │ ├ 1(作品id): 自然な表情がよく撮れていると思います
    │ └ 2(作品id): まるで絵のようですごく良い写真です
    │
    └ comment: 今回のコンテストの作品はレベルが高く素晴らしいコンテストでした。
```
階層を一つ下げて送信すればそれぞれの情報でまとまって扱いやすくなります。そしてこれをnumber_fieldでは以下のように実装します。これによって、データをより欲しい形に近づけることができました。
```rb
f.number_field "vote[#{photo.id}]"
```
投票レコードの保存では複数レコードの保存が必要で苦労しました。また、投票結果の出力では総合得点を計算、順位に応じてHTML、CSSを変更し表示を工夫する必要があったためそこでも苦労しました。

#### その他
- Unicornワーカーを定期的にリフレッシュ(unicorn-worker-killer)
- 画像のExifデータをフォームへ自動書き込み
- ユーザ登録、ログイン後に以前アクセスしたページにリダイレクト
- モデルのidをランダム英数字に変更
