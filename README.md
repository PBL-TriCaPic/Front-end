# flutter_application_develop

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


# Tricapic開発のルール
  
## よく使うコマンド

git branch ：今いるブランチを見る

git switch ブランチ名 ：指定したブランチに飛ぶ

git switch -c ブランチ名 ：今いるブランチから新しくブランチをきる

git pull　：developブランチに移動し作業前に使用し最新の情報を取り込む

git rebase　ブランチ名　：作業ブランチに移動し基本developを指定して取り込む

ステージング（VScodeのソース管理の変更の＋ボタン。変更が加わっているファイル全部）

## ブランチの命名規則
  
developブランチから切り、「feature/#(イシュー番号)_わかりやすい名前」のブランチを作る。

例：feature/#1_header
  
※絶対日本語使わない

※マージは勝手にするな！

## 開発の流れ
1.Git HubでNew issueを作る。(内容は細かく, Assigneesに自分と一緒に作業してる人の名前を入れる)issueは機能ごとに作る。

2.vscodeで左下がdevelopの状態でターミナルを開き「git switch -c ブランチ名」で新しいブランチを作る。ブランチの命名規則は上に準ずる。

3.開発！gitignoreも書かないとね。

4.Git Hub左のソース管理を押してメッセージを記入。

5.下の変更にマウスのカーソルを当て、右側にある＋ボタンをクリック（ステージング）。

6.コミットをクリック

7.同期をクリック（push）

8.pull requestをする。GitHub上にその通知が来てたらそこから。来てなければNew pull requestから自分の作ったブランチを選択してCreate。

9.プルリクを送ったらDiscordのフロントエンドに報告