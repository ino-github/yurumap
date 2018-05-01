各ファイルの概要。

/********************
CGIスクリプト
********************/
index.cgi
 URLで参照するのはこのファイルのみ。
 ゆるキャラ地図のメインとなるファイル。

AjaxManager.cgi
　ajax処理を管理するファイル。
　ニュース表示、地図切り替え全て、
　このファイルを経由して行われる。

/********************
rubyクラス
********************/
DataManager.rb
　csvファイル読み込みの基底となるクラス。
　Data〜クラスはこのクラスを継承している。

DataArea1.rb
　data_area1.csv　を読み込むためのクラス。
　関東、関西、九州〜の大分類プルダウンの生成をする。

DataArea2.rb
　data_area1.csv　を読み込むためのクラス。
　東京、埼玉、栃木〜の小分類プルダウンの生成をする。

DataSpot.rb
　data_spot.csv　を読み込むためのクラス。
　地域毎のゆるキャラの一覧を取得する。
　ゆるキャラの詳細表示を生成する。

DataYuru.rb
　data_yuru.csv　を読み込むためのクラス。
　ゆるキャラの名前や地域を取得する。

DataHistory.rb
　data_history.csv　を読み込むためのクラス。
　News で表示する更新履歴の生成をする。

Common.rb
　共通クラス。各種初期設定値を持つ。

AccessCounter.rb
　アクセスカウンター管理用クラス。
　log/access_counter.txt にアクセス数を書き込む。
　サイト上ではアクセスカウンターは公開していない。

AccessLog.rb
　log/YYYYMM.log に年月毎にアクセスログを書き込む。
　サイト上ではログの公開はしていない。

/********************
javascript、CSS、他
********************/
style.css
　スタイルシートを定義

script.js
　javascript処理。
　画面表示や切替え、ユーザ操作を処理する。

jquery-1.11.0.js
 javascriput処理用の外部ライブラリ

index.html
　フォルダを一覧表示刺せないために設置している。

/********************
csvファイル
********************/
data_area1.csv
　関東、関西、九州〜の大分類を定義。
　
data_area2.csv
　東京、埼玉、栃木〜の小分類を定義。

data_spot.csv
　地図の座標や場所の解説などを定義。

data_yuru.csv
　ゆるキャラの設定を定義。

data_history.csv
　更新履歴。


/********************
フォルダ
********************/
log
　アクセスカウンタ、アクセスログを格納。

img
　画像ファイルを格納。