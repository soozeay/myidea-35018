# README

## API概要
アイデアを管理するAPIです
アイデアはカテゴリとアイデア本文で構成されます

## 利用方法
現在ローカル環境のみで生成したAPIです。
Githubからダウンロード頂き、ご自身のPCから実行をお願い申し上げます
URLは下記の通り実行をお願いいたします
http://localhost:3000/api/v1/ideas  


## アイデアの登録機能
![f769bc299ac94838add4cc24b8669afd](https://user-images.githubusercontent.com/80019801/118446496-acc47e00-b72a-11eb-9023-5f49d6b7508e.gif)
このように、
リクエストをjson形式で
```
{  
  "category_name": "hogehoge",  
  "body": "hugahuga"
}  
```
と送信しますと、アイデアを登録することができます
レスポンスはステータス201以外にもsuccessのメッセージが表示されます

## アイデアの一覧表示機能（全て取得する場合）
![d598f3a3172aa9285a6d27d6a8663432](https://user-images.githubusercontent.com/80019801/118447248-83f0b880-b72b-11eb-8d2d-c7bcec826ed8.gif)
このように、リクエストに何も指定しない場合は全てのアイデアを取得することができます。  

## アイデアの一覧表示機能（特定のカテゴリのアイデアを全て取得）
![875f7089a247ab3057863f9bff8ec3c4](https://user-images.githubusercontent.com/80019801/118447904-43456f00-b72c-11eb-9d02-d9a70ec7a278.gif)
このように、
リクエストをjson形式で
```
{  
  "category_name": "hogehoge",  
}  
```
と送信しますと、このカテゴリに該当するアイデアを全て取得することができます  

## 使用環境
- Ruby 2.6.5
- Ruby on Rails 6.0.3.7
- DB MySQL
- 確認ツール：Postman

## バージョン
2021年5月17日 ver.1  

## テーブル設計
![myidea-35018](https://user-images.githubusercontent.com/80019801/118449201-df23aa80-b72d-11eb-9526-425f96351eab.png)


## categories テーブル
| Column        | Type       | Options                        |
| ------------- | ---------- | ------------------------------ |
| id            | bigint     | null: false                    |
| name          | string     | null: false, unique: true      |

### Association
- has_many: ideas


## ideas テーブル
| Column        | Type       | Options                        |
| ------------- | ---------- | ------------------------------ |
| id            | bigint     | null: false                    |
| body          | text       | null: false                    |
| categories_id | references | null: false, foreign_key: true |

### Association
- belongs_to: category